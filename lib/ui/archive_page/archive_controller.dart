import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:scopr/model/follow_model.dart';
import 'package:scopr/model/like_model.dart';
import 'package:scopr/model/user_model.dart';

import '../../model/post_details.dart';
import '../authentication_page/auth_controller.dart';

class ArchivePageController extends GetxController {
  var myPostList = <PostDetails>[].obs;
  var authCustomController = Get.put(AuthCustomController());
  var followCunt = 0.obs;
  var folowModel = <FollowModel>[].obs;
  var userList = <UserModelCustom>[].obs;

  setArchive(String postId, bool isArchive) async {
    CollectionReference user = FirebaseFirestore.instance.collection('post');

    await user.doc(postId).set(
      {
        "isArchive": isArchive,
        "updatedTime": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    getPost();
    update();
  }

  Future<bool> getLikedList(String postId) async {
    var userModelCustomTemp = <UserModelCustom>[].obs;

    try {
      await FirebaseFirestore.instance
          .collection("Like")
          .where("postId", isEqualTo: postId)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          var likeMode = LikeMode.fromMap(doc.data());
          userModelCustomTemp.add(await getPerson(likeMode.myId ?? ""));
        }
      });
    } catch (e) {
      log(e.toString());
    }
    userList(userModelCustomTemp);
    update();
    return true;
  }

  Future<UserModelCustom> getPerson(String id) async {
    UserModelCustom person = UserModelCustom();
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .get()
          .then((querySnapshot) async {
        var userModel = querySnapshot.data();
        person =
            UserModelCustom.fromMap(userModel as Map<String, dynamic>).copyWith(
          uId: querySnapshot.id,
        );
      });
    } catch (e) {
      log(e.toString());
    }
    //userCustomModel(person);
    update();
    return person;
  }

  delete(String postId) async {
    await FirebaseFirestore.instance.collection("post").doc(postId).delete();
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

  Future<bool> getFollowed() async {
    var myId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection("follow")
          .where("userId", isEqualTo: myId)
          .get()
          .then((querySnapshot) async {
        followCunt(querySnapshot.docs.length);
      });
    } catch (e) {
      log(e.toString());
    }
    update();
    return true;
  }

  getPost() async {
    var postList = <PostDetails>[];
    var uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance
          .collection("post")
          .where("uId", isEqualTo: uid)
          .where("isArchive", isEqualTo: true)
          .orderBy("cretateTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          postList.add(
            PostDetails.fromMap(doc.data()).copyWith(
              uId: uid,
              postId: doc.id,
              likeCount: await getLikedCnt(doc.id),
            ),
          );
        }
      });
    } catch (e) {
      log(e.toString());
    }
    myPostList(postList);

    update();
  }
}
