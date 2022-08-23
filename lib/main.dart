import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/add_post.dart';
import 'package:flutter_api/posts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Utils.dart';
import 'notifications.dart';
import 'package:open_file/open_file.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  notificationInitialization();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Api'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> uploadFile(filePath) async {

    var postUrl = 'https://bego88.000webhostapp.com/upload.php';
    String fileName = filePath.split('/').last;
    debugPrint("File Path$filePath");


    Dio dio = Dio();
    FormData formData =  FormData.fromMap({
      "fileToUpload": await MultipartFile.fromFile(filePath, filename: fileName),
    });


    try {
      final response = await dio.post(postUrl,data: formData,
        onSendProgress: (count, total) {
        uploadingNotification(total, count, true);
      },).whenComplete(() {
        uploadingNotification(0, 0, false);
      });
      // ignore: use_build_context_synchronously
      buildShowSnackBar(context, "file uploaded");
      debugPrint('file : ${response.data}');
    } catch (e) {
      debugPrint('exception $e');
    }
  }

  Future<void> downloadFile(fileUrl,filePath)   async {

    String fileName = fileUrl.split('/').last;
    await isFileDownloaded(fileName) ?
    OpenFile.open("$filePath/$fileName")
        : Dio().download(fileUrl, "$filePath/$fileName", onReceiveProgress: (count, total) {
      downloadingNotification(total, count, false);
    },).whenComplete(() {
      downloadingNotification(0, 0, true);
    });



  }


  @override
  Widget build(BuildContext context) {

   return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const Posts()),
                  );
                },
                child: const Text("Get All Posts")
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const AddPost()),
                  );
                },
                child: const Text("Add New post")
            ),
            ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    uploadFile(result.files.single.path);
                  }

                },
                child: const Text("Upload File To Server")
            ),
            ElevatedButton(
                onPressed: () async {
                  Directory directory = Directory("storage/emulated/0/Download From Dio Flutter");

                  var state = await Permission.manageExternalStorage.status;
                  var state2 = await Permission.storage.status;

                  if (!state2.isGranted) {
                    await Permission.storage.request();
                  }
                  if (!state.isGranted) {
                    await Permission.manageExternalStorage.request();
                  }
                  if (!await directory.exists()) {
                    await directory.create();
                    downloadFile("https://bego88.000webhostapp.com/uploads/20220823_100232.jpg",directory.path);
                  }else{
                   downloadFile("https://bego88.000webhostapp.com/uploads/20220823_100232.jpg",directory.path);
                  }


                },
                child: const Text("Download File From Server")
            ),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  


}
