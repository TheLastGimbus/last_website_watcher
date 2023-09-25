// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_page.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WebPageAdapter extends TypeAdapter<WebPage> {
  @override
  final int typeId = 1;

  @override
  WebPage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WebPage(
      name: fields[1] as String?,
      url: fields[2] as String,
      lastUpdate: fields[3] as DateTime?,
      color: fields[4] as int?,
      lastHtml: fields[5] as String?,
      lastChange: fields[6] as DateTime?,
      notificationChannelId: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WebPage obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.lastUpdate)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.lastHtml)
      ..writeByte(6)
      ..write(obj.lastChange)
      ..writeByte(7)
      ..write(obj.notificationChannelId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebPageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
