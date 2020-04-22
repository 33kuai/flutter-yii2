import 'package:flutter/material.dart';
import 'package:zuxianzhi/utils/netData.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController;


  List suggest=[];
  var result;


  void getSuggest(String keyword){

      NetData.getMovieList(keyword).then((value){
        if(this.mounted){
           
          setState(() {
            suggest = value;
          });
        }
      });
  }


  void getResult(){


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                        //labelText: '搜索'
                        ),
                    controller: _searchController,
                    onChanged: (value) {
                      getSuggest(value);
                    },
                    onSubmitted: (value) {},
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Container(
                      padding: EdgeInsets.only(top: 1),
                      child: new ListView.builder(
                       itemCount: suggest.length,
                       itemBuilder: (context,item){

                         return  ListTile(
                           leading: Text(suggest[item].star),
                           title:Text(suggest[item].name),
                           subtitle: Text(suggest[item].type),
                           trailing: Text(suggest[item].directors),

                         );
                         
                       },
                      )),
                ),
              ],
            )));
  }
}
