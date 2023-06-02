import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:scopr/model/user_model.dart';

class PeoplesScreenController extends GetxController {
  var peoplesFollowing = <UserModelCustom>[].obs;
  var peoplesFollowers = <UserModelCustom>[].obs;
  var peoplesAll = <UserModelCustom>[].obs;
  var selectedCategory = 0.obs;

  updateSelectedCategory(int num) {
    selectedCategory(num);
  }

  Future<UserModelCustom> getAllPeoplesDetails() async {
    UserModelCustom person = UserModelCustom();
    var peoplesListTemp = <UserModelCustom>[];
    var myId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection("user")
          .where("uId", isNotEqualTo: myId)
          .get()
          .then((querySnapshot) async {
        for (var data in querySnapshot.docs) {
          peoplesListTemp.add(UserModelCustom.fromMap(
            data.data(),
          ).copyWith(
            uId: data.id,
          ));

          update();
        }
      });
    } catch (e) {
      log(e.toString());
    }

    peoplesAll(peoplesListTemp);
    update();
    return person;
  }

  getFollowersList() async {
    var myId = FirebaseAuth.instance.currentUser!.uid;
    var peoplesListTemp = <UserModelCustom>[];
    try {
      await FirebaseFirestore.instance
          .collection("follow")
          .where("userId", isEqualTo: myId)
          .where("isActive", isEqualTo: "Active")
          .orderBy("updatedTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          UserModelCustom userModelCustomTemp =
              await getPeoplesDetails(doc["myId"]);
          peoplesListTemp.add(userModelCustomTemp.copyWith(followId: doc.id));
        }
      });
    } catch (e) {
      log(e.toString());
    }
    peoplesFollowers(peoplesListTemp);
    update();
  }

  getFollowingList() async {
    var myId = FirebaseAuth.instance.currentUser!.uid;
    var peoplesListTemp = <UserModelCustom>[];
    try {
      await FirebaseFirestore.instance
          .collection("follow")
          .where("myId", isEqualTo: myId)
          .where("isActive", isEqualTo: "Active")
          .orderBy("updatedTime", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          UserModelCustom userModelCustomTemp =
              await getPeoplesDetails(doc["userId"]);
          peoplesListTemp.add(userModelCustomTemp.copyWith(followId: doc.id));
        }
      });
    } catch (e) {
      log(e.toString());
    }
    peoplesFollowing(peoplesListTemp);
    update();
  }

  Future<UserModelCustom> getPeoplesDetails(String id) async {
    UserModelCustom person = UserModelCustom();
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .get()
          .then((querySnapshot) async {
        var userModel = querySnapshot.data();
        person = UserModelCustom.fromMap(userModel ?? {})
            .copyWith(uId: userModel!["uId"]);
      });
    } catch (e) {
      log(e.toString());
    }
    update();
    return person;
  }
}
