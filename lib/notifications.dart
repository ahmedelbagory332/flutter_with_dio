import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> notificationInitialization() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =  InitializationSettings(
    android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


Future<void> uploadingNotification(maxProgress, progress , isUploading) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if(isUploading){
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        "uploading files",
        "Uploading Files Notifications",
        channelDescription: "show to user progress for uploading files",
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
        autoCancel: false
    );


    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      5,
      'Uploading file',
      '',
      platformChannelSpecifics,
    );
  }else{

    flutterLocalNotificationsPlugin.cancel(5);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      "files",
      "Files Notifications",
      channelDescription: "Inform user files uploaded",
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
    );


    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000000),
      'file uploaded',
      '',
      platformChannelSpecifics,
    );
  }



}

Future<void> downloadingNotification(maxProgress, progress , isDownloaded) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if(!isDownloaded){
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        "downloading files",
        "downloading Files Notifications",
        channelDescription: "show to user progress for downloading files",
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
        autoCancel: false
    );


    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      6,
      'Downloading file',
      '',
      platformChannelSpecifics,
    );
  }else{

    flutterLocalNotificationsPlugin.cancel(6);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      "files",
      "Files Notifications",
      channelDescription: "Inform user files downloaded",
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,


    );


    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000000),
      'File Downloaded',
      '',
      platformChannelSpecifics,
    );
  }



}




