import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class ArticleDetail extends StatelessWidget {
  const ArticleDetail({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {




    
    return Scaffold(
        appBar: AppBar(
          title: Text('文章详情'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Consumer<ArticleProvider>(
              builder: (context, _article, child) => Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      _article.articleDetail.title,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Html(data: _article.articleDetail.body),
                  )
                ],
              ),
            ))
            );
  }
}
