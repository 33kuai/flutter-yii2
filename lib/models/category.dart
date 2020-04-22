import 'package:json_annotation/json_annotation.dart'; 
  
part 'category.g.dart';


@JsonSerializable()
  class Category extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'created_at')
  int createdAt;

  Category(this.id,this.slug,this.title,this.status,this.createdAt,);

  factory Category.fromJson(Map<String, dynamic> srcJson) => _$CategoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

}
