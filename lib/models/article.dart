import 'package:json_annotation/json_annotation.dart'; 
  
part 'article.g.dart';


@JsonSerializable()
  class Article extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'view')
  String view;


  @JsonKey(name: 'thumbnail_base_url')
  String thumbnailBaseUrl;

  @JsonKey(name: 'thumbnail_path')
  String thumbnailPath;

  @JsonKey(name: 'body')
  String body;

  @JsonKey(name: 'published_at')
  String publishedAt;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'avatar')
  String avatar;

  Article(this.id,this.title,this.view,this.thumbnailBaseUrl,this.thumbnailPath,this.body,this.publishedAt,this.author,this.avatar,);

  factory Article.fromJson(Map<String, dynamic> srcJson) => _$ArticleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

}
