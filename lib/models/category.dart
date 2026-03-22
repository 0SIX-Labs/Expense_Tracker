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

  // Pre-defined categories with Liquid Glass gradient colors
  static const List<Category> defaultCategories = [
    Category(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.restaurant,
      color: Color(0xFFFF6B6B),
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF4ECDC4),
      gradient: [Color(0xFF4ECDC4), Color(0xFF6EE7DF)],
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFFB347),
      gradient: [Color(0xFFFFB347), Color(0xFFFFCC80)],
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFF9B59B6),
      gradient: [Color(0xFF9B59B6), Color(0xFFBB8FCE)],
    ),
    Category(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: Icons.receipt_long,
      color: Color(0xFF3498DB),
      gradient: [Color(0xFF3498DB), Color(0xFF5DADE2)],
    ),
    Category(
      id: 'healthcare',
      name: 'Healthcare',
      icon: Icons.local_hospital,
      color: Color(0xFFE74C3C),
      gradient: [Color(0xFFE74C3C), Color(0xFFEC7063)],
    ),
    Category(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF2ECC71),
      gradient: [Color(0xFF2ECC71), Color(0xFF58D68D)],
    ),
    Category(
      id: 'travel',
      name: 'Travel',
      icon: Icons.flight,
      color: Color(0xFF1ABC9C),
      gradient: [Color(0xFF1ABC9C), Color(0xFF48C9B0)],
    ),
    Category(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Color(0xFF95A5A6),
      gradient: [Color(0xFF95A5A6), Color(0xFFBDC3C7)],
    ),
    Category(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFF7F8C8D),
      gradient: [Color(0xFF7F8C8D), Color(0xFF95A5A6)],
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
