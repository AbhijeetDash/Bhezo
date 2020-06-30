package com.example.bhezo;

import android.os.Environment;
import android.os.Handler;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.io.*;
import java.util.*;
import android.net.Uri;
import android.provider.MediaStore;
import android.provider.MediaStore.Video;
import android.provider.MediaStore.Video.Media;
import android.database.Cursor;
import android.content.Context;
import android.content.ContentResolver;
import android.content.Intent;
import android.media.MediaMetadataRetriever;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiConfiguration;
import java.lang.reflect.Method;
import android.net.wifi.WifiManager.LocalOnlyHotspotCallback;
import android.net.wifi.WifiManager.LocalOnlyHotspotReservation;
import android.location.LocationManager;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "bhejo.flutter.dev/FUNCTIONS";
    
    @Override
    public void configureFlutterEngine(@NonNull final FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if(call.method.equals("getFolders")){
                        List<Map<String, Object>> data = getFiles();
                        result.success(data);
                    }

                    if(call.method.equals("getFolderAtPath")){
                        String path = call.argument("path");
                        List<Map<String, Object>> data = getFolderAtPath(path);
                        result.success(data);
                    }
                    
                    if(call.method.equals("getMusic")){
                        List<Map<String, Object>> data = getMusic();
                        result.success(data);
                    }

                    if(call.method.equals("getVideo")){
                        List<Map<String, Object>> data = getVideo();
                        result.success(data);
                    }

                    if(call.method.equals("getPictures")){
                        Map<String, Object> data = getPictures();
                        result.success(data);
                    }

                    if(call.method.equals("getWifiStatus")){
                        result.success(getWifiStatus());
                    }

                    if(call.method.equals("changeWifiState")){
                        changeWifiStatus();
                        result.success(true);
                    }

                    if(call.method.equals("startServer")){
                        result.success(enableHotspot());
                    }

                    if(call.method.equals("getLocationStatus")){
                        result.success(locationStatus());
                    }

                    if(call.method.equals("enableLocation")){
                        openSettings();
                    }

                    if(call.method.equals("getIP")){
                        result.success(getIP());
                    }
                }
            );
    }


    private static LocalOnlyHotspotReservation mReservation;
    
    public boolean enableHotspot(){
        final WifiManager wifiManager = (WifiManager) getBaseContext().getSystemService(Context.WIFI_SERVICE);
        if(wifiManager.isWifiEnabled()){
            wifiManager.setWifiEnabled(false);          
        }       
        wifiManager.startLocalOnlyHotspot(new WifiManager.LocalOnlyHotspotCallback() {    
            @Override
            public void onStarted(final WifiManager.LocalOnlyHotspotReservation reservation) {
                super.onStarted(reservation);
                mReservation = reservation;
            }
    
            @Override
            public void onStopped() {
                super.onStopped();
            }
    
            @Override
            public void onFailed(final int reason) {
                super.onFailed(reason);
            }

        }, new Handler());
        return true;
    }

    // Server code..
    
    public String getIP(){
        try {
            final WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(WIFI_SERVICE);
            assert wifiManager != null;
            final WifiInfo wifiInfo = wifiManager.getConnectionInfo();
            final int ipInt = wifiInfo.getIpAddress();
            return InetAddress.getByAddress(ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(ipInt).array()).getHostAddress()+"..."+8080;
        } catch (Exception e) {
            return null;
        }
    }

    public void startServer(){
        final Thread server = new Thread(new ServerThread());
        server.run();
    }
    
    // this is also done..

    public boolean locationStatus(){
        final LocationManager location = (LocationManager) getApplicationContext().getSystemService(Context.LOCATION_SERVICE);
        return location.isProviderEnabled(LocationManager.GPS_PROVIDER);
    }

    public void openSettings(){
        startActivity(new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));
    }

    // Dont Hurt me please..

    public boolean getWifiStatus(){
        final WifiManager wifiMan = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        return wifiMan.isWifiEnabled();
    }

    public void changeWifiStatus(){
        final WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        wifiManager.setWifiEnabled(!wifiManager.isWifiEnabled());
    }

    public Map<String,Object> getPictures(){
        final HashMap<String, Object> allImageInfoList = new HashMap<>();
        final ArrayList<String> allImageList = new ArrayList<>();
        final ArrayList<String> displayNameList = new ArrayList<>();
        final ArrayList<String> dateAddedList = new ArrayList<>();
        final ArrayList<String> titleList = new ArrayList<>();
        final Uri uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        final String[] projection = { MediaStore.Images.ImageColumns.DATA,
                MediaStore.Images.ImageColumns.DISPLAY_NAME,
                MediaStore.Images.ImageColumns.DATE_ADDED,
                MediaStore.Images.ImageColumns.TITLE };
        final Cursor c = getContentResolver().query(uri, projection, null, null, null);
        if (c != null) {
            while (c.moveToNext()) {
                titleList.add(c.getString(3));
                displayNameList.add(c.getString(1));
                dateAddedList.add(c.getString(2));
                allImageList.add(c.getString(0));
            }
            c.close();

            allImageInfoList.put("URIList", allImageList);
            allImageInfoList.put("DISPLAY_NAME", displayNameList);
            allImageInfoList.put("DATE_ADDED", dateAddedList);
            allImageInfoList.put("TITLE", titleList);

        }
        return allImageInfoList;
    }

    public List<Map<String,Object>> getVideo(){
        final ContentResolver contentResolver = getContentResolver();
        final Uri videoUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        final Cursor cursor = contentResolver.query(videoUri, null,null,null,null);
        final List<Map<String,Object>> videos = new ArrayList<>(2);
        if(cursor != null && cursor.moveToFirst()){
            while(cursor.moveToNext()){
                videos.add(getVideoData(cursor));
            }
        }
        cursor.close();
        return videos;
    }

    public List<Map<String, Object>> getMusic(){
        final ContentResolver contentResolver = getContentResolver();
        final Uri songUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
        final Cursor cursor = contentResolver.query(songUri, null, null, null, null);
        final List<Map<String, Object>> songs = new ArrayList<>(2);
        if(cursor != null && cursor.moveToFirst()){
            while(cursor.moveToNext()){
                songs.add(getMusicData(cursor));
            }
        }
        cursor.close();
        return songs;
    }

    public List<Map<String, Object>> getFiles(){
        final String rootPath =  String.valueOf(Environment.getExternalStorageDirectory());
        final File dir = new File(rootPath);
        final File[] files = dir.listFiles();
        final List<Map<String, Object>> myFiles = new ArrayList<>(files.length);
        for(final File file : files){
            if(!file.isHidden()){
                final Map<String, Object> map = getFileData(file);
                myFiles.add(map);
            }
        }
        return myFiles;
    }

    public List<Map<String, Object>> getFolderAtPath(final String path){
        final File dir = new File(path);
        final File[] files = dir.listFiles();
        final List<Map<String, Object>> myFiles = new ArrayList<>(files.length);
        for(final File file: files){
            if(!file.isHidden()){
                final Map<String, Object> map = getFileData(file);
                myFiles.add(map);
            }
        } 
        return myFiles;
    }

    public static Map<String, Object> getFileData(final File file){
        final Map<String, Object> map = new HashMap<>();
        map.put("file_name", file.getName());
        map.put("file_path", file.getPath());
        map.put("isDir", file.isDirectory());
        return map;
    }

    public Map<String,Object> getMusicData(final Cursor cursor){
        final String song_name = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DISPLAY_NAME));
        final Map<String,Object> map = new HashMap<>();
        final String fullpath = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATA));
        final String album_name = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ALBUM));
        final String artist_name = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ARTIST));
        map.put("songName", song_name);
        map.put("fullPath", fullpath);
        map.put("albumName", album_name);
        map.put("artistName", artist_name);
        return map;
    }

    public Map<String, Object> getVideoData(final Cursor cursor){
        final Map<String,Object> map = new HashMap<>();
        final String video_name = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DISPLAY_NAME));
        final String fullPath = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DATA));
        final String duration = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DURATION));
        map.put("videoName",video_name);
        map.put("fullPath", fullPath);
        map.put("duration", duration);
        return map;
    }
}

class ServerThread implements Runnable {
    @Override
    public void run() {
       Socket socket;
       try {
          serverSocket = new ServerSocket(8080);
          try {
             socket = serverSocket.accept();
             output = new PrintWriter(socket.getOutputStream());
             input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
             new Thread(new Thread2()).start();
          } catch (final IOException e) {
             e.printStackTrace();
          }
       } catch (final IOException e) {
          e.printStackTrace();
       }
    }
 }

 class Thread2 implements Runnable {
    @Override
    public void run() {
       while (true) {
          try {
             final String message = input.readLine();
             if (message != null) {
                // Files are recieved here
             } else {
                ServerThread = new Thread(new ServerThread());
                ServerThread.start();
                return;
             }
          } catch (IOException e) {
             e.printStackTrace();
          }
       }
    }
 }