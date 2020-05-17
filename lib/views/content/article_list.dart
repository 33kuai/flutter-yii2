import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'article_detial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zuxianzhi/provider/articleProvider.dart';

class ArticleList extends StatefulWidget {
   final int category;
  ArticleList({Key key, this.category}) : super(key: key);


  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  var _articleList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //   super.build(context);

    final articleProvider = Provider.of<ArticleProvider>(context);
    _articleList = articleProvider.articleList;

    return Container(
      //  padding: EdgeInsets.all(15),
      width: ScreenUtil().setWidth(750),
      //padding: EdgeInsets.only(top:30),
      child: ListView.builder(
        itemCount: _articleList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // color: Colors.white,
            margin: EdgeInsets.all(5),
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(1.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey[400].withOpacity(0.3),
                  //offset: const Offset(3, 4),
                  blurRadius: 5,
                ),
              ],
            ),
            child: ListTile(
              isThreeLine: false,
              title: Text(_articleList[index].title),
              subtitle: Row(
                children: <Widget>[
                  ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/logo.png', // 占位图
                      image: _articleList[index].avatar,
                      width: 15,
                      height: 15,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(_articleList[index].author),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    timeago.format(
                        DateTime.parse(_articleList[index].publishedAt),
                        locale: 'zh_cn'),
                  ),
                ],
              ),
              //     trailing: FaIcon(FontAwesomeIcons.caretRight,size:15,color:Colors.grey),
              trailing: (_articleList[index].thumbnailBaseUrl != null)
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.grey[300], BlendMode.modulate),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'images/logo.png', // 占位图
                        image: _articleList[index].thumbnailPath,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Text(''),
              onTap: () {
                NetData.getArticle(_articleList[index].id, context)
                    .then((value) {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return ArticleDetail();
                  }));
                });
              },
            ),
          );
        },
      ),
    );
  }
}
