// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    json['name'] as String,
    json['type'] as String,
    json['star'] as String,
    json['people'] as String,
    json['directors'] as String,
    json['casts'] as String,
    json['language'] as String,
    json['daytime'] as String,
    json['movie_time'] as String,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'star': instance.star,
      'people': instance.people,
      'directors': instance.directors,
      'casts': instance.casts,
      'language': instance.language,
      'daytime': instance.daytime,
      'movie_time': instance.movieTime,
    };
