import 'dart:io';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../core/core.dart';

/// Service for exporting data to CSV and PDF formats
class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  /// Export expenses to CSV
  Future<Result<String>> exportToCsv(List<Expense> expenses) async {
    try {
      final dateFormat = DateFormat(AppConstants.exportDateFormat);
      final List<List<dynamic>> rows = [];

      // Header row
      rows.add([
        'ID',
        'Title',
        'Category',
        'Amount',
        'Date',
        'Notes',
        'Created At',
      ]);

      // Data rows
      for (final expense in expenses) {
        final category = Category.getCategoryById(expense.category);
        rows.add([
          expense.id,
          expense.title ?? category.name,
          category.name,
          expense.amount.toStringAsFixed(2),
          dateFormat.format(expense.date),
          expense.notes ?? '',
          dateFormat.format(expense.createdAt),
        ]);
      }

      final csvData = const ListToCsvConverter().convert(rows);
      final timestamp = DateFormat(
        AppConstants.exportDateFormat,
      ).format(DateTime.now());
      final fileName = 'expenses_$timestamp.csv';

      final filePath = await _saveToFile(fileName, csvData);

      AppLogger.info(
        'Exported ${expenses.length} expenses to CSV',
        tag: 'ExportService',
      );
      return Result.success(filePath);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export to CSV',
        tag: 'ExportService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to export to CSV',
        code: 'EXPORT_CSV_ERROR',
        error: e,
      );
    }
  }

  /// Export expenses to PDF
  Future<Result<String>> exportToPdf(List<Expense> expenses) async {
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat(AppConstants.dateFormatDisplay);
      final currencyFormat = NumberFormat.currency(symbol: '\$');

      // Calculate totals
      final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
      final categoryTotals = <String, double>{};
      for (final expense in expenses) {
        categoryTotals[expense.category] =
            (categoryTotals[expense.category] ?? 0) + expense.amount;
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (context) => pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Expense Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  dateFormat.format(DateTime.now()),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          build: (context) => [
            // Summary Section
            pw.Header(level: 1, text: 'Summary'),
            pw.Paragraph(
              text: 'Total Expenses: ${currencyFormat.format(total)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Paragraph(text: 'Number of Transactions: ${expenses.length}'),
            pw.SizedBox(height: 20),

            // Category Breakdown
            pw.Header(level: 1, text: 'Category Breakdown'),
            pw.Table.fromTextArray(
              headers: ['Category', 'Amount', 'Percentage'],
              data: categoryTotals.entries.map((entry) {
                final category = Category.getCategoryById(entry.key);
                final percentage = (entry.value / total * 100).toStringAsFixed(
                  1,
                );
                return [
                  category.name,
                  currencyFormat.format(entry.value),
                  '$percentage%',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),

            // Transactions Table
            pw.Header(level: 1, text: 'Transactions'),
            pw.Table.fromTextArray(
              headers: ['Date', 'Description', 'Category', 'Amount'],
              data: expenses.map((expense) {
                final category = Category.getCategoryById(expense.category);
                return [
                  dateFormat.format(expense.date),
                  expense.title ?? category.name,
                  category.name,
                  currencyFormat.format(expense.amount),
                ];
              }).toList(),
            ),
          ],
        ),
      );

      final pdfBytes = await pdf.save();
      final timestamp = DateFormat(
        AppConstants.exportDateFormat,
      ).format(DateTime.now());
      final fileName = 'expenses_$timestamp.pdf';

      final filePath = await _saveBytesToFile(fileName, pdfBytes);

      AppLogger.info(
        'Exported ${expenses.length} expenses to PDF',
        tag: 'ExportService',
      );
      return Result.success(filePath);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export to PDF',
        tag: 'ExportService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to export to PDF',
        code: 'EXPORT_PDF_ERROR',
        error: e,
      );
    }
  }

  /// Save string content to file
  Future<String> _saveToFile(String fileName, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(content);
    return filePath;
  }

  /// Save bytes to file
  Future<String> _saveBytesToFile(String fileName, List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
