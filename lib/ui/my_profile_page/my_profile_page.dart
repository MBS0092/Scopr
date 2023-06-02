import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scopr/model/post_details.dart';
import 'package:scopr/ui/my_profile_page/like_page.dart';
import 'package:scopr/ui/my_profile_page/my_profile_controller.dart';

import '../authentication_page/auth_controller.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  var authController = Get.put(AuthCustomController());
  var controller = Get.put(MyProfilePageController());
  @override
  void initState() {
    super.initState();
    controller.getPost();
    controller.getFollowed();
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
              "My Profile",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Obx(
            () => SingleChildScrollView(
              controller: scrollController,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        var image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          authController.updateProfilePic(image);
                        }
                      },
                      child: authController.photoUrl.value != ""
                          ? CircleAvatar(
                              radius: 52,
                              backgroundImage: NetworkImage(
                                authController.photoUrl.value,
                              ),
                            )
                          : const CircleAvatar(radius: 52, child: SizedBox()),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      authController.userCustomModel.value.fullName ??
                          "Enter Name",
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      authController.userCustomModel.value.userName ??
                          "Enter user Name",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "Follows ${controller.followCunt.value.toString()}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        PostDetails model = controller.myPostList[index];
                        if (model.msgType == "text") {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 0.1,
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
                                        Stack(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              child: Center(
                                                child: Text(
                                                  model.description ??
                                                      "No Description",
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                     Get.defaultDialog(
                                                  title: "Please Wait..",
                                                  content:
                                                      const CircularProgressIndicator());
                                                    await controller.setArchive(
                                                        model.postId ?? "",
                                                        true);
                                                    Get.back();
                                                  },
                                                  icon:
                                                      const Icon(Icons.archive),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                  title: "Please Wait..",
                                                  content:
                                                      const CircularProgressIndicator());
                                                      controller.delete(
                                                          model.postId ?? "");
                                                      Get.back();
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete)),
                                              ],
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(LikePage(
                                              postId: model.postId,
                                            ));
                                          },
                                          child: Align(
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Spacer(),
                                          Text(
                                            model.description ??
                                                "No Description",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                         GestureDetector(
                                          onTap: () {
                                            Get.to(LikePage(
                                              postId: model.postId,
                                            ));
                                          },
                                            child: Align(
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
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                             Get.defaultDialog(
                                                  title: "Please Wait..",
                                                  content:
                                                      const CircularProgressIndicator());
                                            await controller.setArchive(
                                                model.postId ?? "", true);
                                            Get.back();
                                          },
                                          icon: const Icon(Icons.archive),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                                Get.defaultDialog(
                                                  title: "Please Wait..",
                                                  content:
                                                      const CircularProgressIndicator());
                                              await controller
                                                  .delete(model.postId ?? "");
                                              Get.back();
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      itemCount: controller.myPostList.length,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}