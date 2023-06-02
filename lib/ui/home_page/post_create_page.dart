import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/post_details.dart';
import 'home_controller.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  var controller = Get.put(HomeController());
  TextEditingController description = TextEditingController(text: "");
  XFile? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          icon: const Icon(Icons.create),
          onPressed: () async {
            if (imageFile == null && description.text == "") {
              Fluttertoast.showToast(
                  msg: "Please add a description",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return;
            }
            if (description.text.length > 300) {
              Fluttertoast.showToast(
                  msg: "Only 300 characters allowed",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return;
            }
            if (imageFile != null && description.text.length > 150) {
              Fluttertoast.showToast(
                  msg: "Only 150 characters allowed with image",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return;
            }

            try {
              if (imageFile != null) {
                controller.createPost(
                  PostDetails(
                    description: description.text,
                    imgName: imageFile!.name,
                    imgPath: imageFile!.path,
                    msgType: "image",
                  ),
                );
              } else {
                controller.createPost(
                  PostDetails(
                    description: description.text,
                    msgType: "text",
                  ),
                );
              }
            } catch (e) {
              log(e.toString());
            } finally {
              controller.setImgFile(false);

              Get.back();
            }
          },
          label: const Text("Create")),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Post",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => controller.imgFile.value && imageFile != null
                    ? GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          imageFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          controller.setImgFile(true);
                          setState(() {});
                        },
                        child: Image.file(
                          File(imageFile!.path),
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                        ),
                      )
                    : IconButton(
                        iconSize: 30,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          imageFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          controller.setImgFile(true);

                          setState(() {});
                        },
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  maxLines: 4,
                  controller: description,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    labelText: 'Description',
                    labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
