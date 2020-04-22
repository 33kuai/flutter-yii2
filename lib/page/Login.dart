import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuxianzhi/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _pwdEditController;
  TextEditingController _userNameEditController;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _pwdEditController = TextEditingController.fromValue(TextEditingValue(
      text: 'webmaster'
    ));
    _userNameEditController = TextEditingController.fromValue(TextEditingValue(
      text: 'webmaster'
    ));

    _pwdEditController.addListener(() => setState(() => {}));
    _userNameEditController.addListener(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
                child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.white60, BlendMode.modulate),
                child: Image.asset('images/logo.png', height: 200, width: 200),
            )),
            buildEditWidget(context),
            buildLoginButton()
          ],
        ),
      )),
    );
  }

  Widget buildEditWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          buildLoginNameTextField(),
          SizedBox(height: 20.0),
          buildPwdTextField(),
        ],
      ),
    );
  }

  Widget buildLoginNameTextField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 55,
            right: 10,
            top: 5,
            height: 30,
            child: TextField(
              
              controller: _userNameEditController,
              focusNode: _userNameFocusNode,
              decoration: InputDecoration(
                hintText: "请输入用户名",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPwdTextField() {
    return Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 55,
              right: 10,
              top: 5,
              height: 30,
              child: TextField(
                controller: _pwdEditController,
                focusNode: _pwdFocusNode,
                decoration: InputDecoration(
                  hintText: "请输入密码",
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14),
                obscureText: true,

                /// 设置密码
              ),
            )
          ],
        ));
  }

  Widget buildLoginButton() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 30, right: 30),
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width - 20,
      height: 40,
      child: RaisedButton(
        onPressed: () {
          checkInput();
        },
        child: Text("登录"),
        color: Colors.blue[400],
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }

  bool checkInput() {
    if (_userNameEditController.text.length == 0) {
      Fluttertoast.showToast(
          msg: "请输入用户名",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          fontSize: 14.0);

      return false;
    } else if (_pwdEditController.text.length == 0) {
      Fluttertoast.showToast(
          msg: "请输入密码",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          fontSize: 14.0);
      return false;
    }

    String username = _userNameEditController.text;
    String password = _pwdEditController.text;
   
//远程
    
    login(username, password).then((login) {
      Fluttertoast.showToast(
          msg: "登录成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
        return MyApp();
      }));
    });

    return true;
  }

  static Future login(String username,String password) async {
    Dio dio = new Dio();

    Response response;
 
    try {
      var url = 'http://api.zuxianzhi.com/login';
      response = await dio
          .post(url, data: {"username": username, "password": password});
      var token = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('token', token['token']);
      return token['token'];
    } catch (err) {
      return err.toString();
    }
  }
}
