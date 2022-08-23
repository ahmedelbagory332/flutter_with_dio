import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';



ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(BuildContext context,String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: const TextStyle(fontSize: 16),
    ),
  ));
}



Future<bool> isFileDownloaded(fileName) async{
  bool isDownloaded = false;

  var state = await Permission.manageExternalStorage.status;
  var state2 = await Permission.storage.status;


  if (!state2.isGranted) {
    await Permission.storage.request();
  }
  if (!state.isGranted) {
    await Permission.manageExternalStorage.request();
  }
    List files = Directory("storage/emulated/0/Download From Dio Flutter").listSync();
    for(var file in files){
      if(file.path == "storage/emulated/0/Download From Dio Flutter/$fileName"){
        isDownloaded = true;
      }
    }



  return isDownloaded;
}