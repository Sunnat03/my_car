import 'dart:io';
import 'package:my_car/main.dart';
import 'package:my_car/models/post_model.dart';
import 'package:my_car/pages/detail_page.dart';
import 'package:my_car/services/db_service.dart';
import 'package:my_car/services/rtdb_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const id = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _getAllPost();
  }

  void _getAllPost() async {
    isLoading = true;
    setState(() {});

    String userId = await DBService.loadUserId() ?? "null";
    items = await RTDBService.loadPosts(userId);

    isLoading = false;
    setState(() {});
  }


  void _openDetailPage() {
    Navigator.pushNamed(context, DetailPage.id);
  }

  void _deleteDialog(String postKey) async {
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Do you want to delete this post?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () => _deletePost(postKey),
                child: const Text("Confirm"),
              ),
              CupertinoDialogAction(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Do you want to delete this post?"),
            actions: [
              TextButton(
                onPressed: () => _deletePost(postKey),
                child: const Text("Confirm"),
              ),
              TextButton(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        }
      },
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _deletePost(String postKey) async {
    Navigator.pop(context);
    isLoading = true;
    setState(() {});

    await RTDBService.deletePost(postKey);
    _getAllPost();
  }

  void _editPost(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DetailPage(
            state: DetailState.update,
            post: post,
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyFirebaseApp.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    _getAllPost();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Image(fit: BoxFit.cover,image: AssetImage("assets/images/car_logo.jpg",),

        ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: _openDetailPage,
            icon: const Icon(Icons.add,color: Colors.black,),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _itemOfList(items[index]);
        },
      ),
    );
  }
  Widget _itemOfList(Post post) {
    return GestureDetector(
      onLongPress: () => _deleteDialog(post.postKey),
      onDoubleTap: () => _editPost(post),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: post.image != null
                  ? Image.network(
                post.image!.first,
                fit: BoxFit.cover,
              )
                  : const Image(
                image: AssetImage(
                  "assets/images/placeholder.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            Text(
              post.name,
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              post.description,
              style: const TextStyle(fontSize: 18),
            ),

          ],
        ),
      ),
    );
  }
}