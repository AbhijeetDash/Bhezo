package com.example.bhezo;

import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.io.*;
import java.util.*;
import android.net.Uri;
import java.lang.reflect.Method;
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
import android.net.wifi.WifiManager.LocalOnlyHotspotCallback;
import android.net.wifi.WifiManager.LocalOnlyHotspotReservation;
import android.net.wifi.WifiInfo;
import android.location.LocationManager;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.NetworkInterface;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

//import 	android.net.wifi.SoftApConfiguration;

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

                    // Main Wifi Code from here...

                    if(call.method.equals("getWifiStatus")){
                        result.success(getWifiStatus());
                    }

                    if(call.method.equals("changeWifiState")){
                        changeWifiStatus();
                        result.success(true);
                    }

                    // Main Server Code...

                    if(call.method.equals("startServer")){
                        // We also need to start the server when we enable the HotSpot.
                        // We must return the IP address and the passcode of the network..
                        result.success(enableHotspot());
                    }

                    if(call.method.equals("getLocationStatus")){
                        // Location must enabled before enabling LocalOnlyHotspot..
                        result.success(locationStatus());
                    }

                    if(call.method.equals("enableLocation")){
                        // If location not enabled only then this happens..
                        openSettings();
                    }

                    // The main code to start the server and get the IP

                    if(call.method.equals("getCodeDetails")){
                        result.success(getIPServer());
                    }

                    if(call.method.equals("getIPClient")){
                        result.success(getIpClient());
                    }
                }
            );
    }

    // Variables must be private static.. as they are being used in 
    // inner class callbacks..
    private static LocalOnlyHotspotReservation mReservation;
    private static WifiConfiguration wap;
    private static String key; 
    private static String ssid;
    
    public boolean enableHotspot(){
        final WifiManager wifiManager = (WifiManager) getBaseContext().getSystemService(Context.WIFI_SERVICE);
        if(wifiManager.isWifiEnabled()){
            wifiManager.setWifiEnabled(false);          
        }
        wifiManager.startLocalOnlyHotspot(new LocalOnlyHotspotCallback() {
            // This is automatically called when (The Hotspot is Created)
            @Override
            public void onStarted(final LocalOnlyHotspotReservation reservation) {
                super.onStarted(reservation);
                // LocalOnlyHotspotReservation.. contains..
                // WifiConfiguration, SoftApConfiguration
                mReservation = reservation;
                wap = mReservation.getWifiConfiguration();
                key = wap.preSharedKey;
                ssid = wap.SSID;
            }

            // Automatically called when the Hotspot is deactivated..
            @Override
            public void onStopped() {
                super.onStopped();
                mReservation.close();
            }

            // Called on Error..
            @Override
            public void onFailed(final int reason) {
                super.onFailed(reason);
            }

        }, new Handler());
        return true;
    }

    public String getIPServer(){
        String ip = "";
        //Get the IP address of the server device...
        try {
            // List of all the NetworkInterfaces that are open at the moment..
            Enumeration<NetworkInterface> enumNetworkInterfaces = NetworkInterface.getNetworkInterfaces();
            while (enumNetworkInterfaces.hasMoreElements()) {
                NetworkInterface networkInterface = enumNetworkInterfaces.nextElement();
                // List of all available INetAddress from Network Interface..
                Enumeration<InetAddress> enumInetAddress = networkInterface.getInetAddresses();
                while (enumInetAddress.hasMoreElements()) {
                    InetAddress inetAddress = enumInetAddress.nextElement();
                    if (inetAddress.isSiteLocalAddress()) {
                        // All available Addresses that can be used as a Host Address..
                        ip += "SiteLocalAddress: "+inetAddress.getHostAddress()+"\n";
                    }
                }
            }
            if(wap!=null){
                // Getting the SSID and Passcode of LocalOnlyHotspot 
                ip += "Passphrase : "+wap.preSharedKey+"\n";
                ip += "SSID : "+wap.SSID;
            }
        } catch (Exception e){
            e.printStackTrace();
            ip += "Something Wrong! " + e.toString() + "\n";
        }        
        return ip;
    }

    // Don't know if client's IP address is needed or not..
    // But this code does it anyway.. (:o)-|
    public String getIpClient(){
        try {
            final WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(WIFI_SERVICE);
            assert wifiManager != null;
            final WifiInfo wifiInfo = wifiManager.getConnectionInfo();
            final int ipInt = wifiInfo.getIpAddress();
            return InetAddress.getByAddress(ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(ipInt).array()).getHostAddress();
        } catch (Exception e) {
            System.out.println(e);
            return null;
        }
    }

    // public void startServer(){
    //     final Thread server = new Thread(new ServerThread());
    //     yet to create the server thread
    //     server.run();
    // }
    
    // this is also done..
    public boolean locationStatus(){
        final LocationManager location = (LocationManager) getApplicationContext().getSystemService(Context.LOCATION_SERVICE);
        return location.isProviderEnabled(LocationManager.GPS_PROVIDER);
    }
    // Opens settings to enable location
    public void openSettings(){
        startActivity(new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));
    }

    // gets the wifi status for UI update..
    public boolean getWifiStatus(){
        final WifiManager wifiMan = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        return wifiMan.isWifiEnabled();
    }

    // changes the wifi status from ON-VV-OFF
    public void changeWifiStatus(){
        final WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        wifiManager.setWifiEnabled(!wifiManager.isWifiEnabled());
    }


    // The code bellow is to get the files, pictures, videos, apps and all..
    // These are working great for now.. 
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