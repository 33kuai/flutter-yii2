import 'package:json_annotation/json_annotation.dart'; 
  
part 'profile.g.dart';


@JsonSerializable()
  class Profile extends Object {

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'firstname')
  String firstname;

  @JsonKey(name: 'lastname')
  String lastname;

  @JsonKey(name: 'locale')
  String locale;

  @JsonKey(name: 'gender')
  int gender;

  @JsonKey(name: 'birthday')
  String birthday;

  @JsonKey(name: 'region')
  String region;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'full_name')
  String fullName;

  Profile(this.userId,this.firstname,this.lastname,this.locale,this.gender,this.birthday,this.region,this.avatar,this.fullName,);

  factory Profile.fromJson(Map<String, dynamic> srcJson) => _$ProfileFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

}