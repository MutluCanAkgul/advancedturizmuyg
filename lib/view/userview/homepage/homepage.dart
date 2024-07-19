import 'dart:convert';
import 'dart:developer';
import 'package:advancedturizmuyg/view/userview/lokasyondetay.dart';
import 'package:advancedturizmuyg/view/userview/searchpage/searchpage.dart';
import 'package:advancedturizmuyg/view/userview/userpage/userview.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:advancedturizmuyg/model/lokasyon.dart';
import 'package:advancedturizmuyg/model/services/apiConnection.dart';
import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'lokasyon_list_view.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _controller = Get.put(UserController());

  final LocationsService _locationsService = LocationsService();
  
  final RxInt _page = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() => IndexedStack(
            index: _page.value,
            children: [homeBody(), const SearchPageView(), const UserPageView()],
          )),
      bottomNavigationBar: BottomAppBars(
        index: _page,
      ),
    );
  }

  Widget homeBody() {
    return FutureBuilder<LokasyonDataModel>(
      future: _locationsService.lokasyonapiCall(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
          return const Center(child: Text('Veri bulunamadı'));
        } else {
          log("${snapshot.data}");
          return ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            "welcome".tr + " ${_controller.userName.value}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Column(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('discover'.tr ,style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),maxLines: 3,)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    LokasyonListView(lokasyonData: snapshot.data!),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class LokasyonItem extends StatelessWidget {
  final Lokasyon lokasyon;
  final _lcontroller = Get.put(LokasyonController());
  LokasyonItem({super.key, required this.lokasyon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        _lcontroller.updateSelectedId(lokasyon.id ?? "");
        Get.to(()=>const LokasyonDetayView());
      },
      child: Container(
        width: 300,
        height: 175,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Visibility(
                visible: lokasyon.images != null && lokasyon.images?.first != "",
                child: Image.memory(
                  base64Decode(lokasyon.images?[0] ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.black54,),
                padding: const EdgeInsets.all(8),
                
                child: Text(
                  lokasyon.lokasyonAdi ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial'),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Row(
                children: [
                  Text(
                    lokasyon.puan?.toString() ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial'),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
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
