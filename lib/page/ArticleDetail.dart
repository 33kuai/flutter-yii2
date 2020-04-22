import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:flutter_html/flutter_html.dart';

class PostSingle extends StatefulWidget {
  final int id;
  PostSingle({Key key, this.id}) : super(key: key);

  @override
  _PostSingleState createState() => _PostSingleState();
}

class _PostSingleState extends State<PostSingle> {
  var _futureBuilderFuture;
  var _article;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = NetData.getArticle(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      builder: _buildFuture,
      future: _futureBuilderFuture,
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {

      _article = snapshot.data;

      return Scaffold(
          appBar: AppBar(
            title: Text('文章详情'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    _article.title,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Container(
                  child: Html(data: _article.body),
                )
              ],
            ),
          ));
    } else {
      return Scaffold(
          body: CupertinoActivityIndicator()
      );
    }
  }
}
