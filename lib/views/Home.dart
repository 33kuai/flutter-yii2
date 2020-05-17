import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';
import './content/Category.dart';
//import './content/category_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  // @override
  // void initState() {
  //    super.initState();
  //   NetData.getCategory(context).then((value) {

  //       NetData.getArticleList(1, context);
  //   });
    
   
  // }

  @override
  Widget build(BuildContext context) {


    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);

      // final articleProvider = Provider.of<ArticleProvider>(context);
      // List _categories = articleProvider.category;
      // if(_categories.isEmpty){
      //   return CupertinoActivityIndicator();
      // }

    return Scaffold(
 
      body: Category(),
      
    );
  }
}