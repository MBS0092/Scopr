import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scopr/model/user_model.dart';
import 'package:scopr/ui/home_page/home_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'auth_screen.dart';

class AuthCustomController extends GetxController {
  final userCustomModel = UserModelCustom().obs;

  var photoUrl = "".obs;

  Future<bool> getUserNameAvailable(String userName) async {
    bool isAvailable = true;
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .where("userName", isEqualTo: userName)
          .get()
          .then((querySnapshot) async {
        for (var element in querySnapshot.docs) {
          if (element.exists) {
            isAvailable = false;
            break;
          }
        }
      });
    } catch (e) {
      log(e.toString());
    }

    update();
    return isAvailable;
  }

  setPrivate(bool isPrivate) async {
    try {
      var myId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference user = FirebaseFirestore.instance.collection('user');

      await user.doc(myId).set(
        {
          "isPrivate": isPrivate,
          "updatedTime": FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      userCustomModel(userCustomModel.value.copyWith(isPrivate: isPrivate));
      getUserData();
    } catch (e) {
      log(e.toString());
    }

    update();
  }

  Future<String?> signUpUser(SignupData? signupData) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signupData!.name ?? "",
        password: signupData.password ?? "",
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
    return "done";
  }

  Future<String?> userSignIn(LoginData signIn) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signIn.name, password: signIn.password);
      var userDetails = FirebaseAuth.instance.currentUser!;

      if (userDetails.emailVerified) {
        Get.off(() => const HomePage());
      } else {
        userDetails.sendEmailVerification();
        FirebaseAuth.instance.signOut();
        Get.offAll(() => const AuthenticationPage());

        Fluttertoast.showToast(
            msg: "Confirm your email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
    return "done";
  }

  updateChatPic() async {
    var userDetails = FirebaseAuth.instance.currentUser!;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference user = FirebaseFirestore.instance.collection('user');

    try {
      await user.doc(userDetails.uid).set(
        {
          "profilePic": userCustomModel.value.profilePic,
        },
        SetOptions(merge: true),
      );
      await users.doc(userDetails.uid).set(
            types.User(
              id: userDetails.uid,
              imageUrl: userCustomModel.value.profilePic,
              firstName: userCustomModel.value.fullName,
            ).toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateProfilePic(XFile? xfile) async {
    String dateTime = DateTime.now().toIso8601String();
    try {
      final storage = FirebaseStorage.instance
          .ref()
          .child('profile/${xfile!.name}$dateTime');

      await storage.putFile(File(xfile.path));
      var url = await storage.getDownloadURL();
      FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
      userCustomModel(userCustomModel.value.copyWith(profilePic: url));
      photoUrl(url);
      updateChatPic();
    } catch (e) {
      log("pic$e");
    }
    update();
  }

  updateUserData() async {
    var userDetails = FirebaseAuth.instance.currentUser!;
    CollectionReference user = FirebaseFirestore.instance.collection('user');
    userDetails.updateDisplayName(userCustomModel.value.fullName);

    try {
      await user.doc(userDetails.uid).set(
            userCustomModel.value
                .copyWith(
                  updatedTime: FieldValue.serverTimestamp(),
                )
                .toMap(),
            SetOptions(merge: true),
          );
      updateChatPic();
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getUserData() async {
    try {
      var uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.exists) {
          userCustomModel(UserModelCustom.fromMap(querySnapshot.data()!));
        }
      });
      getProfilePic();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  getProfilePic() async {
    try {
      photoUrl(FirebaseAuth.instance.currentUser!.photoURL);
    } catch (e) {
      log("pic$e");
    }
    update();
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

  Future<bool> createUserSignUp(
    UserModelCustom userModelCustom,
    XFile? img,
  ) async {
    var userDetails = FirebaseAuth.instance.currentUser!;
    CollectionReference user = FirebaseFirestore.instance.collection('user');
    await userDetails.updateDisplayName(userModelCustom.fullName);

    try {
      await user.doc(userDetails.uid).set(
            userModelCustom
                .copyWith(
                  uId: userDetails.uid,
                  isPrivate: false,
                  cretateTime: FieldValue.serverTimestamp(),
                  updatedTime: FieldValue.serverTimestamp(),
                )
                .toMap(),
            SetOptions(merge: true),
          );
      userDetails.sendEmailVerification();
      await createChat(userModelCustom);
      if (img != null) {
        await updateProfilePic(img);
      }
      Get.off(() => const AuthenticationPage());
      Fluttertoast.showToast(
          msg: "Confirm your email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
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
}
