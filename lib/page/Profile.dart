import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zuxianzhi/page/Setting.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'dart:async';
import 'dart:io';
import '../src/picker.dart';
import '../meta/province.dart';
import 'package:package_info/package_info.dart';
import 'Login.dart';
import 'package:provider/provider.dart';
import '../provider/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:barcode_scan/barcode_scan.dart';

var emptyResult = new Result();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //扫码
  ScanResult scanResult;

  final _flashOnController = TextEditingController(text: "开灯");
  final _flashOffController = TextEditingController(text: "关灯");
  final _cancelController = TextEditingController(text: "取消");

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  //end
  PickerItem showTypeAttr = PickerItem(name: '省+市+县', value: ShowType.pca);
  Result resultAttr = new Result();
  Result result = new Result();
  double barrierOpacityAttr = 0.5;
  bool barrierDismissibleAttr = false;
  bool customerMeta = false;
  bool customerItemBuilder = false;
  double customerItemExtent = 40;
  bool customerButtons = false;
  bool isSort = false;

  var selectDate;

  PickerItem themeAttr;

  getItemBuilder() {
    if (customerItemBuilder) {
      return (item, list, index) {
        return Center(
            child: Text(item, maxLines: 1, style: TextStyle(fontSize: 55)));
      };
    } else {
      return null;
    }
  }

  int selectedValue;

  File _image;

  Future getImage() async {
    NetData.checkLogin().then((value) {
      if (!value) {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new LoginPage();
        }));
      }
    });

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //上传头像
// _image = image;
    print(image.path);
    NetData.uploadAvatar(image.path).then((value) {
      setState(() {
        _image = image;
      });
    });
    myupdateProfile();
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    initPlatformState();

    Future.delayed(Duration.zero, () async {
      setState(() {});
    });
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      // print(_packageInfo.version);
    });
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  //设备信息
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  String barcode = '';
  @override
  Widget build(BuildContext context) {
    var selectRegion = '请选择地址';
    var gender = '请选择性别';
    Widget avatar = Image.asset('images/avatar.jpg');

    final userProvider = Provider.of<User>(context);
    var profile = userProvider.profile;

    if (profile != null) {
      selectRegion = profile.region;
      selectedValue = profile.gender;
      selectDate = profile.birthday;
      if (profile.avatar != null) {
        avatar = Image.network(profile.avatar);
      }
    }

    if (_image != null) {
      avatar = new Image.file(
        _image,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }

//print(profile.region);

    // if (result.toString() != '{}') {
    //   select =
    //       result.provinceName + ' ' + result.cityName + ' ' + result.areaName;
    // }

    if (selectedValue != null) {
      switch (selectedValue) {
        case 0:
          gender = '男';
          break;
        case 1:
          gender = '女';
          break;
        case 2:
          gender = '保密';
          break;
        default:
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("个人设置"),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.crop_free),
                  onPressed: () {
                    scan();
                  }),
            ],
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Setting();
                }));
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
              title: Text('头像'),
              trailing:

                  //getImage
                  GestureDetector(
                child: ClipOval(
                  child: avatar,
                ),
                onTap: getImage,
              )),
          ListTile(
            title: Text('地区'),
            trailing: Text(selectRegion),
            onTap: () async {
              NetData.checkLogin().then((value) {
                if (!value) {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new LoginPage();
                  }));
                }
                // else{

                //    myupdateProfile();
                // }

                //myupdateProfile();
              });

