import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';

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
    print(widget.id);
    super.initState();
    _futureBuilderFuture = NetData.getArticle(widget.id, context);
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
      print(_article);

      final size = MediaQuery.of(context).size;
      final width = size.width;

      return Scaffold(
          appBar: AppBar(
            //  elevation: 0,
            //  backgroundColor: Colors.white,

            title:  Text('咨询详情', style: GoogleFonts.notoSans()),
            
            // BackdropFilter(
            //   filter:  ImageFilter.blur(sigmaX: 100, sigmaY: 100), // new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            //   child: Text('sss',style: TextStyle(color:Colors.black),),
            // ),
            // BackgroundFi Text('咨询详情', style: GoogleFonts.notoSans())
            ),
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            fit: StackFit.expand,
            children: <Widget>[
//Html(data: _article.body),

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10),
                child: Container(
                  child: Column(children: [
                    Text(
                      _article.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Row(
                      children: <Widget>[
                        Image.network(
                          _article.avatar,
                          width: 30,
                          height: 30,
                        ),
                        Text(_article.author),
                      ],
                    ),
                    Html(data: _article.body),
                  ]),
                ),
              ),

              Positioned(
                  bottom: 0,
                  child: Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    height: 50,
                    width: width,
                    color: Colors.white,
                    child: Row(children: [
                      Expanded(flex: 3, child: Text('')),
                      Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),
                            child: InkWell(
                                onTap: () {
                                  NetData.updateArticle({'thumb_up': 1});
                                },
                                child: Badge(
                                  shape: BadgeShape.circle,
                                  animationType: BadgeAnimationType.scale,
                                  // borderRadius: 50,
                                  badgeColor: Colors.red,
                                  padding: EdgeInsets.all(1),
                                  // elevation: 8,

                                  //  position: BadgePosition.topRight(top: 1, right: -15),

                                  badgeContent: Text(
                                    '99',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  child: Icon(Icons.thumb_up),
                                )),

                            // IconButton(icon: Icon(
                            //   Icons.thumb_up),
                            //   focusColor: Colors.blue,
                            //   hoverColor: Colors.red,
                            //   highlightColor: Colors.red,
                            //   splashColor: Colors.orange,
                            //   color: Colors.grey,
                            //   onPressed: () {})
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 30),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    NetData.updateArticle({'thumb_down': 1});
                                  }))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 30),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    NetData.updateArticle({'star': 1});
                                  }))),
                    ]),
                  )),
            ],
          )

          // SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          //   padding: EdgeInsets.all(10),
          //   child:
          //   Stack(
          //     children: <Widget>[
          //       Html(data: _article.body),

          //       Positioned(
          //         bottom: 50,
          //         child: Image.asset('images/avatar.jpg')
          //         )

          //     ],
          //   ),

          //   //Html(data: _article.body),
          // )

          );
    } else {
      return Scaffold(body: CupertinoActivityIndicator());
    }
  }
}
