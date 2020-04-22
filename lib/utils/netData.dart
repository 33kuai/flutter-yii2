import 'dart:async';
import 'package:dio/dio.dart';
import 'package:zuxianzhi/models/movie.dart';
import '../api/Api.dart';
import '../models/article.dart';
import '../models/category.dart';

class NetData {
 

  //根据分类id取文章列表

 static Future getArticleList(int category) async {
    Dio dio = new Dio();
    Response response;
    List articleList = [];
    try {
      var url = Api.ARTICLE_LIST + "?filter[category_id]=$category";
      response = await dio.get(url);
      for (var item in response.data['items']) {
        Article article = Article.fromJson(item);
        articleList.add(article);
      }
      return articleList;
    } catch (err) {
      return response.data['message'];
    }
  }

  //获取单篇文章
 static Future  getArticle(int id) async {
    Response response;
    Dio dio = new Dio();
    try {
      var url = Api.ARTICLE + "?id=$id";
      response = await dio.get(url);
      Article article = Article.fromJson(response.data);
      return article;
    } catch (err) {
      return response.data['message'];
    }
  }

  //获取所有分类
 static Future getCategory() async {
  
    Dio dio = new Dio();
    List categoryList = [];
    Response response;
    try {
      String url = Api.CATEGORY;
      response = await dio.get(url);

      for (var item in response.data['items']) {
        
        Category category = Category.fromJson(item);
        
        categoryList.add(category);
         
      }
 
      return categoryList;
    } catch (err) {
  
      return response.data['message'];
    }
  }




 //根据电影列表
 static Future getMovieList(String keyword) async {
    Dio dio = new Dio();
    Response response;
    List movieList = [];
    try {
      var url = Api.MOVIE_LIST + "?keyword=$keyword";
      response = await dio.get(url);
      for (var item in response.data['items']) {
        Movie movie = Movie.fromJson(item['_source']);
        movieList.add(movie);
      }
      return movieList;
    } catch (err) {
      return response.data['message'];
    }
  }
}
