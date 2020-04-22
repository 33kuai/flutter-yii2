import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  List _data = [];
  List get codes => _data;
  void setData(data) {

    if(data == null){
      _data = [];
    }else{
      _data = data;
    }


    notifyListeners();
  }

  List _qrs = [];
  List get qrs => _qrs;
  void setQrs(qrs) {
    _qrs = qrs;
    notifyListeners();
  }

  Map _info = {"ssccCount":0,"kmCount":0,"allCount":0};
  Map get info=>_info;

  void setInfo(infoData){
    _info = infoData;
    notifyListeners();
  }



  List _search =[];
  List get search => _search;
  void setSearch(searchData){
    _search=searchData;
    notifyListeners();
  }

}
