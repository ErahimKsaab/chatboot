import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> _list=[];
  String BOT_URL="https://hygeai.herokuapp.com/get?msg=";

  TextEditingController quarr=TextEditingController();

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(title: Text("chattbot"),centerTitle: true,),
      body: Stack(
        children: [
          AnimatedList(initialItemCount: _list.length, key: _listKey,itemBuilder : ( BuildContext context , int index , Animation animation ) { return buildItenl_data ( _list[index] , animation , index ); }),
          Align(alignment : Alignment.bottomCenter ,child:ColorFiltered(colorFilter: ColorFilter.linearToSrgbGamma(),
            child: Container(color: Colors.white,child: Padding(padding: EdgeInsets.only(left:20,right:20),child: TextField(decoration: InputDecoration(icon: Icon(Icons.message,color: Colors.blue,),hintText: "Hello",fillColor: Colors.white),controller: quarr,textInputAction: TextInputAction.send,onSubmitted: (msg){
              this.getresponce();
            },),),),) ,)
        ],
      ),
    );
  }


http.Client get(){
  print("getgetgetgetget");
return http.Client();
}

  void getresponce() {
    if(quarr.text.length>0){
      this.insertsignal(quarr.text);
      var clint=get();
      try{
clint.post(BOT_URL,body: {"query":quarr.text},)..then((value){
  print(value.body);
  print("ccccccccccccc");
  Map<String,dynamic>data=jsonDecode(value.body);
  insertsignal(data["response"]+"<bot>");

});
      }catch(r){
        print(r);
      }
      finally
      {
        clint.close();
        quarr.clear();
      }
    }
  }

  void insertsignal(String text) {
    _list.add(text);
    _listKey.currentState.insertItem(_list.length-1);
  }
}
Widget buildItenl_data(String item, Animation animation, int index) {
  bool mine=item.endsWith("<bot>");
  return SizeTransition(sizeFactor: animation,child: Padding(padding: EdgeInsets.only(top: 10),child: Container(alignment:mine?Alignment.topLeft:Alignment.topRight ,
    child:Bubble(padding: BubbleEdges.all(10),
      color:mine?Colors.blue : Colors.grey,
      child: Text(item.replaceAll("<bot>", "",),style: TextStyle(color: mine?Colors.white:Colors.black)),
    ),
  ),),);
}
