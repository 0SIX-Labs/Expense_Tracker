import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int monthStartDay;

  @HiveField(3)
  final String defaultCurrency;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  UserProfile({
    String? id,
    required this.name,
    this.monthStartDay = 1,
    this.defaultCurrency = 'USD',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  UserProfile copyWith({
    String? id,
    String? name,
    int? monthStartDay,
    String? defaultCurrency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      monthStartDay: monthStartDay ?? this.monthStartDay,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'monthStartDay': monthStartDay,
      'defaultCurrency': defaultCurrency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      monthStartDay: json['monthStartDay'] ?? 1,
      defaultCurrency: json['defaultCurrency'] ?? 'USD',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, monthStartDay: $monthStartDay, defaultCurrency: $defaultCurrency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
