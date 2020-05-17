// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['user_id'] as int,
    json['firstname'] as String,
    json['lastname'] as String,
    json['locale'] as String,
    json['gender'] as int,
    json['birthday'] as String,
    json['region'] as String,
    json['avatar'] as String,
    json['full_name'] as String,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user_id': instance.userId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'locale': instance.locale,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'region': instance.region,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
    };
