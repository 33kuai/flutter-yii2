import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:zuxianzhi/widgets/empty.dart';
class Detail extends StatefulWidget {
  final int id;
  Detail({Key key, this.id}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  initState() {
    super.initState();
    // Future.microtask(() {
    //   NetData.getArticle(widget.id, context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);
    // print(articleProvider.articleDetail);

    if (articleProvider.articleDetail == null) {
     // return Center(child:Text('sssssssssssss'));
      //print(articleProvider.articleDetail);
      return Empty();
    }
    //  print(articleProvider.articleDetail.title);
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text('文章详情'),
    //     ),
    //     body: SingleChildScrollView(
    //         padding: EdgeInsets.all(10),
    //         child:
            
    //          Consumer<ArticleProvider>(
    //           builder: (context, _article, child) => Column(
    //             children: <Widget>[
    //               Container(
    //                 child: Text(
    //                   _article.articleDetail.title,
    //                   style:
    //                       TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //               Divider(),
    //               Container(
    //                 child: Html(data: _article.articleDetail.body),
    //               )
    //             ],
    //           ),
    //         )));

    // Container(
    //    child:SingleChildScrollView(
    //         padding: EdgeInsets.all(10),
    //         child: Consumer<ArticleProvider>(
    //           builder: (context, _article, child) => Column(
    //             children: <Widget>[
    //               Container(
    //                 child: Text(
    //                   _article.articleDetail.title,
    //                   style:
    //                       TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //               Divider(),
    //               Container(
    //                 child: Html(data: _article.articleDetail.body),
    //               )
    //             ],
    //           ),
    //         )),
    // );
  }
}