//myupdateProfile();

              print("locationCode $resultAttr");
              Result tempResult = await CityPickers.showCityPicker(
                  context: context,
                  theme: themeAttr != null ? themeAttr.value : null,
                  locationCode: resultAttr != null
                      ? resultAttr.areaId ??
                          resultAttr.cityId ??
                          resultAttr.provinceId
                      : null,
                  showType: showTypeAttr.value,
                  isSort: isSort,
                  barrierOpacity: barrierOpacityAttr,
                  barrierDismissible: barrierDismissibleAttr,
                  citiesData: customerMeta == true ? citiesData : null,
                  provincesData: customerMeta == true ? provincesData : null,
                  itemExtent: customerItemExtent,
                  cancelWidget: customerButtons ? Text('cancle') : null,
                  confirmWidget: customerButtons ? Text('confirm') : null,
                  itemBuilder: this.getItemBuilder());
              if (tempResult == null) {
                return;
              }
              this.setState(() {
                result = tempResult;

                NetData.updateProfile({
                  'region': result.provinceName +
                      ' ' +
                      result.cityName +
                      ' ' +
                      result.areaName
                }, context)
                    .then((value) {
                  myupdateProfile();
                  print(value);
                  // NetData.getProfile(context);
                });
              });
            },
          ),
          ListTile(
            title: Text('性别'),
            trailing: Text(gender),
            onTap: () {
              _showAtionSheet(context).then((value) {
                NetData.updateProfile({'gender': value}, context);

                myupdateProfile();
                setState(() {
                  print(value);
                  selectedValue = value;
                });

                print(value);
              });
            },
          ),
          ListTile(
            title: Text('生日'),
            trailing: Text(selectDate ?? '请选择'),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date, //日期时间模式，此处为日期模式
                      onDateTimeChanged: (dateTime) {
                        //日期改变时调用的方法
                        if (dateTime == null) {
                          return;
                        }

                        var longdate =
                            '${dateTime.year}-${dateTime.month}-${dateTime.day}';

                        NetData.updateProfile({'birthday': longdate}, context);
                        myupdateProfile();
                        setState(() {
                          selectDate =
                              '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
                        });
                      },
                      //initialDateTime: DateTime.now(), //初始化展示时的日期时间
                      minimumYear: 1960, //最小年份，只有mode为date时有效
                      maximumYear: 2020, //最大年份，只有mode为date时有效
                    );
                  });
            },
          ),

          ListTile(
            title: Text('扫码'),
            trailing:
                Text((scanResult == null) ? '' : scanResult.rawContent ?? ""),
            onTap: () {
              scan();
            },
          ),

          ListTile(
            title: Text('选择相册'),
            onTap: () {
              loadAssets();
            },
          ),

          ListTile(
            title: Text('版本 1.0'),
            onTap: () {
              _showAtionSheetVersionVersion(context);
            },
          ),
          // ListTile(
          //   title: Text('退出'),

          //   onTap: () {
          //     NetData.doLogout();
          //      final user = Provider.of<User>(context, listen: false);
          //       user.setProfile(null);
          //   },
          // ),

          Flexible(
            child: ExpansionTile(
              title: Text("系统信息"),
              //   leading: Icon(Icons.favorite,color: Colors.white,),
              backgroundColor: Colors.white,
              initiallyExpanded: false, //默认是否展开
              children: <Widget>[
                Container(
                  height: 310,
                  child: ListView(
                    children: _deviceData.keys.map((String property) {
                      return Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              property,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            //  height: 10,
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Text(
                              '${_deviceData[property]}',
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),

          // Flexible(
          //     child: Container(
          //         child: ListView(
          //   children: _deviceData.keys.map((String property) {
          //     return Row(
          //       children: <Widget>[
          //         Container(
          //           padding: const EdgeInsets.all(10.0),
          //           child: Text(
          //             property,
          //             style: const TextStyle(
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),

          //         Expanded(
          //             child: Container(
          //           padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          //           child: Text(
          //             '${_deviceData[property]}',
          //             maxLines: 10,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         )),

          //       ],
          //     );
          //   }).toList(),
          // ))

          // ),
        ],
      ),
    );
  }

  myupdateProfile() async {
    await NetData.getProfile2().then((value) {
      final user = Provider.of<User>(context, listen: false);
      user.setProfile(value);
    });
  }

  Future<int> _showAtionSheet(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (cxt) {
          var dialog = CupertinoActionSheet(
            //message: Text('性别'),
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(cxt, 0);
                },
                child: Text('取消')),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(cxt, 1);
                  },
                  child: Text('男')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(cxt, 2);
                  },
                  child: Text('女')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(cxt, 3);
                  },
                  child: Text('保密')),
            ],
          );

          return dialog;
        });
  }

  Future<int> _showAtionSheetVersionVersion(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (cxt) {
          var dialog = CupertinoActionSheet(
            title: Text('跬步1.0'),
            message: Text('不积跬步，无以致千里'),
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(cxt, 0);
                },
                child: Text('取消')),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(cxt);
                  },
                  child: Text('给个好评!')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(cxt);
                  },
                  child: Text('我要吐槽')),
            ],
          );

          return dialog;
        });
  }

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "选择头像",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      print(result.rawContent);
      print(99999);
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }
}
