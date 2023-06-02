import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scopr/ui/peoples_screen/peroples_screen_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../user_profile_page/user_profile_page.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  var controller = Get.put(PeoplesScreenController());
  int selectedCategory = 0;
  @override
  void initState() {
    super.initState();
    controller.getAllPeoplesDetails();
    controller.getFollowingList();
    controller.getFollowersList();
  }

  ScrollController scrollController = ScrollController();
  var searchValue = "";
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: EasySearchBar(
            iconTheme: const IconThemeData(color: Colors.white),
            searchCursorColor: Colors.white,
            searchBackIconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              'People',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            onSearch: (value) => setState(() => searchValue = value)),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                ToggleSwitch(
                  minWidth: 100,
                  initialLabelIndex: controller.selectedCategory.value,
                  totalSwitches: 3,
                  labels: const ['Following', 'Followers', "Find"],
                  onToggle: (index) {
                    controller.updateSelectedCategory(index ?? 0);

                    setState(() {});
                  },
                ),
                controller.selectedCategory.value != 2
                    ? ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: controller.selectedCategory.value == 0
                            ? controller.peoplesFollowing.length
                            : controller.peoplesFollowers.length,
                        itemBuilder: (context, index) {
                          var model = controller.selectedCategory.value == 0
                              ? controller.peoplesFollowing[index]
                              : controller.peoplesFollowers[index];

                          if (!(model.fullName!.contains(searchValue)) &&
                              searchValue != "") {
                            return const SizedBox();
                          }
                          return GestureDetector(
                            onTap: () {
                              Get.to(UserProfilePage(
                                id: model.uId ?? "",
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(color: Colors.white)),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.height * 0.9,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: model.profilePic != "" &&
                                              model.profilePic != null
                                          ? Colors.transparent
                                          : Colors.white,
                                      backgroundImage: model.profilePic != "" &&
                                              model.profilePic != null
                                          ? NetworkImage(model.profilePic ?? "")
                                          : null,
                                      radius: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      model.fullName ?? "",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: controller.peoplesAll.length,
                        itemBuilder: (context, index) {
                          var model = controller.peoplesAll[index];

                          if (!(model.fullName!.contains(searchValue)) &&
                              searchValue != "") {
                            return const SizedBox();
                          }
                          return GestureDetector(
                            onTap: () {
                              Get.to(UserProfilePage(
                                id: model.uId ?? "",
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(color: Colors.white)),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.height * 0.9,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: model.profilePic != "" &&
                                              model.profilePic != null
                                          ? Colors.transparent
                                          : Colors.white,
                                      backgroundImage: model.profilePic != "" &&
                                              model.profilePic != null
                                          ? NetworkImage(model.profilePic ?? "")
                                          : null,
                                      radius: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.fullName ?? "",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          model.isPrivate ?? true
                                              ? "Private"
                                              : "Public",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      );
}
