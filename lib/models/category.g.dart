// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    json['id'] as int,
    json['slug'] as String,
    json['title'] as String,
    json['status'] as int,
    json['created_at'] as int,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'status': instance.status,
      'created_at': instance.createdAt,
    };
