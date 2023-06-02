import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scopr/model/like_model.dart';
import 'package:scopr/model/notification_mode.dart';
import 'package:scopr/model/post_details.dart';
import 'package:scopr/model/user_model.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../model/follow_model.dart';
import '../authentication_page/auth_controller.dart';
import '../notification_page/notification_page_controller.dart';

class HomeController extends GetxController {
  final imgFile = false.obs;
  final swipeItemsCountFollow = 0.obs;
  final swipeItemsCountDiscover = 0.obs;

  var followModelList = <FollowModel>[].obs;
  final swipeItemsDiscover = <SwipeItem>[
    SwipeItem(
      content: PostDetails(),
    )
  ].obs;
  final matchEngineDiscover = MatchEngine(swipeItems: <SwipeItem>[
    SwipeItem(
      content: PostDetails(
        userName: "",
      ),
    )
  ]).obs;

  final swipeItemsFollowing = <SwipeItem>[
    SwipeItem(
      content: PostDetails(),
    )
  ].obs;
  final matchEngineFollowing = MatchEngine(swipeItems: <SwipeItem>[
    SwipeItem(
      content: PostDetails(
        userName: "",
      ),
    )
  ]).obs;

  var authController = Get.put(AuthCustomController());
  var notificationController = Get.put(NotificationPageController());

  likePost(PostDetails postDetails) async {
    try {
      var myId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference referennce =
          FirebaseFirestore.instance.collection("Like");
      await referennce.add(
        LikeMode(
          myId: myId,
          postId: postDetails.postId ?? "",
          updatedTime: FieldValue.serverTimestamp(),
        ).toMap(),
      );
    } catch (e) {}

    // notificationController.sendNotification(
    //   NotificationModelCustom(
    //       reciverId: postDetails.uId,
    //       description: "Like your Post",
    //       objectId: postDetails.postId,
    //       object: postDetails.imgUrl ?? postDetails.description,
    //       type: postDetails.imgUrl != null ? "img" : "text"),
    // );
    if (postDetails.imgUrl == null) {
      notificationController.sendNotification(
        NotificationModelCustom(
          reciverId: postDetails.uId,
          description: "Like your Quote",
          objectId: postDetails.postId,
          type: NotificationTypes.liketxt,
        ),
      );
    } else {
      notificationController.sendNotification(
        NotificationModelCustom(
          reciverId: postDetails.uId,
          description: "Like your Post",
          objectId: postDetails.postId,
          type: NotificationTypes.likeImg,
        ),
      );
    }
  }

