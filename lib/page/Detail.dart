import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  
  Detail({Key key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  Future detail;
 
 
 @override
  void initState() {
    
    
   // detail = NetData.getArticle(args.id);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final DetailArgs args = ModalRoute.of(context).settings.arguments;

    print(args.id);
    return Text('sssss');

    // return Container(
    //    child: FutureBuilder(
    //      future: detail,
    //      builder: (context,snapshot){
    //         if(snapshot.hasData) {       
    //           return Text(snapshot.data.article.title);
    //         }else{
    //           return CircularProgressIndicator();
    //           //return Text("No data");
    //         }
    //                  // return CircularProgressIndicator();
    //      }
    //      )
    // );
  }
}

class DetailArgs{
  final int id;
  DetailArgs(this.id);
}