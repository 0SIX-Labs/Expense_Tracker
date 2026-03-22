// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 1;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      id: fields[0] as String?,
      amount: fields[1] as double,
      period: fields[2] as BudgetPeriod,
      startDate: fields[3] as DateTime,
      createdAt: fields[4] as DateTime?,
      categoryId: fields[5] as String?,
      name: fields[6] as String?,
      currency: fields[7] as String,
      month: fields[8] as int?,
      year: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.period)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.month)
      ..writeByte(9)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BudgetPeriodAdapter extends TypeAdapter<BudgetPeriod> {
  @override
  final int typeId = 2;

  @override
  BudgetPeriod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BudgetPeriod.weekly;
      case 1:
        return BudgetPeriod.monthly;
      case 2:
        return BudgetPeriod.yearly;
      default:
        return BudgetPeriod.weekly;
    }
  }

  @override
  void write(BinaryWriter writer, BudgetPeriod obj) {
    switch (obj) {
      case BudgetPeriod.weekly:
        writer.writeByte(0);
        break;
      case BudgetPeriod.monthly:
        writer.writeByte(1);
        break;
      case BudgetPeriod.yearly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
