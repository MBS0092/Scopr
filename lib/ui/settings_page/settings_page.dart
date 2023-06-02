import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../authentication_page/auth_controller.dart';
import '../authentication_page/auth_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var authController = Get.put(AuthCustomController());

  @override
  void initState() {
    super.initState();
    authController.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).hintColor, Theme.of(context).canvasColor],
        ),
      ),
      child: Scaffold(
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
            "Settings",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Obx(
          () => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(color: Colors.white)),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.9,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).hintColor,
                          radius: 30,
                          child: const Icon(
                            Icons.email_outlined,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.email ?? "",
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: updatePsswordDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(color: Colors.white)),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.9,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).hintColor,
                            radius: 30,
                            child: const Icon(
                              Icons.lock_reset_outlined,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Reset Password",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 80,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: deleteDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(color: Colors.white)),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.9,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).hintColor,
                            radius: 30,
                            child: const Icon(
                              Icons.delete_outline,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 80,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (!(authController.userCustomModel.value.isPrivate ??
                          false))
                      ? makePrivate
                      : makePublic,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(color: Colors.white)),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.9,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).hintColor,
                            radius: 30,
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Private Account",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 80,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  makePublic() {
    Get.defaultDialog(
      title: "Account Public",
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Make you Account Public",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                color: Colors.deepPurpleAccent,
                onPressed: () async {
                  try {
                    authController.setPrivate(false);
                    Get.back();
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: const Text("ok"))
          ],
        ),
      ),
    );
  }

  makePrivate() {
    Get.defaultDialog(
      title: "Account Private",
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Make you Account Private",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                color: Colors.deepPurpleAccent,
                onPressed: () async {
                  try {
                    authController.setPrivate(true);

                    Get.back();
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: const Text("ok"))
          ],
        ),
      ),
    );
  }

  deleteDialog() {
    TextEditingController currentPw = TextEditingController();

    Get.defaultDialog(
      title: "Delete Account",
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: currentPw,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Current Password',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                onPressed: () async {
                  try {
                    if (currentPw.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Fill all the details",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    AuthCredential credential = EmailAuthProvider.credential(
                        email: FirebaseAuth.instance.currentUser!.email ?? "",
                        password: currentPw.text);

                    await FirebaseAuth.instance.currentUser!
                        .reauthenticateWithCredential(credential);
                    await FirebaseAuth.instance.currentUser!.delete();
                    Get.offAll(() => const AuthenticationPage());
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: const Text("Delete"))
          ],
        ),
      ),
    );
  }

  updatePsswordDialog() {
    TextEditingController currentPw = TextEditingController();
    TextEditingController newPw = TextEditingController();

    Get.defaultDialog(
      title: "Update Pasword",
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: currentPw,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Current Password',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: newPw,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Password',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                onPressed: () async {
                  try {
                    if (currentPw.text == "" || newPw.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Fill all the details",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    AuthCredential credential = EmailAuthProvider.credential(
                        email: FirebaseAuth.instance.currentUser!.email ?? "",
                        password: currentPw.text);

                    await FirebaseAuth.instance.currentUser!
                        .reauthenticateWithCredential(credential);
                    FirebaseAuth.instance.currentUser!
                        .updatePassword(newPw.text);

                    Get.back();
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: const Text("Reset"))
          ],
        ),
      ),
    );
  }
}
