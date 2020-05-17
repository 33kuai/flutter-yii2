import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
//import 'package:zuxianzhi/views/Home.dart';
import 'package:provider/provider.dart';
import 'package:zuxianzhi/page/AnimatedIconDemo.dart';
import 'package:zuxianzhi/page/Demo.dart';
import 'package:zuxianzhi/page/Profile.dart';
import 'package:zuxianzhi/views/content/detail.dart';
import 'package:zuxianzhi/views/content/ArticleList.dart';
// import 'package:zuxianzhi/page/Login.dart';
// import 'package:zuxianzhi/page/Profile.dart';
import 'package:zuxianzhi/page/Search.dart';
import 'package:zuxianzhi/page/Setting.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';
import 'package:zuxianzhi/provider/user.dart';
import 'package:zuxianzhi/views/content/article_detial.dart';
import 'page/Home.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:zuxianzhi/views/content/ArticleDetail.dart';
void main() {
  runApp(new MyApp());
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
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

      _savePushRid(rid);
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

  //记录本机id，登录时上传，单独推送需要
  _savePushRid(ridData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rid = prefs.getString('rid');
    if (rid == null) {
      await prefs.setString('rid', ridData);
    }
  }

  var _pageController = PageController();

  //默认显示第一个tab标签
  int _tabIndex = 0;

  // //标签列表
  // final _pageList = [
  //   Home(),
  //   Search(),
  //   Setting(),
  //   // ArticleDetail(),
  //   //  LoginPage(),
  // ];

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
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: MaterialApp(

        localeResolutionCallback: (deviceLocale, supportedLocales) {
        print('deviceLocale: $deviceLocale');//判断操作系统语言
        return ;
      },
        theme: ThemeData(
          primaryColor: Colors.purple,
          appBarTheme:  AppBarTheme(
            color: Colors.green
            
          )
          // primaryColorLight:Colors.green,
          //  accentColor: Colors.green,
          //  textTheme: TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        ),
       // color: Colors.red,
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale.fromSubtags(languageCode: 'zh'),
        ],
        debugShowCheckedModeBanner: false,
        locale: Locale('zh', 'cn'),
        home: Scaffold(
            body: IndexedStack(
              index: _tabIndex,
              children: <Widget>[
                
               // ArticleList(category: 2,),
                Home(),
                Search(),
                Profile(),
                AnimatedIconPage(),
                
              ],
            ),
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
                      padding: EdgeInsets.all(5),
                
                      child: Icon(Icons.person),
                      badgeContent: Text('4',style: TextStyle(color:Colors.white,fontSize: 10),),
                    ),
                    title: Text('我的')),

                     BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('测试')),
              ],
              currentIndex: _tabIndex,
              type: BottomNavigationBarType.fixed,
              //  iconSize: 30.0,
              onTap: (int index) {
               _pageChanged(index);
              },
            )),
        //routes: {'/detail': (context) => Detail()},
      ),
    );
  }
}
