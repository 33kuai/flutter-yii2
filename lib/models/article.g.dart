// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    json['id'] as int,
    json['title'] as String,
    json['view'] as String,
    json['thumbnail_base_url'] as String,
    json['thumbnail_path'] as String,
    json['body'] as String,
    json['published_at'] as String,
    json['author'] as String,
    json['avatar'] as String,
  );
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'view': instance.view,
      'thumbnail_base_url': instance.thumbnailBaseUrl,
      'thumbnail_path': instance.thumbnailPath,
      'body': instance.body,
      'published_at': instance.publishedAt,
      'author': instance.author,
      'avatar': instance.avatar,
    };
