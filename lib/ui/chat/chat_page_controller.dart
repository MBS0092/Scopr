import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPageController extends GetxController {

  Future<types.User> getChatUser(String uId) async {
    types.User user = const types.User(id: "");
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uId)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.exists) {
          final data = querySnapshot.data()!;

          data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
          data['id'] = querySnapshot.id;
          data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
          data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
          user = types.User.fromJson(data);
          log(user.id);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return user;
  }
}
