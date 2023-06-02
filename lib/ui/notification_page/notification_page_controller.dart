import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:scopr/model/follow_model.dart';
import 'package:scopr/model/notification_mode.dart';
import 'package:scopr/model/post_details.dart';

import '../../model/user_model.dart';

class NotificationTypes {
  static String liketxt = "like_txt";
  static String likeImg = "like_img";
  static String flwTxt = "flw_txt";
}

class NotificationPageController extends GetxController {
  var notifcationList = <NotificationModelCustom>[].obs;

  Future<bool> followHandel(String followId, String state) async {
    try {
      await FirebaseFirestore.instance.collection("follow").doc(followId).set(
          {
            "isActive": state,
          },
          SetOptions(
            merge: true,
          ));
    } catch (e) {
      log(e.toString());
    }
    update();
    return true;
  }

  Future<PostDetails> getPostId(String postId) async {
    PostDetails postmodelTemp = PostDetails();
    try {
      await FirebaseFirestore.instance
          .collection("post")
          .doc(postId)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.exists) {
          var data = querySnapshot.data();

          postmodelTemp = PostDetails.fromMap(data!);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return postmodelTemp;
  }

  Future<bool> getNotification() async {
    var notifcationListTemp = <NotificationModelCustom>[];
    try {
      var myId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("Notification")
          .where("reciverId", isEqualTo: myId)
          .orderBy("updatedTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var element in querySnapshot.docs) {
          NotificationModelCustom notificationModelCustom =
              NotificationModelCustom.fromMap(element.data());
          dynamic object;
          UserModelCustom? userModelCustom;

          if (notificationModelCustom.type == NotificationTypes.flwTxt) {

            
            object = await getFollowed(notificationModelCustom.objectId ?? "");
            userModelCustom =
                await getPerson(notificationModelCustom.senderId ?? "");
          }
          if (notificationModelCustom.type == NotificationTypes.likeImg) {
            object = await getPostId(notificationModelCustom.objectId ?? "");
            userModelCustom =
                await getPerson(notificationModelCustom.senderId ?? "");
          }
          if (notificationModelCustom.type == NotificationTypes.liketxt) {
            object = await getPostId(notificationModelCustom.objectId ?? "");
            userModelCustom =
                await getPerson(notificationModelCustom.senderId ?? "");
          }

          notifcationListTemp.add(notificationModelCustom.copyWith(
            object: object,
            person: userModelCustom,
          ));
        }
      });
    } catch (e) {
      log(e.toString());
    }
    notifcationList(notifcationListTemp);
    update();
    return true;
  }

  Future<FollowModel> getFollowed(String followId) async {
    var followModel = FollowModel();

    try {
      await FirebaseFirestore.instance
          .collection("follow")
          .doc(followId)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.exists) {
          var data = querySnapshot.data();
          followModel = FollowModel.fromMap(data!);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    update();
    return followModel;
  }

  Future<UserModelCustom> getPerson(String uId) async {
    UserModelCustom userModelCustomTemp = UserModelCustom();
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(uId)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.exists) {
          var data = querySnapshot.data();

          userModelCustomTemp = UserModelCustom.fromMap(data!);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return userModelCustomTemp;
  }

  Future<String> sendNotification(
      NotificationModelCustom notificationModelCustom) async {
    var myId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference referennce =
        FirebaseFirestore.instance.collection("Notification");
    var id = await referennce.add(
      notificationModelCustom
          .copyWith(
              senderId: myId,
              senderName: FirebaseAuth.instance.currentUser!.displayName,
              updatedTime: FieldValue.serverTimestamp())
          .toMap(),
    );

    return id.id;
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      FirebaseAuth.instance.currentUser!.uid;
      CollectionReference referennce =
          FirebaseFirestore.instance.collection("Notification");
      await referennce.doc(notificationId).delete();
    } catch (e) {}

    return true;
  }
}

class FollowState {
  static String active = "Active";
  static String reject = "Reject";
  static String requesting = "Requesting";
  static String rejected = "Rejected";
}
