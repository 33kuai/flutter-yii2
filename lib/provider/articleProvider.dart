import 'package:flutter/material.dart';
import 'package:zuxianzhi/models/article.dart';


class ArticleProvider with ChangeNotifier {


  List _categoory=[];
  List get category => _categoory;
  void setCategory(categoryData){
    if(categoryData== null){
      _categoory=[];
    }else{
      _categoory = categoryData;
    }
    notifyListeners();
  }



  var _articleList;
  get articleList => _articleList;
  void setArticleList(articleData) {
    
      _articleList = articleData;
     
    
    notifyListeners();
  }



  Article _artcileDetail;
  Article get articleDetail => _artcileDetail;
  void setArticleDetail(articleDetailData){
      _artcileDetail = articleDetailData;
      notifyListeners();
  }

  bool _loading;
  bool get loading => _loading;
  void setLoading(bool){
    _loading = bool;
    notifyListeners();
  }


}
