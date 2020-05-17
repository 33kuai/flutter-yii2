import 'dart:async';
// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:zuxianzhi/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuxianzhi/models/profile.dart';
import '../api/Api.dart';
import '../models/article.dart';
import '../models/category.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
//import 'dart:io';
import 'dart:convert';
//import 'package:dio/adapter.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../provider/user.dart';

class NetData {
  //根据分类id取文章列表

  static Future getArticleList(int category, context) async {
    Dio dio = new Dio();

    Response response;
    List articleList = [];
    try {
      var url = Api.ARTICLE_LIST + "?filter[category_id]=$category";
      print(url);
      response =
          await dio.get(url, options: buildCacheOptions(Duration(days: 7)));
      for (var item in response.data['items']) {
        Article article = Article.fromJson(item);
        articleList.add(article);
      }



      return articleList;
    } catch (err) {
      print(err);
    }
  }

  //获取单篇文章
  static Future getArticle(int id, context) async {
  
    Response response;
    Dio dio = new Dio();
    try {
      var url = Api.ARTICLE + "?id=$id";
      response =
          await dio.get(url, options: buildCacheOptions(Duration(days: 7)));
      Article article = Article.fromJson(response.data);
      return article;
    } catch (err) {
      print(err);
    }
  }

  //获取所有分类
  static Future getCategory(context) async {
    Dio dio = new Dio();
    List categoryList = [];
    Response response;
    try {
      String url = Api.CATEGORY;
      response =
          await dio.get(url, options: buildCacheOptions(Duration(days: 7)));

      for (var item in response.data['items']) {
        Category category = Category.fromJson(item);
        categoryList.add(category);
      }

      return categoryList;
    } catch (err) {
      print(err);
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
      print(err);
    }
  }

  // static Future getProfile(context) async {
  //   Response response;
  //   Dio dio = new Dio();
  //   try {
  //     var url = Api.PROFILE + '5';

  //     response = await dio.get(url);

  //      Profile profile = Profile.fromJson(response.data['items'][0]);
  //     // userProvider.setProfile(profile);

  //     return profile;
  //   } catch (err) {
  //     return response.data['message'];
  //   }
  // }
 



   static Future getProfile2() async {
    Response response;
    Dio dio = new Dio();
    
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token= prefs.getString('token');

      var url = Api.PROFILE + '5';//+ '&access-token=' + token;
      print(url);

      Options options = Options(headers:   
      {HttpHeaders.authorizationHeader:" Bearer "+ token});


      response = await dio.get(url,options: options);

      print(response);
      Profile profile = Profile.fromJson(response.data['items'][0]);
      return profile;
    } catch (err) {
      print(err);
    }
  }



  //更新用户头像

  static Future uploadAvatar(filePath) async {
    var formData1 = FormData.fromMap({
      // "username": "wendux",
      // "age": 25,
      "file": await MultipartFile.fromFile(filePath, filename: "avatar.jpg"),
      // "files": [
      //   await MultipartFile.fromFile("./example/upload.txt",
      //       filename: "upload.txt"),
      //   MultipartFile.fromFileSync("./example/upload.txt",
      //       filename: "upload.txt"),
      // ]
    });
    Dio dio = new Dio();
    Response response;


    SharedPreferences prefs = await SharedPreferences.getInstance();
      var token= prefs.getString('token');
      Options options = Options(headers:   
      {HttpHeaders.authorizationHeader:" Bearer "+ token});


    response = await dio.post(
      "http://api.zuxianzhi.com/v2/profile/upload",
      data: formData1,
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      },
      options: options
    );
  }

  //更新用户信息
  static Future updateProfile(postData,context) async {
    Dio dio = new Dio();
    Response response;




    SharedPreferences prefs = await SharedPreferences.getInstance();
      var token= prefs.getString('token');
      Options options = Options(headers:   
      {HttpHeaders.authorizationHeader:" Bearer "+ token});


    // var postData = {'address': '北京市北京城区朝阳区'};
    try {
      var url = Api.PROFILE_UPDATE;

      response = await dio.post(url, data: postData,options:options);
      
      print(response);
    } catch (err) {
     print(err);
    }
  }

  static Future doLogin(String username, String password) async {
    Dio dio = new Dio();

    Response response;

    try {
      var url = Api.DO_LOGIN;
      response = await dio
          .post(url, data: {"username": username, "password": password});
      var token = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token['token']).then((value) {
         
      });
      return token['token'];
    } catch (err) {
      return err.toString();
    }
  }

  static Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      return true;
    } else {
      return false;
    }
  }



  static Future doLogout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      return true;
    } catch (err) {
      return err.toString();
    }
  }



/*
点赞，收藏，等文章相关操作
*/

  static Future updateArticle(postData) async {
    Dio dio = new Dio();
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var token= prefs.getString('token');
      Options options = Options(headers:   
      {HttpHeaders.authorizationHeader:" Bearer "+ token});
 
    try {
      var url = Api.ARTICLE;

      response = await dio.post(url, data: postData,options:options);
      
      print(response);
    } catch (err) {
     print(err);
    }
  }
}
