import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  Demo({Key key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    var data = {
      BannerLocation.topStart: Colors.red,
      BannerLocation.topEnd: Colors.green,
      BannerLocation.bottomStart: Colors.yellow,
      BannerLocation.bottomEnd: Colors.blue,
    };

    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: data.keys
            .map((e) => Container(
                  color: Colors.blue,
                  width: 150,
                  height: 150 * 0.618,
                  child: Banner(
                    textStyle: TextStyle(fontSize:10),
                    
                    message: "news",
                    location: e,
                    color: data[e],
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Image.asset('images/avatar.jpg'),
                    ),
                  ),
                ))
            .toList(),
             
      ),
    );
  }
}
