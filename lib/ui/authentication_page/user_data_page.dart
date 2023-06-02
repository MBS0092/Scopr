import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/user_model.dart';
import 'auth_controller.dart';

class UserDataPage extends StatefulWidget {
  const UserDataPage({super.key, this.signupData});
  final SignupData? signupData;
  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  var controller = Get.put(AuthCustomController());

  TextEditingController name = TextEditingController(text: "");
  TextEditingController userName = TextEditingController(text: "");
  // TextEditingController phoneNum = TextEditingController(text: "");
  XFile? imageN;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "User Information",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      //controller.updateProfilePic(image);
                      imageN = image;
                      setState(() {});
                    }
                  },
                  child: imageN != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.file(
                            File(imageN!.path),
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                        )
                      : const CircleAvatar(radius: 52, child: SizedBox()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.deepPurple)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: userName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.deepPurple)),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // TextField(
                //   controller: phoneNum,
                //   decoration: const InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Phone Number',
                //       labelStyle: TextStyle(color: Colors.deepPurple)),
                // ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                    color: Colors.deepPurple,
                    onPressed: () async {
                      if (name.text == "" || userName.text == "") {
                        Fluttertoast.showToast(
                            msg: "Please fill all the details",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      Get.defaultDialog(
                          barrierDismissible: false,
                          title: "Checking username available.",
                          content: const CircularProgressIndicator());

                      if (!(await controller
                          .getUserNameAvailable("@${userName.text.toLowerCase()}"))) {
                        Fluttertoast.showToast(
                            msg: "Please change the username",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Get.back();
                        return;
                      }

                      Get.back();

                      Get.defaultDialog(
                          title: "Creating account.",
                          barrierDismissible: false,
                          content: const CircularProgressIndicator());
                      await controller.createUserSignUp(
                          UserModelCustom(
                            fullName: name.text,
                            userName: "@${userName.text.toLowerCase()}",
                            phone: "",
                          ),
                          imageN);
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
