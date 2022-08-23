import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'Utils.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  late BuildContext dialogContext;


  Future<void> addPosts(title,body) async {
    const postUrl = 'https://jsonplaceholder.typicode.com/posts';
    Dio dio = Dio();
    final data = {
      "title": title,
      "body": body,
      "userId": 1,
    };

    dio.options.headers['Content-type'] = 'application/json; charset=UTF-8';

    try {
      final response = await dio.post(postUrl,data: data);
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);
      // ignore: use_build_context_synchronously
      buildShowSnackBar(context, "post added");
      debugPrint('post : ${response.data}');
      debugPrint('post : ${response.statusMessage}');
    } catch (e) {
      debugPrint('exception $e');
    }
  }




  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Post"),
          automaticallyImplyLeading: false,
        ),
        body:   ListView(
          scrollDirection: Axis.vertical,
          children:  [
            Padding(
              padding:  const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*.4,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*.4,
                    child: TextField(
                      controller: bodyController,
                      decoration: InputDecoration(
                        labelText: 'body',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:  const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              dialogContext = context;
                              return  const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                        );
                        if(titleController.text.isEmpty || bodyController.text.isEmpty){
                          buildShowSnackBar(context, "please check your info.");
                        }else {
                          addPosts(titleController.text, bodyController.text);
                        }
                      },
                      child: const Text(
                        'Add Post',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


}