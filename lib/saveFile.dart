import 'dart:async';
import 'dart:io' as Io;
import 'dart:io';
import 'package:image/image.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<Io.File> getImageFromNetwork(String url) async {
    var cacheManager = await CacheManager.getInstance();
    Io.File file = await cacheManager.getFile(url);
    return file;
  }

  Future<String> saveImage(String url) async {
    final file = await getImageFromNetwork(url);
    //retrieve local path for device
    String fileName = "";
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());
    int cut = url.lastIndexOf('/');
    if (cut != -1) {
      fileName = url.substring(cut + 1);
    }
    print(fileName);
    // Save the thumbnail as a PNG.
    var dir = new File('$path/$fileName');

    String result = "";
    bool isThere = await dir.exists();
    // dir.exists().then((isThere) {
    if (isThere) {
      result = "exists";
    } else {
      Io.File fil = new Io.File('$path/$fileName')
        ..writeAsBytesSync(encodePng(image));
      print(fil);
      result = fil.path;
      String name = await getFileName();
      if (name != null && name != fileName) {
        deleteImage('$path/$name');
      }
      if (await setFileName(fileName)) {
        print("filename has been set $fileName");
      }
    }

    return result;
  }

  deleteImage(String name) async {
    try {
      Io.File file = new Io.File(name);
      if (await file.exists()) {
        if (file.delete() != null) print("file $name got Deleted");
      }
    } on Error catch (e) {
      print(e.stackTrace);
    }
  }

  Future<String> getFileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("filename");
    return name;
  }

  Future<bool> setFileName(String fileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("filename", fileName);
    return prefs.commit();
  }
}
