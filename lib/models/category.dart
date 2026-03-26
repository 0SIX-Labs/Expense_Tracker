import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.gradient,
  });

  // Pre-defined categories optimized for white text contrast with Glass theme
  static const List<Category> defaultCategories = [
    Category(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.restaurant,
      color: Color(0xFFE74C3C), // Darker red for better white text contrast
      gradient: [Color(0xFFE74C3C), Color(0xFFC0392B)],
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF16A085), // Darker teal for better white text contrast
      gradient: [Color(0xFF16A085), Color(0xFF138D75)],
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFD35400), // Darker orange for better white text contrast
      gradient: [Color(0xFFD35400), Color(0xFFB03A2E)],
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFF8E44AD), // Darker purple for better white text contrast
      gradient: [Color(0xFF8E44AD), Color(0xFF7D3C98)],
    ),
    Category(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: Icons.receipt_long,
      color: Color(0xFF2980B9), // Darker blue for better white text contrast
      gradient: [Color(0xFF2980B9), Color(0xFF21618C)],
    ),
    Category(
      id: 'healthcare',
      name: 'Healthcare',
      icon: Icons.local_hospital,
      color: Color(0xFFC0392B), // Darker red for better white text contrast
      gradient: [Color(0xFFC0392B), Color(0xFF922B21)],
    ),
    Category(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF27AE60), // Darker green for better white text contrast
      gradient: [Color(0xFF27AE60), Color(0xFF229954)],
    ),
    Category(
      id: 'travel',
      name: 'Travel',
      icon: Icons.flight,
      color: Color(0xFF154360), // Darker teal for better white text contrast
      gradient: [Color(0xFF154360), Color(0xFF0B5345)],
    ),
    Category(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Color(0xFF5D6D7E), // Darker gray for better white text contrast
      gradient: [Color(0xFF5D6D7E), Color(0xFF4A5568)],
    ),
    Category(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFF4A5568), // Darker gray for better white text contrast
      gradient: [Color(0xFF4A5568), Color(0xFF34495E)],
    ),
  ];

  static Category getCategoryById(String id) {
    return defaultCategories.firstWhere(
      (category) => category.id == id,
      orElse: () => defaultCategories.last,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      gradient: [Color(json['color']), Color(json['color']).withOpacity(0.7)],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
