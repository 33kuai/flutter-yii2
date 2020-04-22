import 'package:flutter/material.dart';
import 'package:zuxianzhi/page/Detail.dart';
class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('test')
      ),
      body: RaisedButton(
        child: Text('测试'),
        onPressed: (){

          Navigator.pushNamed(
            context, 
            '/detail',
            arguments: DetailArgs(2)
            );
        }),
      
    );
  }
}