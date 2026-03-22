// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomeAdapter extends TypeAdapter<Income> {
  @override
  final int typeId = 4;

  @override
  Income read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Income(
      id: fields[0] as String?,
      amount: fields[1] as double,
      category: fields[2] as IncomeCategory,
      customCategoryName: fields[3] as String?,
      month: fields[4] as int,
      year: fields[5] as int,
      notes: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
      date: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Income obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.customCategoryName)
      ..writeByte(4)
      ..write(obj.month)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncomeCategoryAdapter extends TypeAdapter<IncomeCategory> {
  @override
  final int typeId = 5;

  @override
  IncomeCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IncomeCategory.salary;
      case 1:
        return IncomeCategory.freelance;
      case 2:
        return IncomeCategory.investment;
      case 3:
        return IncomeCategory.business;
      case 4:
        return IncomeCategory.rental;
      case 5:
        return IncomeCategory.other;
      default:
        return IncomeCategory.salary;
    }
  }

  @override
  void write(BinaryWriter writer, IncomeCategory obj) {
    switch (obj) {
      case IncomeCategory.salary:
        writer.writeByte(0);
        break;
      case IncomeCategory.freelance:
        writer.writeByte(1);
        break;
      case IncomeCategory.investment:
        writer.writeByte(2);
        break;
      case IncomeCategory.business:
        writer.writeByte(3);
        break;
      case IncomeCategory.rental:
        writer.writeByte(4);
        break;
      case IncomeCategory.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
