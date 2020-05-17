import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// import 'ArticleList.dart';
import 'article_list.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key key}) : super(key: key);

  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>
    with TickerProviderStateMixin {
  TabController _tabController;

  final List<Tab> tabList = <Tab>[];
  List _categories = [];
  @override
  void initState() {
    super.initState();

    final articleProvider = Provider.of<ArticleProvider>(context);
    _categories = articleProvider.category;

    tabList.clear();

    for (var item in _categories) {
      tabList.add(new Tab(
        text: item.title,
      ));
    }

    _tabController = new TabController(vsync: this, length: tabList.length);
    _tabController.addListener(() {
      NetData.getArticleList(_tabController.index, context);
      print(_tabController.index);
    });
  }




didChangeDependencies() {
  super.didChangeDependencies();
  // final value = Provider.of<Foo>(context).value;
  // if (value != this.value) {
  //   this.value = value;
  //   print(value);
  // }
}




  @override
  Widget build(BuildContext context) {
    // tabList.clear();
    // final articleProvider = Provider.of<ArticleProvider>(context);
    // _categories = articleProvider.category;

    // if (_categories == null) {
    //   return CupertinoActivityIndicator();
    // }

    // for (var item in _categories) {
    //   tabList.add(new Tab(
    //     text: item.title,
    //   ));
    // }

    // if (tabList.isEmpty) {
    //   return CupertinoActivityIndicator();
    // }

    // _tabController = new TabController(vsync: this, length: tabList.length);
    // _tabController.addListener(() {

    //   NetData.getArticleList(_tabController.index, context);
    //   print(_tabController.index);
    // });

    return Scaffold(
        appBar: AppBar(
          // title: Text('ss '),
          bottom: TabBar(
            controller: this._tabController,
            tabs: tabList,
          ),
        ),
        body: TabBarView(
          controller: this._tabController,
          children: _categories.map((cate) {
            return Center(child: new ArticleList(category: cate.id));
          }).toList(),
        ));
  }

  @override
  void dispose() {
    //生命周期函数：
    super.dispose();
    _tabController.dispose();
  }
}
