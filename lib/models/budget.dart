import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'budget.g.dart';

@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final BudgetPeriod period;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? categoryId;

  @HiveField(6)
  final String? name;

  @HiveField(7)
  final String currency;

  @HiveField(8)
  final int? month;

  @HiveField(9)
  final int? year;

  Budget({
    String? id,
    required this.amount,
    required this.period,
    required this.startDate,
    DateTime? createdAt,
    this.categoryId,
    this.name,
    this.currency = 'USD',
    this.month,
    this.year,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  DateTime get endDate {
    switch (period) {
      case BudgetPeriod.weekly:
        return startDate.add(const Duration(days: 7));
      case BudgetPeriod.monthly:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case BudgetPeriod.yearly:
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  double getDailyBudget() {
    switch (period) {
      case BudgetPeriod.weekly:
        return amount / 7;
      case BudgetPeriod.monthly:
        return amount / 30;
      case BudgetPeriod.yearly:
        return amount / 365;
    }
  }

  double getRemainingDays() {
    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return endDate.difference(startDate).inDays.toDouble();
    } else if (now.isAfter(endDate)) {
      return 0;
    }
    return endDate.difference(now).inDays.toDouble();
  }

  Budget copyWith({
    String? id,
    double? amount,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? createdAt,
    String? categoryId,
    String? name,
    String? currency,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'period': period.index,
      'startDate': startDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'categoryId': categoryId,
      'name': name,
      'currency': currency,
      'month': month,
      'year': year,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      amount: json['amount'].toDouble(),
      period: BudgetPeriod.values[json['period']],
      startDate: DateTime.parse(json['startDate']),
      createdAt: DateTime.parse(json['createdAt']),
      categoryId: json['categoryId'],
      name: json['name'],
      currency: json['currency'] ?? 'USD',
      month: json['month'],
      year: json['year'],
    );
  }

  @override
  String toString() {
    return 'Budget(id: $id, amount: $amount, period: $period, startDate: $startDate, categoryId: $categoryId, name: $name, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Budget && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 2)
enum BudgetPeriod {
  @HiveField(0)
  weekly,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly,
}
