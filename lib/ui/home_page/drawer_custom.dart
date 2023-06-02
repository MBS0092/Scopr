import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scopr/ui/home_page/home_controller.dart';
import 'package:scopr/ui/my_profile_page/my_profile_page.dart';

import '../authentication_page/auth_controller.dart';
import '../authentication_page/auth_screen.dart';
import '../archive_page/archive_page.dart';
import '../notification_page/notifications_page.dart';
import '../peoples_screen/people_screen.dart';
import '../settings_page/settings_page.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  var controller = Get.put(HomeController());
  var authController = Get.put(AuthCustomController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.getProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).hintColor,
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                elevation: 4,
                color: const Color.fromRGBO(255, 147, 2, 1),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ProfilePage(),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 24 + MediaQuery.of(context).padding.top,
                      bottom: 24,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            var image = await picker.pickImage(
                                source: ImageSource.gallery);
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
                              : const CircleAvatar(
                                  radius: 52, child: SizedBox()),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            controller.updateUserDialog();
                          },
                          child: Text(
                            authController.userCustomModel.value.fullName ??
                                "Name",
                            style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.updateUserDialog();
                          },
                          child: Text(
                            authController.userCustomModel.value.userName ??
                                "User Name",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline, size: 30),
                      title: const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyProfilePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.people_alt_outlined, size: 30),
                      title: const Text(
                        'People',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PeopleScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.notifications_outlined, size: 30),
                      title: const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time_outlined, size: 30),
                      title: const Text(
                        'Archive',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ArchivePage(),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.black),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, size: 30),
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, size: 30),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                        } catch (e) {
                          log(e.toString());
                        } finally {
                          Get.offAll(() => const AuthenticationPage());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
