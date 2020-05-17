import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    
    Container(
      color: Colors.white,
      child: Center(
        child:CupertinoActivityIndicator(
          // radius: 30.0,
          //   animating: true,
        ),
      ),
    );
  }
}