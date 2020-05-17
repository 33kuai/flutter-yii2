import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:provider/provider.dart';
import '../provider/user.dart';

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
        title: Text("设置"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('通知与提醒'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('隐私设置'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('帮助与反馈'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.new_releases),
            title: Text('版本更新'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.recent_actors),
            title: Text('切换身份'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            
            leading: Icon(Icons.outlined_flag),
            title: Text('退出登录'),
            onTap: () {
              NetData.doLogout();
               final user = Provider.of<User>(context, listen: false);
                user.setProfile(null);
            },
          ),
        ]),
      ),
    );
  }
}
