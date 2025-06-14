// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductItemModelAdapter extends TypeAdapter<ProductItemModel> {
  @override
  final int typeId = 0;

  @override
  ProductItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductItemModel(
      productId: fields[0] as String?,
      imgPath: fields[1] as String,
      isFavorite: fields[2] as bool,
      name: fields[3] as String,
      category: fields[4] as String,
      price: fields[5] as double,
      description: fields[6] as String,
      rating: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProductItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.imgPath)
      ..writeByte(2)
      ..write(obj.isFavorite)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
