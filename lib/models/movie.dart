import 'package:json_annotation/json_annotation.dart'; 
  
part 'movie.g.dart';


@JsonSerializable()
  class Movie extends Object {

  

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'star')
  String star;

  @JsonKey(name: 'people')
  String people;

  @JsonKey(name: 'directors')
  String directors;

  @JsonKey(name: 'casts')
  String casts;

 

  @JsonKey(name: 'language')
  String language;

  @JsonKey(name: 'daytime')
  String daytime;

  @JsonKey(name: 'movie_time')
  String movieTime;

  Movie( this.name,this.type,this.star,this.people,this.directors,this.casts,this.language,this.daytime,this.movieTime,);

  factory Movie.fromJson(Map<String, dynamic> srcJson) => _$MovieFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

}

  
