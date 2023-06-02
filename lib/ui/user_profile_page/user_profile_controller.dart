import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:scopr/model/follow_model.dart';

import '../../model/notification_mode.dart';
import '../../model/post_details.dart';
import '../../model/user_model.dart';
import '../home_page/home_controller.dart';
import '../notification_page/notification_page_controller.dart';

class UserProfileController extends GetxController {
  var userPostList = <PostDetails>[].obs;
  final userCustomModel = UserModelCustom().obs;
  var homeController = Get.put(HomeController());

  var photoUrl = "".obs;
  var notificationController = Get.put(NotificationPageController());

  var followCunt = 0.obs;
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

  Future<bool> getFollowed(String userId) async {
    List<String> st = [];

    try {
      await FirebaseFirestore.instance
          .collection("follow")
          .where("userId", isEqualTo: userId)
          .where("isActive", isEqualTo: "Active")
          .get()
          .then((querySnapshot) async {
        for (var dt in querySnapshot.docs) {
          FollowModel followModel = FollowModel.fromMap(dt.data());
          if (!(st.contains(followModel.myId))) {
            st.add(followModel.myId ?? "");
          }
        }
      });
    } catch (e) {
      log(e.toString());
    }
    followCunt(st.length);
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
        person = UserModelCustom.fromMap(userModel as Map<String, dynamic>)
            .copyWith(
                uId: querySnapshot.id,
                followedModel: await getFollowedModelId(querySnapshot.id));
      });
    } catch (e) {
      log(e.toString());
    }
    userCustomModel(person);
    update();
    return person;
  }

  Future<FollowModel?> getFollowedModelId(String userId) async {
    FollowModel followedModel = FollowModel(followId: "");

    try {
      var myId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("follow")
          .where("myId", isEqualTo: myId)
          .where("userId", isEqualTo: userId)
          .orderBy("updatedTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          if (doc.exists) {
            followedModel =
                FollowModel.fromMap(doc.data()).copyWith(followId: doc.id);
            break;
          }
        }
      });
    } catch (e) {}
    return followedModel;
  }

  Future<String?> getFollowedPost(String userId) async {
    var myId = FirebaseAuth.instance.currentUser!.uid;

    String? followId;
    await FirebaseFirestore.instance
        .collection("follow")
        .where("myId", isEqualTo: myId)
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.exists) followId = doc.id;
      }
    });

    return followId;
  }

  Future<UserModelCustom> follow(String uId) async {
    var myId = FirebaseAuth.instance.currentUser!.uid;
    try {
      var followCollection =
          await FirebaseFirestore.instance.collection("follow").add(
                FollowModel(
                  myId: myId,
                  userId: uId,
                  updatedTime: FieldValue.serverTimestamp(),
                  isActive: (userCustomModel.value.isPrivate ?? false)
                      ? FollowState.requesting
                      : FollowState.active,
                ).toMap(),
              );

      //  homeController.getPost();
      await getFollowed(userCustomModel.value.uId ?? "");
      await getPost(userCustomModel.value.uId ?? "");

      var notificationId = await notificationController.sendNotification(
        NotificationModelCustom(
            reciverId: uId,
            description: "Followed you.",
            objectId: followCollection.id,
            type: NotificationTypes.flwTxt),
      );

      await FirebaseFirestore.instance
          .collection("follow")
          .doc(followCollection.id)
          .set(
              {
            "notificationId": notificationId,
          },
              SetOptions(
                merge: true,
              ));
    } catch (e) {
      log(e.toString());
    }
    return userCustomModel.value;
  }

  Future<UserModelCustom> unfollow(FollowModel followModel) async {
    try {
      await FirebaseFirestore.instance
          .collection("follow")
          .doc(followModel.followId)
          .delete();

      await notificationController
          .deleteNotification(followModel.notificationId ?? "");

      // homeController.getPost();
      await getFollowed(userCustomModel.value.uId ?? "");
      await getPost(userCustomModel.value.uId ?? "");
    } catch (e) {
      log(e.toString());
    }
    return userCustomModel.value;
  }

  getPost(String uId) async {
    var postList = <PostDetails>[];
    try {
      await FirebaseFirestore.instance
          .collection("post")
          .where("uId", isEqualTo: uId)
          .where("isArchive", isEqualTo: false)
          .orderBy("cretateTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          postList.add(PostDetails.fromMap(doc.data())
              .copyWith(postId: doc.id, likeCount: await getLikedCnt(doc.id)));
        }
      });
    } catch (e) {
      log(e.toString());
    }
    userPostList(postList);
    update();
  }
}