  Future<bool> getFollowed() async {
    var followListTemp = <FollowModel>[];
    try {
      var myId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("follow")
          .where("myId", isEqualTo: myId)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          followListTemp.add(FollowModel.fromMap(doc.data()));
        }
      });
    } catch (e) {
      log(e.toString());
    }
    followModelList(followListTemp);
    update();
    return true;
  }

  Future<int> getLikedCnt(String postId) async {
    int cnt = 0;
    try {
      await FirebaseFirestore.instance
          .collection("Like")
          .where("postId", isEqualTo: postId)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          cnt = querySnapshot.docs.length;
        }
      });
    } catch (e) {
      log(e.toString());
      return cnt;
    }
    return cnt;
  }

  Future<String> getLikeId(String postId) async {
    String likeId = "";
    try {
      var myId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("Like")
          .where("myId", isEqualTo: myId)
          .where("postId", isEqualTo: postId)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          likeId = doc.id;
          break;
        }
      });
    } catch (e) {
      log(e.toString());
    }
    update();
    return likeId;
  }

  Future<bool> getPost() async {
    List<SwipeItem> swipeItemsTempDiscover = <SwipeItem>[];
    List<SwipeItem> swipeItemsTempFollowing = <SwipeItem>[];

    try {
      var uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("post")
          .where("uId", isNotEqualTo: uid)
          .where("isArchive", isEqualTo: false)
          .orderBy("uId", descending: false)
          .orderBy("cretateTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          UserModelCustom userModelCustom = await getPerson(doc["uId"]);
          if (userModelCustom.uId == null) {
            continue;
          }

          var isFollow = getIsFollowed(doc["uId"]);

          var isFollowModel = getIsFollowedModel(doc["uId"]);

          String likeId = await getLikeId(doc.id);
          int likeIdCunt = await getLikedCnt(doc.id);
          var model = PostDetails.fromMap(doc.data()).copyWith(
            postId: doc.id,
            userName: userModelCustom.userName,
            isFollowed: isFollow,
            isLikeId: likeId,
            likeCount: likeIdCunt,
          );
          if (isFollow) {
            if (isFollowModel.isActive == FollowState.active) {
              swipeItemsTempFollowing.add(SwipeItem(
                content: model,
                likeAction: () {
                  likePost(model);
                  removeCountFollowing();
                },
                nopeAction: () {
                  removeCountFollowing();
                },
              ));
            }
          } else {
            if (!(userModelCustom.isPrivate ?? false)) {
              swipeItemsTempDiscover.add(
                SwipeItem(
                  content: model,
                  likeAction: () {
                    likePost(model);
                    removeCountDiscover();
                  },
                  nopeAction: () {
                    removeCountDiscover();
                  },
                ),
              );
            }
          }
        }
      });
    } catch (e) {
      log(e.toString());
    }

    List<SwipeItem> swipeItemsTempDiscoverN = <SwipeItem>[];
    List<SwipeItem> swipeItemsTempFollowingN = <SwipeItem>[];
    var discoverCnt = 0;
    var followCnt = 0;
    for (var element in swipeItemsTempFollowing) {
      PostDetails postDetails = element.content;

      if (postDetails.isLikeId == "") {
        swipeItemsTempFollowingN.add(element);
        followCnt++;
      }
    }
    for (var element in swipeItemsTempDiscover) {
      PostDetails postDetails = element.content;

      if (postDetails.isLikeId == "") {
        swipeItemsTempDiscoverN.add(element);
        discoverCnt++;
      }
    }

    swipeItemsCountFollow(followCnt);
    swipeItemsCountDiscover(discoverCnt);
    swipeItemsFollowing(swipeItemsTempFollowingN);
    matchEngineFollowing(MatchEngine(swipeItems: swipeItemsTempFollowingN));
    swipeItemsDiscover(swipeItemsTempDiscoverN);
    matchEngineDiscover(MatchEngine(swipeItems: swipeItemsTempDiscoverN));

    update();
    return true;
  }

  FollowModel getIsFollowedModel(String uId) {
    for (var i in followModelList) {
      if (i.userId == uId) {
        return i;
      }
    }
    return FollowModel();
  }

  bool getIsFollowed(String uId) {
    for (var i in followModelList) {
      if (i.userId == uId) {
        return true;
      }
    }
    return false;
  }

  Future<UserModelCustom> getPerson(String uId) async {
    UserModelCustom userModelCustom = UserModelCustom();
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(uId)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.exists) {
          var data = querySnapshot.data();

          userModelCustom = UserModelCustom.fromMap(data!);
        }
        // log(userModelCustom.isPrivate.toString());
        // log("get p");
      });
    } catch (e) {
      log(e.toString());
    }
    return userModelCustom;
  }

  createPost(PostDetails postDetails) async {
    String dateTime = DateTime.now().toIso8601String();
    try {
      if (postDetails.msgType != "text") {
        final storage = FirebaseStorage.instance
            .ref()
            .child('post/${postDetails.imgName}$dateTime');

        await storage.putFile(File(postDetails.imgPath ?? ""));
        CollectionReference referennce =
            FirebaseFirestore.instance.collection("post");
        var user = FirebaseAuth.instance.currentUser!;
        await referennce.add(
          postDetails
              .copyWith(
                uId: user.uid,
                userName: user.displayName,
                imgUrl: await storage.getDownloadURL(),
                cretateTime: FieldValue.serverTimestamp(),
                updatedTime: FieldValue.serverTimestamp(),
                imgPath: "",
                isArchive: false,
              )
              .toMap(),
        );
      } else {
        CollectionReference referennce =
            FirebaseFirestore.instance.collection("post");
        var user = FirebaseAuth.instance.currentUser!;
        await referennce.add(
          postDetails
              .copyWith(
                uId: user.uid,
                userName: user.displayName,
                cretateTime: FieldValue.serverTimestamp(),
                updatedTime: FieldValue.serverTimestamp(),
                imgPath: "",
                isArchive: false,
              )
              .toMap(),
        );
      }
      getPost();
      Fluttertoast.showToast(
          msg: "Posted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return true;
  }

  setImgFile(bool? file) {
    imgFile(file);
  }

  removeCountFollowing() {
    swipeItemsCountFollow(swipeItemsCountFollow.value - 1);
  }

  removeCountDiscover() {
    swipeItemsCountDiscover(swipeItemsCountDiscover.value - 1);
  }

  createChat(UserModelCustom userModelCustom) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        id: uid,
        imageUrl: userModelCustom.profilePic,
        firstName: userModelCustom.fullName,
      ),
    );
  }

  updateUserSignUp(UserModelCustom userModelCustom) async {
    var userDetails = FirebaseAuth.instance.currentUser!;
    CollectionReference user = FirebaseFirestore.instance.collection('user');
    userDetails.updateDisplayName(userModelCustom.fullName);
    try {
      user.doc(userDetails.uid).set(
            userModelCustom
                .copyWith(
                  uId: userDetails.uid,
                  updatedTime: FieldValue.serverTimestamp(),
                )
                .toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateUserDialog() {
    TextEditingController name = TextEditingController(
        text: authController.userCustomModel.value.fullName);
    TextEditingController userName = TextEditingController(
        text: authController.userCustomModel.value.userName!.split("@")[1]);

    Get.defaultDialog(
      title: "Update",
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: name,
              maxLength: 30,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: userName,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
              ],
              maxLength: 30,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
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

                  if (userName.text != "@${userName.text}") {
                    Get.defaultDialog(
                        barrierDismissible: false,
                        title: "Checking if username is available",
                        content: const CircularProgressIndicator());
                    if (!(await authController.getUserNameAvailable(
                        "@${userName.text.toLowerCase()}"))) {
                      Fluttertoast.showToast(
                          msg: "Username is not available",
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
                  }

                  updateUserSignUp(UserModelCustom(
                    fullName: name.text,
                    userName: "@${userName.text.toLowerCase()}",
                  ));
                  authController.getUserData();
                  Get.back();
                },
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}