import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:zuxianzhi/page/Detail.dart';
import 'package:zuxianzhi/page/Home.dart';
import 'package:provider/provider.dart';
import 'package:zuxianzhi/page/Profile.dart';
import 'package:zuxianzhi/page/Search.dart';
import 'package:zuxianzhi/provider/data.dart';
import 'page/Home.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'dart:io';
import 'package:badges/badges.dart';

void main() {
  runApp(new MyApp());
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
  // SystemUiOverlayStyle systemUiOverlayStyle =
  //     SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();
  @override
  void initState() {
    super.initState();

    initXUpdate();
    //固定竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "63c5a4f72db883bc69f7eb93", //你自己应用的 AppKey
      channel: "developer-default",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  var _pageController = PageController();

  //默认显示第一个tab标签
  int _tabIndex = 0;

  //标签列表
  final _pageList = [
    Home(),
    Search(),
    Profile(),
    //Setting(),
  ];

  String _updateUrl = "http://api.zuxianzhi.com/v1/release";
  void checkUpdate() {
    FlutterXUpdate.checkUpdate(url: _updateUrl);
  }

  String _message = '';
  void initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(

              ///是否输出日志
              debug: true,

              ///是否使用post请求
              isPost: false,

              ///post请求是否是上传json
              isPostJson: false,

              ///是否开启自动模式
              isWifiOnly: false,

              ///是否开启自动模式
              isAutoMode: false,

              ///需要设置的公共参数
              supportSilentInstall: false,

              ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
              enableRetry: false)
          .then((value) {
        //   checkUpdate();
        updateMessage("初始化成功: $value");
      }).catchError((error) {
        print(error);
      });

      FlutterXUpdate.setErrorHandler(
          onUpdateError: (Map<String, dynamic> message) async {
        print(message);
        setState(() {
          _message = "$message";
        });
      });
    } else {
      updateMessage("ios暂不支持XUpdate更新");
    }
  }

  void updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  //切换tab标签
  void _pageChanged(int index) {
    setState(() {
      if (_tabIndex != index) _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => Data()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale('zh', 'cn'),
        home: Scaffold(
            body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                //禁止页面左右滑动切换
                controller: _pageController,
                onPageChanged: _pageChanged,
                itemCount: _pageList.length,
                itemBuilder: (context, index) => _pageList[index]),
            bottomNavigationBar: BottomNavigationBar(
              // iconSize: 20,
              // selectedFontSize: 10,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('首页')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), title: Text('搜索')),
                BottomNavigationBarItem(
                    icon: Badge(
                      shape: BadgeShape.circle,
                      borderRadius: 100,
                      child: Icon(Icons.settings),
                      badgeContent: Container(
                        height: 5,
                        width: 5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                    title: Text('个人中心')),
              ],
              currentIndex: _tabIndex,
              type: BottomNavigationBarType.fixed,
              //  iconSize: 30.0,
              onTap: (int index) {
                _pageController.jumpToPage(index);
              },
            )),
        routes: {'/detail': (context) => Detail()},
      ),
    );
  }
}
