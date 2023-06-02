// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:scopr/model/post_details.dart';
import 'package:scopr/ui/chat/chat_page_controller.dart';
import 'package:scopr/ui/home_page/home_controller.dart';
import 'package:scopr/ui/notification_page/notification_page_controller.dart';
import 'package:scopr/ui/user_profile_page/user_profile_controller.dart';

import '../chat/chat.dart';

class UserProfilePage extends StatefulWidget {
  final String id;

  const UserProfilePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var controller = Get.put(UserProfileController());
  var chatController = Get.put(ChatPageController());
  var homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    controller.getPerson(widget.id);
    controller.getPost(widget.id);
    controller.getFollowed(widget.id);
  }

  ScrollController scrollController = ScrollController();
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
              "Profile",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Obx(
              () => SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.6,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      controller.userCustomModel.value.profilePic != "" &&
                              controller.userCustomModel.value.profilePic !=
                                  null
                          ? CircleAvatar(
                              radius: 52,
                              backgroundImage: NetworkImage(
                                controller.userCustomModel.value.profilePic ??
                                    "",
                              ),
                            )
                          : const CircleAvatar(radius: 52, child: SizedBox()),
                      const SizedBox(height: 12),
                      Text(
                        controller.userCustomModel.value.fullName ??
                            "Enter Name",
                        style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.userCustomModel.value.userName ??
                            "Enter user Name",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "Follows ${controller.followCunt.value.toString()}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      controller.userCustomModel.value.followedModel != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (controller.userCustomModel.value
                                            .followedModel.followId ==
                                        "" ||
                                    controller.userCustomModel.value
                                            .followedModel.isActive ==
                                        FollowState.reject)
                                  MaterialButton(
                                    onPressed: () async {
                                      Get.defaultDialog(
                                        title: "Follow",
                                        content:
                                            const CircularProgressIndicator(),
                                        barrierDismissible: false,
                                      );
                                      await controller.follow(widget.id);

                                      await controller.getPerson(controller
                                              .userCustomModel.value.uId ??
                                          "");
                                      await homeController.getFollowed();

                                      await homeController.getPost();
                                      Get.back();
                                    },
                                    color: Colors.deepPurple.shade100,
                                    child: const Text(
                                      "Follow",
                                      style: TextStyle(color: Colors.indigo),
                                    ),
                                  ),
                                if (controller.userCustomModel.value
                                        .followedModel.isActive ==
                                    FollowState.requesting)
                                  MaterialButton(
                                    onPressed: () async {
                                      Get.defaultDialog(
                                        title: "Requesting",
                                        content:
                                            const CircularProgressIndicator(),
                                        barrierDismissible: false,
                                      );
                                      await controller.unfollow(controller
                                          .userCustomModel.value.followedModel);

                                      await controller.getPerson(controller
                                              .userCustomModel.value.uId ??
                                          "");
                                      await homeController.getFollowed();
                                      await homeController.getPost();
                                      Get.back();
                                    },
                                    color: Colors.deepPurple.shade100,
                                    child: const Text(
                                      "Requesting",
                                      style: TextStyle(color: Colors.indigo),
                                    ),
                                  ),
                                if (controller.userCustomModel.value
                                        .followedModel.isActive ==
                                    FollowState.active)
                                  MaterialButton(
                                    onPressed: () async {
                                      Get.defaultDialog(
                                        title: "Unfollow",
                                        content:
                                            const CircularProgressIndicator(),
                                         barrierDismissible: false,
                                      );
                                      await controller.unfollow(controller
                                          .userCustomModel.value.followedModel);

                                      await controller.getPerson(controller
                                              .userCustomModel.value.uId ??
                                          "");
                                      await homeController.getFollowed();
                                      await homeController.getPost();
                                      Get.back();
                                    },
                                    color: Colors.deepPurple.shade100,
                                    child: const Text(
                                      "Unfollow",
                                      style: TextStyle(color: Colors.indigo),
                                    ),
                                  ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    Get.defaultDialog(
                                        title: "Loding",
                                        content:
                                            const CircularProgressIndicator());
                                    types.User otherUser = await chatController
                                        .getChatUser(widget.id);

                                    final room = await FirebaseChatCore.instance
                                        .createRoom(otherUser);

                                    Get.off(ChatPage(
                                      room: room,
                                      nameN: controller
                                          .userCustomModel.value.fullName,
                                    ));
                                  },
                                  color: Colors.deepPurple.shade100,
                                  child: const Text(
                                    "chat",
                                    style: TextStyle(color: Colors.indigo),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 12),
                      if (controller.userCustomModel.value.followedModel !=
                              null &&
                          ((controller.userCustomModel.value.followedModel
                                          .isActive ==
                                      FollowState.active &&
                                  controller
                                      .userCustomModel.value.isPrivate!) ||
                              !(controller.userCustomModel.value.isPrivate!)))
                        ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            PostDetails model = controller.userPostList[index];
                            if (model.msgType == "text") {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(UserProfilePage(
                                        id: model.uId ?? "",
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.45,
                                                child: Center(
                                                  child: Text(
                                                    model.description ??
                                                        "No Description",
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  model.userName ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "Likes ${model.likeCount}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: MediaQuery.of(context).size.width * 0.1,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.deepPurple.shade200,
                                  image: DecorationImage(
                                    image: NetworkImage(model.imgUrl ??
                                        "https://img.artpal.com/19841/5-19-5-17-15-41-24m.jpg"),
                                    fit: BoxFit.cover,
                                    alignment: const Alignment(-0.3, 0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    Text(
                                      model.description ?? "No Description",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Likes ${model.likeCount}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          itemCount: controller.userPostList.length,
                        ),
                      if (controller.userCustomModel.value.followedModel !=
                              null &&
                          controller.userCustomModel.value.followedModel
                                  .isActive !=
                              FollowState.active &&
                          controller.userCustomModel.value.isPrivate!)
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Posts are hidden due to the user's privacy settings.",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
