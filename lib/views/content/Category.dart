import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ArticleList.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';

class Category extends StatefulWidget {
  Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Tab> tabList = <Tab>[];

  List _categories = [];

  @override
  void initState() {
    //initData();
    super.initState();

    Future.microtask(() {
         NetData.getCategory(context);
  }
    
  );
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    tabList.clear();
    final articleProvider = Provider.of<ArticleProvider>(context);
    _categories = articleProvider.category;

    if (_categories == null) {
      return CupertinoActivityIndicator();
    }

    for (var item in _categories) {
      tabList.add(new Tab(
        text: item.title,
      ));
    }

    if (tabList.isEmpty) {
      return CupertinoActivityIndicator();
    }

    return DefaultTabController(
        length: tabList.length,
        child: new Scaffold(
          appBar:
          
           PreferredSize(
            child: new AppBar(
                bottom: new TabBar(
              tabs: tabList,
              isScrollable: true,
            )),
            preferredSize: Size.fromHeight(50.0),
          ),
          body: new TabBarView(
              children: _categories.map((cate) {
            return Center(child: new ArticleList(category: cate.id));
          }).toList()),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
