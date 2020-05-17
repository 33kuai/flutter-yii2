import 'package:flutter/material.dart';
import 'package:zuxianzhi/models/profile.dart';
import 'package:zuxianzhi/utils/netData.dart';

class User with ChangeNotifier {
  User() {
    NetData.checkLogin().then((value) {
      if (value == true) {
        NetData.getProfile2().then((value) => {setProfile(value)});
      }
    });
  }

  String _token;
  get token => _token;
  void setToken(token) {
    _token = token;
    notifyListeners();
  }

  Profile _profile;
  get profile => _profile;
  void setProfile(profileData) {
    print(profileData);
    print(33333);
    _profile = profileData;
    notifyListeners();
  }
}
