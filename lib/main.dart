import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Postmodal.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Api(),
    );
  }
}

class Api extends StatefulWidget {
  const Api({Key? key}) : super(key: key);

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  List<Postmodal> postlist = [];
  Future <List<Postmodal>> getpost() async{
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if(res.statusCode ==200){
   postlist.clear();
      var data = jsonDecode(res.body.toString());
      for (Map i in data){
        postlist.add(Postmodal.fromJson(i));

      }
      return postlist;

    }else{
      return postlist ;
    }


  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Json Data Parsing"),
      centerTitle: true,),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
            future:  getpost(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(!snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Center(
                      child:CircularProgressIndicator()),
                  SizedBox(height: 100,),
                  Text("Data is loading... ",style: TextStyle(fontSize: 30),),
                ],
              );

            }else{
              return ListView.builder(itemBuilder: (context,index){

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: index%2==0? Colors.blue.shade300:index%7==0?Colors.green:Colors.purple,



                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child:ListTile(
                          title:Text(postlist[index].title.toString(),style: TextStyle(fontSize: 20),) ,
                          subtitle: Text(postlist[index].body.toString(),style: TextStyle(fontSize: 16),),
                          leading: Text(postlist[index].id.toString(),style: TextStyle(fontSize: 23,color: Colors.white),),

                        )
                      )),
                );

              },itemCount:  postlist.length,
              );
            }
          },


          ))
        ],
      ),
    );
  }
}

