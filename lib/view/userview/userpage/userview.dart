import 'package:advancedturizmuyg/view/userview/userpage/userdetay.dart';
import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPageView extends StatefulWidget {
  const UserPageView({super.key});

  @override
  State<UserPageView> createState() => _UserPageViewState();
}

class _UserPageViewState extends State<UserPageView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [        
            Container(
              height: 700,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: [
                  listTiles(
                      onTap: () {
                        Get.to(()=> const Favorite());
                      },
                      text: "MyFavorite".tr,
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 40,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  listTiles(
                      onTap: () {
                        Get.to(()=> const UserCommentView());
                      },
                      text: "MyComments".tr,
                      icon: const Icon(
                        Icons.comment,
                        color: Colors.white,
                        size: 40,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  listTiles(
                      onTap: () {},
                      text: "MyAccount".tr,
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      )),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(),
                        color: Colors.white),
                    child: ListTile(
                      title:  Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10),
                        child: Text("SignOut".tr,
                            style:const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.red)),
                      ),
                      onTap: () {
                        Get.offAllNamed('/login');
                      },
                      trailing: const Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                        size: 40,
                      ),
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
}
