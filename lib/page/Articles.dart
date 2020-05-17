import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ArticleList.dart';
import '../utils/netData.dart';

class Articles extends StatefulWidget {
  Articles({Key key}) : super(key: key);

  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Tab> tabList = <Tab>[];

  var _futureBuilderFuture;
  List _categories = [];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = NetData.getCategory(context);
  }

  @override
  Widget build(BuildContext context) {
     super.build(context);
    return new FutureBuilder(
      builder: _buildFuture,
      future: _futureBuilderFuture,
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CupertinoActivityIndicator();
        break;
      case ConnectionState.active:
        return CupertinoActivityIndicator();
        break;
      case ConnectionState.waiting:
        return CupertinoActivityIndicator();
        break;
      case ConnectionState.done:
        _categories = snapshot.data;
        tabList.clear();
        for (var item in _categories) {
          tabList.add(new Tab(
            text: item.title,
          ));
        }
    
   // print(tabList.length);
        return DefaultTabController(
            length: tabList.length,
            child: new Scaffold(
              appBar: PreferredSize(
                child: new AppBar(
                  
                    bottom: new TabBar(
                  tabs: tabList,
                  isScrollable: true,
                )),
                preferredSize: Size.fromHeight(50.0),
              ),
              body: new TabBarView(


                  children: 
                  // tabList.map((e){


                  // }).toList()
                  
                  _categories.map((cate) {
                   // print(cate.title);
                return Center(child: new ArticleList(
                  
                  
                  key: new PageStorageKey<int>(cate.id),
                  category: cate.id));
              }).toList()
              
              
              ),
            ));
        break;
      default:
        return CupertinoActivityIndicator();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
