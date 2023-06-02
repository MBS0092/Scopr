import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_page_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  var userId = FirebaseAuth.instance.currentUser!.uid;

  var notificationController = Get.put(NotificationPageController());

  @override
  void initState() {
    super.initState();
    notificationController.getNotification();
  }

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
              "Notifications",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: notificationController.notifcationList.length,
                  itemBuilder: (context, index) {
                    var model = notificationController.notifcationList[index];
                    if (model.type == NotificationTypes.likeImg) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(color: Colors.white)),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.height * 0.9,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              model.person.profilePic != null ||
                                      model.person.profilePic != ""
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          model.person.profilePic ?? ""),
                                      radius: 30,
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.deepPurple,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      model.person.userName ?? "",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      model.description ?? " ",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(model.object.imgUrl ?? ""),
                                radius: 30,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (model.type == NotificationTypes.liketxt) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(color: Colors.white)),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.height * 0.9,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              model.person.profilePic != null ||
                                      model.person.profilePic != ""
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          model.person.profilePic ?? ""),
                                      radius: 30,
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.deepPurple,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      model.person.userName ?? "",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      model.description ?? " ",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      model.object.description ?? " ",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(color: Colors.white)),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.9,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            model.person.profilePic != null ||
                                    model.person.profilePic != ""
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        model.person.profilePic ?? ""),
                                    radius: 30,
                                  )
                                : const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.deepPurple,
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    model.person.userName ?? "",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  model.object.isActive ==
                                          FollowState.requesting
                                      ? const Text(
                                          "Requesting to Follow",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : model.object.isActive ==
                                              FollowState.reject
                                          ? const Text(
                                              "Denied follow Request.",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              model.description ?? " ",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (model.object.isActive == FollowState.requesting)
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Get.defaultDialog(
                                        title: "Rejectng",
                                        content:
                                            const CircularProgressIndicator(),
                                        barrierDismissible: true,
                                      );
                                      await notificationController.followHandel(
                                          model.objectId ?? "",
                                          FollowState.reject);
                                      await notificationController
                                          .getNotification();
                                      Get.back();
                                    },
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Get.defaultDialog(
                                        title: "Accepting",
                                        content:
                                            const CircularProgressIndicator(),
                                        barrierDismissible: true,
                                      );
                                      await notificationController.followHandel(
                                          model.objectId ?? "",
                                          FollowState.active);
                                      await notificationController
                                          .getNotification();
                                      Get.back();
                                    },
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.greenAccent,
                                      child: Icon(Icons.check),
                                    ),
                                  ),
                                ],
                              ),
                            if (model.object.isActive == FollowState.reject)
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close),
                              ),
                            if (model.object.isActive == FollowState.active)
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.greenAccent,
                                child: Icon(Icons.check),
                              )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      );
}
