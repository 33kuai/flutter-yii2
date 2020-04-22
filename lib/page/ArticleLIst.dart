import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'ArticleDetail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArticleList extends StatefulWidget {
  final int category;
  ArticleList({Key key, this.category}) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var _futureBuilderFutureArticleList;

  var _articleList;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('zh_cn', timeago.ZhCnMessages());
    int cat = widget.category;
    _futureBuilderFutureArticleList = NetData.getArticleList(cat);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new FutureBuilder(
      builder: _buildFuture,
      future: _futureBuilderFutureArticleList,
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      _articleList = snapshot.data;

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
              //  dense: true,
                // leading: Container(
                //   decoration: BoxDecoration(
                //     borderRadius: const BorderRadius.all(Radius.circular(1.0)),
                //     //  color: Colors.pink,
                //     boxShadow: [
                //       BoxShadow(
                //           color: Colors.grey,
                //           offset: Offset(5.0, 5.0),
                //           blurRadius: 8.0,
                //           spreadRadius: 1.0)
                //     ],
                //   ),
                //   child: Stack (
                //     children: <Widget>[
                //     ClipOval(
                //     child: FadeInImage.assetNetwork(
                //       placeholder: 'images/logo.png', // 占位图
                //       image: _articleList[index].avatar,
                //       width: 40,
                //       height: 40,
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                //   // Positioned(
                //   //   top: 0,
                //   //   child: Image.asset('images/logo.png',width:20,height:20)
                //   //   )


                //     ],
                //   ),
                // ),
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
                    Text(timeago.format(
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
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new PostSingle(id: _articleList[index].id);
                  }));
                },
              ),
            );
          },
        ),
      );
    } else {
      return CupertinoActivityIndicator();
    }
  }
}
