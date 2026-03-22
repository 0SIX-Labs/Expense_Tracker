import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'income.g.dart';

@HiveType(typeId: 4)
class Income extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final IncomeCategory category;

  @HiveField(3)
  final String? customCategoryName;

  @HiveField(4)
  final int month;

  @HiveField(5)
  final int year;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime date;

  Income({
    String? id,
    required this.amount,
    required this.category,
    this.customCategoryName,
    required this.month,
    required this.year,
    this.notes,
    DateTime? createdAt,
    DateTime? date,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       date = date ?? DateTime.now();

  String get displayName {
    if (category == IncomeCategory.other && customCategoryName != null) {
      return customCategoryName!;
    }
    return category.displayName;
  }

  Income copyWith({
    String? id,
    double? amount,
    IncomeCategory? category,
    String? customCategoryName,
    int? month,
    int? year,
    String? notes,
    DateTime? createdAt,
    DateTime? date,
  }) {
    return Income(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      customCategoryName: customCategoryName ?? this.customCategoryName,
      month: month ?? this.month,
      year: year ?? this.year,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category.index,
      'customCategoryName': customCategoryName,
      'month': month,
      'year': year,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'date': date.toIso8601String(),
    };
  }

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      amount: json['amount'].toDouble(),
      category: IncomeCategory.values[json['category']],
      customCategoryName: json['customCategoryName'],
      month: json['month'],
      year: json['year'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      date: DateTime.parse(json['date']),
    );
  }

  @override
  String toString() {
    return 'Income(id: $id, amount: $amount, category: $category, displayName: $displayName, month: $month, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Income && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 5)
enum IncomeCategory {
  @HiveField(0)
  salary,
  @HiveField(1)
  freelance,
  @HiveField(2)
  investment,
  @HiveField(3)
  business,
  @HiveField(4)
  rental,
  @HiveField(5)
  other;

  String get displayName {
    switch (this) {
      case IncomeCategory.salary:
        return 'Salary';
      case IncomeCategory.freelance:
        return 'Freelance';
      case IncomeCategory.investment:
        return 'Investment';
      case IncomeCategory.business:
        return 'Business';
      case IncomeCategory.rental:
        return 'Rental Income';
      case IncomeCategory.other:
        return 'Other';
    }
  }
}
