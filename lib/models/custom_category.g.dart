// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomCategoryAdapter extends TypeAdapter<CustomCategory> {
  @override
  final int typeId = 6;

  @override
  CustomCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomCategory(
      id: fields[0] as String?,
      name: fields[1] as String,
      iconCodePoint: fields[2] as int,
      colorValue: fields[3] as int,
      isIncomeCategory: fields[4] as bool,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomCategory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconCodePoint)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.isIncomeCategory)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
