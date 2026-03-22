import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'custom_category.g.dart';

@HiveType(typeId: 6)
class CustomCategory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final bool isIncomeCategory;

  @HiveField(5)
  final DateTime createdAt;

  CustomCategory({
    String? id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    this.isIncomeCategory = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Color get color => Color(colorValue);

  List<Color> get gradient => [color, color.withOpacity(0.7)];

  CustomCategory copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    int? colorValue,
    bool? isIncomeCategory,
    DateTime? createdAt,
  }) {
    return CustomCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      isIncomeCategory: isIncomeCategory ?? this.isIncomeCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'isIncomeCategory': isIncomeCategory,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomCategory.fromJson(Map<String, dynamic> json) {
    return CustomCategory(
      id: json['id'],
      name: json['name'],
      iconCodePoint: json['iconCodePoint'],
      colorValue: json['colorValue'],
      isIncomeCategory: json['isIncomeCategory'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'CustomCategory(id: $id, name: $name, isIncomeCategory: $isIncomeCategory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
