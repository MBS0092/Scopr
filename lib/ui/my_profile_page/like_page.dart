import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scopr/ui/my_profile_page/my_profile_controller.dart';

import '../../model/user_model.dart';
import '../user_profile_page/user_profile_page.dart';

class LikePage extends StatefulWidget {
  final String? postId;
  const LikePage({Key? key, this.postId}) : super(key: key);

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  late Stream<QuerySnapshot> _usersStream;

  var controller = Get.put(MyProfilePageController());

  @override
  void initState() {
    super.initState();

    controller.getLikedList(widget.postId ?? "");
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).hintColor,
              Theme.of(context).canvasColor
            ],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              highlightColor: Colors.transparent,
              icon:
                  Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              "Liked Peoples",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Obx(
            () => Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    UserModelCustom model = controller.userList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(UserProfilePage(
                          id: model.uId ?? "",
                        ));
                      },
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
                                backgroundColor: model.profilePic != "" &&
                                        model.profilePic != null
                                    ? Colors.transparent
                                    : Colors.white,
                                backgroundImage: model.profilePic != "" &&
                                        model.profilePic != null
                                    ? NetworkImage(model.profilePic ?? "")
                                    : null,
                                radius: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                model.fullName ?? "",
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.userList.length,
                )),
          ),
        ),
      );
}
