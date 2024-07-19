import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:advancedturizmuyg/model/lokasyon.dart';
import 'package:advancedturizmuyg/model/services/apiConnection.dart';
import 'package:advancedturizmuyg/view/userview/comments.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:advancedturizmuyg/viewmodel/services/adminservice.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LokasyonDetayView extends StatefulWidget {
  const LokasyonDetayView({super.key});

  @override
  State<LokasyonDetayView> createState() => _LokasyonDetayViewState();
}

final LocationsService _locationServices = LocationsService();
final LokasyonController _controller = Get.put(LokasyonController());

class _LokasyonDetayViewState extends State<LokasyonDetayView> {
  final PageController _pageController = PageController();
  final UserController _userController = Get.put(UserController());
  final AdminAddDataBase _userService = AdminAddDataBase();
  late Lokasyon _lokasyon;
  Timer? _timer;
  RxBool isClicked = false.obs;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPages = _pageController.page!.toInt() + 1;
        if (nextPages >=
            (_lokasyon.images?.where((image) => image.isNotEmpty).length ??
                1)) {
          nextPages = 0;
        }
        if (_pageController.page!.toInt() < nextPages) {
          _pageController.animateToPage(
            nextPages,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          _pageController.animateToPage(
            nextPages,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      }
    });

    
    _isFavoriteCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _isFavoriteCheck() async {
    String lokasyonId = _controller.selectedId.value;
    RxString userId = _userController.kulId;

    bool isFavorite = await _userService.isFavorite(lokasyonId, userId);

    if (isFavorite) {
      isClicked.value = true;
    }
  }

  Future<void> _toggleFavorite() async {
    isClicked.value = !isClicked.value;
    String lokasyonId = _controller.selectedId.value;
    RxString userId = _userController.kulId;

    if (isClicked.value) {
      await _userService.addFavorite(lokasyonId, userId);
      _showSnackBar(context, "Bu Lokasyon Favorilerime Eklendi");
    } else {
      await _userService.removeFavorite(lokasyonId, userId);
      _showSnackBar(context, "Bu Lokasyon Favorilerimden Kaldırıldı");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LokasyonDataModel>(
        future: _locationServices.lokasyonapiCall(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Veri Yok"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Bir Hata Oluştu ${snapshot.hasError}"),
            );
          } else {
            log("${snapshot.data}");
            _lokasyon = snapshot.data!.items.firstWhere(
                (lokasyon) => lokasyon.id == _controller.selectedId.value);
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                centerTitle: true,
                title: Text(
                  _lokasyon.lokasyonAdi ?? "",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 250,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        children: _lokasyon.images?.map((image) {
                          return Image.memory(
                            base64Decode(image),
                            fit: BoxFit.cover,
                          );
                        }).toList() ??
                            [],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lokasyon.lokasyonAdi ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: _toggleFavorite,
                                icon: Obx(() => Icon(
                                      isClicked.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: Colors.red,
                                    )),
                              ),
                            ],
                          ),
                          GestureDetector(onTap:(){
                             _controller.updateSelectedId(_lokasyon.id ?? "");
                              Get.to(()=>const LokasyonComments());
                          },
                            child: Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    (_lokasyon.puan).toInt(),
                                    (index) =>  
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 30,
                                      ),
                                    
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5 - (_lokasyon.puan).toInt(),
                                    (index) => 
                                      const  Icon(
                                        Icons.star_border,
                                        color: Colors.yellow,
                                        size: 30,
                                      ),
                                    
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _lokasyon.puan.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 40,
                                color: Colors.lightBlue,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _lokasyon.lokasyonAdresi ?? "",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                           Container(
                            height: 1,
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _lokasyon.icerik ?? "",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
