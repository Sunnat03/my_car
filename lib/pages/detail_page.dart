import 'dart:io';
import 'package:my_car/models/post_model.dart';
import 'package:my_car/services/db_service.dart';
import 'package:my_car/services/rtdb_service.dart';
import 'package:my_car/services/stor_service.dart';
import 'package:my_car/services/util_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  final DetailState state;
  final Post? post;

  const DetailPage({this.state = DetailState.create, this.post, Key? key})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<File> image = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  Post? updatePost;

  // for image
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    _detectState();
  }

  void _detectState() {
    if (widget.state == DetailState.update && widget.post != null) {
      updatePost = widget.post;
      descriptionController.text = updatePost!.description;
      nameController.text = updatePost!.name;
      setState(() {});
    }
  }

  void _getImage() async {
    XFile? a = await _picker.pickImage(source: ImageSource.gallery);
    if (a == null) return;
    File file = File(a.path);
    image.add(file);
    setState(() {});

    // if (image != null) {
    //   setState(() {
    //     file = File(image.path);
    //   });
    // } else {
    //   if (mounted) Utils.fireSnackBar("Please select image for post", context);
    // }
  }

  void _addPost() async {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    List<String>? imageUrl;

    if (name.isEmpty || description.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    String? userId = await DBService.loadUserId();

    // if (userId == null) {
    //   if (mounted) {
    //     Navigator.pop(context);
    //   }
    //   return;
    // }

    if (image != null) {
      imageUrl = await StorageService.uploadImages(image);
    }
print('aaaaaaa:$imageUrl');
    Post post = Post(
        postKey: "",
        userId: userId ?? 'my',//todo
        name: name,
        description: description,
        image: imageUrl);

    await RTDBService.storePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  void _updatePost() async {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    List<String>? imageUrl;

    if (name.isEmpty || description.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StorageService.uploadImages(image);
    }

    Post post = Post(
        postKey: updatePost!.postKey,
        userId: updatePost!.userId,
        name: name,
        description: description,
        image: imageUrl ?? updatePost!.image);

    await RTDBService.updatePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: widget.state == DetailState.update
            ? const Image(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/detail_page_logo.png",
                ))
            : const Image(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/detail_page_logo.png",
                )),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/img_back.jpg'),
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // #image
                  GestureDetector(
                    onTap: _getImage,
                    child:image.isNotEmpty ? SizedBox(
                      height: MediaQuery.of(context).size.width * .5,
                      width: MediaQuery.of(context).size.width * .7,
                      child: PageView(
                        children: image.map((i) => Image.file(i, fit: BoxFit.cover,),).toList(),
                      ),
                    ): Image.asset('assets/images/logo.jpg'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #firstname
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      focusColor: Colors.red,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      hintText: "Name",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #lastname
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      focusColor: Colors.red,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      hintText: "Description",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #add_update
                  ElevatedButton(
                    onPressed: () {
                      if (widget.state == DetailState.update) {
                        _updatePost();
                      } else {
                        _addPost();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size(double.infinity, 50)),
                    child: Text(
                      widget.state == DetailState.update ? "Update" : "Add",
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

enum DetailState {
  create,
  update,
}
