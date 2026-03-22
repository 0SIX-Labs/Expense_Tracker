import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String? title;

  Expense({
    String? id,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    DateTime? createdAt,
    this.title,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Expense copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
    String? title,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, category: $category, date: $date, notes: $notes, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
