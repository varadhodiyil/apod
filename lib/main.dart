// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apod/saveFile.dart';
import 'package:flutter/services.dart';
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
  static const platform = const MethodChannel('demo/message');
  String _message = "Hellow Rajvel";
  static APODResponse nasaResponse = new APODResponse();

  Future<String> _getMessage(String url) async {
    String value;
    try {
      File file = await SaveFile().saveImage(url);
      var sendMap = <String, dynamic>{'path': file.path};
      value = await platform.invokeMethod('getMessage', sendMap);
    } on Error catch (e) {
      throw 'Error has occured while saving';
    }

    return value;
  }

  Future<Null> _getData() async {
    nasaResponse = await fetchPost();
    _refreshController.add(nasaResponse);
    _getMessage(nasaResponse.url).then((String message) {
      setState(() {
        _message = message;
      });
    });
    return null;
  }

  @override
  void initState() {
    super.initState();

    _refreshController = new StreamController<APODResponse>();

    
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // Widget reLoad = Container(
    //     child: MaterialButton(
    //         minWidth: 200.0,
    //         height: 42.0,
    //         color: Colors.tealAccent[700],
    //         onPressed: () {
    //           _fetch();
    //         },
    //         child: Text(
    //           'Reload',
    //           style: TextStyle(color: Colors.white),
    //         )));

    return new MaterialApp(
      title: "Snow's APOD",
      home: Scaffold(
          backgroundColor: Colors.amberAccent,
          appBar: AppBar(
            title: Text('Apod'),
          ),
          body: Container(
            child: StreamBuilder(
                stream: _refreshController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }
                  if (snapshot.hasData) {
                    return new Column(
                      children: <Widget>[
                        Expanded(
                            child: Scrollbar(
                                child: RefreshIndicator(
                                    onRefresh: _getData,
                                    child: ListView(children: <Widget>[
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
                                      new Text(
                                        _message,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      // reLoad
                                    ]))))
                      ],
                    );
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )),
    );
  }
}

class MyAppState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyApp();
  }
}
