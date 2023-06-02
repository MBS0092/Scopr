import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scopr/ui/chat/rooms.dart';
import 'package:scopr/ui/home_page/home_controller.dart';
import 'package:scopr/ui/home_page/post_create_page.dart';
import 'package:scopr/ui/user_profile_page/user_profile_page.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../model/post_details.dart';
import '../authentication_page/auth_controller.dart';
import 'drawer_custom.dart';
import 'options_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool followingFeedSelected = false;
  var controller = Get.put(HomeController());
  var authController = Get.put(AuthCustomController());

  @override
  void initState() {
    super.initState();
    fun();
  }

  fun() async {
    await controller.getFollowed();
    await authController.getUserData();
    await controller.getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
        key: _key,
        drawer: const DrawerCustom(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        setState(() {
                          followingFeedSelected = true;
                        });
                      },
                      child: Text(
                        'Following',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: followingFeedSelected
                                ? FontWeight.w800
                                : FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        setState(() {
                          followingFeedSelected = false;
                        });
                      },
                      child: Text(
                        'Discover',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: followingFeedSelected
                                ? FontWeight.normal
                                : FontWeight.w800,
                            fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Obx(
                      () => (controller.swipeItemsCountFollow.value != 0 &&
                                  followingFeedSelected) ||
                              (controller.swipeItemsCountDiscover.value != 0 &&
                                  !followingFeedSelected)
                          ? SwipeCards(
                              matchEngine: followingFeedSelected
                                  ? controller.matchEngineFollowing.value
                                  : controller.matchEngineDiscover.value,
                              itemBuilder: (BuildContext context, int index) {
                                PostDetails model = followingFeedSelected
                                    ? controller
                                        .swipeItemsFollowing[index].content
                                    : controller
                                        .swipeItemsDiscover[index].content;

                                return cardWidget(model);
                              },
                              onStackFinished: () {},
                              itemChanged: (SwipeItem item, int index) {},
                              upSwipeAllowed: false,
                              fillSpace: true,
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: buildButtons(),
                )
              ],
            ),
          ),
        ));
  }

  Widget cardWidget(PostDetails model) {
    if (model.msgType == "text") {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.47,
                      child: Center(
                        child: Text(
                          model.description ?? "No Description",
                          maxLines: 12,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        model.userName ?? "",
                        style: const TextStyle(
                          fontSize: 22,
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
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.6,
      child: GestureDetector(
        onTap: () {
          Get.to(UserProfilePage(
            id: model.uId ?? "",
          ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade200,
              image: DecorationImage(
                image: NetworkImage(model.imgUrl ??
                    "https://images.unsplash.com/photo-1548504769-900b70ed122e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80"),
                fit: BoxFit.cover,
                alignment: const Alignment(-0.3, 0),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1]),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      model.userName ?? "",
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
                    Text(
                      model.description ?? "No Description",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Obx(
      () => (controller.swipeItemsCountFollow.value == 0 &&
                  followingFeedSelected) ||
              (controller.swipeItemsCountDiscover.value == 0 &&
                  !followingFeedSelected)
          ? const SizedBox()
          //  ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //     ),
          //     child: const Text(
          //       'Restart',
          //       style: TextStyle(color: Colors.black),
          //     ),
          //     onPressed: () {
          //       controller.getPost();
          //     },
          //   )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor: getColor(
                        Colors.blueAccent, Colors.blueAccent.shade700, true),
                    side: getBorder(Colors.white, Colors.white, true),
                  ),
                  child: const Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                    size: 42,
                  ),
                  onPressed: () {
                    if (followingFeedSelected) {
                      controller.matchEngineFollowing.value.currentItem!.nope();
                    } else {
                      controller.matchEngineDiscover.value.currentItem!.nope();
                    }
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor:
                        getColor(Colors.orange, Colors.orange.shade800, true),
                    side: getBorder(Colors.white, Colors.white, true),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 46,
                  ),
                  onPressed: () {
                    if (followingFeedSelected) {
                      controller.matchEngineFollowing.value.currentItem!.like();
                    } else {
                      controller.matchEngineDiscover.value.currentItem!.like();
                    }
                  },
                ),
                OptionsButton()
              ],
            ),
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    getColor(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    getBorder(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return BorderSide(color: colorPressed, width: 4);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    return MaterialStateProperty.resolveWith(getBorder);
  }

  Widget buildHeader() => Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.person,
                      size: 32, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    fun();
                  },
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.add,
                      size: 30, color: Colors.transparent),
                ),
              ],
            ),
            GestureDetector(
                onTap: () {},
                child: Image.asset('assets/images/ScoprLogoTransparent.png',
                    scale: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    Get.to(() => const PostCreatePage());
                  },
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.add,
                      size: 30, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Get.to(() => const RoomsPage());
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ChatPage(),
                    //   ),
                    // );
                  },
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.chat_bubble,
                      size: 30, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  addPost() {
    TextEditingController description = TextEditingController(text: "");
    XFile? imageFile;

    Get.defaultDialog(
      title: "Post",
      content: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => controller.imgFile.value && imageFile != null
                  ? Image.file(
                      File(imageFile!.path),
                      height: 150,
                    )
                  : SizedBox(
                      height: 150,
                      child: IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          imageFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          controller.setImgFile(true);

                          setState(() {});
                        },
                      ),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 2,
              controller: description,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (imageFile != null) {
                      controller.createPost(
                        PostDetails(
                          description: description.text,
                          imgName: imageFile!.name,
                          imgPath: imageFile!.path,
                          msgType: "image",
                        ),
                      );
                    } else {
                      controller.createPost(
                        PostDetails(
                          description: description.text,
                          msgType: "test",
                        ),
                      );
                    }
                  } catch (e) {
                    log(e.toString());
                  } finally {
                    controller.setImgFile(false);

                    Get.back();
                  }
                },
                child: const Text("Post"))
          ],
        ),
      ),
    );
  }
}
