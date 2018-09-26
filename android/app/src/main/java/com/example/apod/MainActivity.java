package com.example.apod;

import android.app.WallpaperManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;

import java.io.File;
import java.io.IOException;
import java.nio.channels.Channel;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.content.ContentValues.TAG;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "demo/message";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler(){

      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        final Map<String,Object> arguments = methodCall.arguments();

        if (methodCall.method.equals("getMessage"))
        {
          String path = (String) arguments.get("path");
          String message = "Its working and the path is -- "+ path;
          result.success(message);
          setWallpaper(path);
        }
      }

      private void setWallpaper (String path)
      {
        File imgFile = new  File(path);
        Log.e(TAG, "shareFilepathhhhhhhhhhhhh: "+imgFile);
        // set bitmap to wallpaper
        Bitmap bitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        WallpaperManager wm = WallpaperManager.getInstance(getApplication().getApplicationContext());
        try{
          wm.setBitmap(bitmap);
        }catch (IOException e){
          Log.e(TAG, "shareFile: cannot set image as wallpaper",e );
        }
      }
    });
  }
}
