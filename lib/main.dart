// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './NasaResponse.dart';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
//import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyAppState());
}

Future<APODResponse> fetchPost() async {
  final response = await http.get(
      'https://api.nasa.gov/planetary/apod?api_key=h2SEJLbrEpFUkh86Jx0ZowoGAvxnowtxd6aKXLvg');

  if (response.statusCode == 200) {
    print(response.body);
    // If the call to the server was successful, parse the JSON
    return APODResponse.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
     throw Exception('Failed to load post');
  }
}

class MyApp extends State<MyAppState> {
  StreamController<APODResponse> _refreshController;

   static APODResponse nasaResponse = new APODResponse();
  
  _getData() async{
      nasaResponse = await fetchPost();
     
    _refreshController.add(nasaResponse);
  }

   _fetch() {
 
    _getData();
    
  }

  @override
  void initState() {
    super.initState();
    
    _refreshController = new StreamController<APODResponse>();
  
    _getData();
  }

 
  @override
  Widget build(BuildContext context) {



    Widget reLoad = Container(
      
      child: MaterialButton(
                minWidth: 200.0,
                height: 42.0,
                color: Colors.tealAccent[700],
                onPressed:(){ _fetch();},
                child: Text(
                  'Reload',
                  style: TextStyle(color: Colors.white),
                ))
    );

    

    return new MaterialApp(
      title: "Snow's APOD",
      home: Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          title: Text('Apod'),
        ),
        body:Container(
          child: StreamBuilder(
            stream: _refreshController.stream,
            builder: (BuildContext context,AsyncSnapshot snapshot){
            if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (snapshot.hasData) {
              return new ListView(
          children: <Widget>[
            new RefreshIndicator(
                      onRefresh: _fetch(),
                child: ListView(
                  children : <Widget>[        
           new Image.network(
              snapshot.data.url,
              width: 600.0,
              height: 550.0,
              fit: BoxFit.cover,
            ),
            new Text(
                    snapshot.data.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Text(
                  snapshot.data.explanation,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                reLoad
                  ]
                )  
            )      
          ],
        );
                }
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }  
                       
            }
          ),
        )
         
      ),
    );
  }
}

class MyAppState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   

    return MyApp();
  }
}