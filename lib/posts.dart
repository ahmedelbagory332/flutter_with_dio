import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/posts_model.dart';
import 'Utils.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<PostsModel> posts = [];
  late BuildContext dialogContext;

  Future<void> getAllPosts() async {
    const postUrl = 'https://jsonplaceholder.typicode.com/posts';
    Dio dio = Dio();

    try {
      final response = await dio.get(postUrl);

      if (response.statusCode == 200) {

        for(var post in response.data){
          setState(() {
            posts.add(PostsModel.fromJson(post));
          });
        }

      } else {
        debugPrint('Error : ${response.data}');
      }
    } catch (e) {
      debugPrint('exception $e');
    }
  }

  Future<void> updatePost(title,postId) async {
    var postUrl = 'https://jsonplaceholder.typicode.com/posts/$postId';
    Dio dio = Dio();

    final data = {
      "title": title,
    };

    dio.options.headers['Content-type'] = 'application/json; charset=UTF-8';

    try {
      final response = await dio.patch(postUrl,data: data);
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);
      // ignore: use_build_context_synchronously
      buildShowSnackBar(context, "post updated");
      debugPrint('post : ${response.data}');
    } catch (e) {
      debugPrint('exception $e');
    }
  }

  Future<void> deletePost(postId) async {
    var postUrl = 'https://jsonplaceholder.typicode.com/posts/$postId';

    Dio dio = Dio();
    dio.options.headers['Content-type'] = 'application/json; charset=UTF-8';

    try {
      final response = await dio.delete(postUrl);
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);
      // ignore: use_build_context_synchronously
      buildShowSnackBar(context, "post deleted");
      debugPrint('post : ${response.data}');
      debugPrint('message : ${response.statusMessage}');
    } catch (e) {
      debugPrint('exception $e');
    }
  }

  @override
  void initState() {
  getAllPosts();
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Posts"),
        ),
        body: posts.isEmpty
            ? const Center(child: Text("Loading..."))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text(posts[index].title.toString(),style: const TextStyle(fontWeight: FontWeight.bold),)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(posts[index].body.toString(),overflow: TextOverflow.ellipsis,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
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
                                    updatePost("new post title to update", posts[index].id);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
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
                                    deletePost(posts[index].id);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
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
                })
        );
  }
}
