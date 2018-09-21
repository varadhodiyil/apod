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
  _getData() {
    print("yo");
    setState(() {
      // nasaResponse = await fetchPost();
      fetchPost().then((data) => nasaResponse);

      print(nasaResponse.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    // nasaResponse = await  fetchPost();

    _getData();
  }

  static APODResponse nasaResponse = new APODResponse();
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    // nasaResponse.,
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget reLoad = Container(
      child: MaterialButton(
        child: new Text("Reload"),
        onPressed: _getData(),
        color: Colors.amberAccent,
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        '''
        ''',
        softWrap: true,
      ),
    );

    return new MaterialApp(
      title: "Snow's APOD",
      home: Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          title: Text('Apod'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 550.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            textSection,
            reLoad
          ],
        ),
      ),
    );
  }
}

class MyAppState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return MyApp();
  }
}
