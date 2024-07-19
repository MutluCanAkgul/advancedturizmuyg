
import 'package:advancedturizmuyg/model/translations.dart';
import 'package:advancedturizmuyg/view/adminview/adminLokasyonPageView/lokasyonaddpageview.dart';
import 'package:advancedturizmuyg/view/adminview/adminpage.dart';
import 'package:advancedturizmuyg/view/adminview/adminsehirpageview/sehiradd.dart';
import 'package:advancedturizmuyg/view/adminview/loginview.dart';
import 'package:advancedturizmuyg/view/userview/homepage/homepage.dart';
import 'package:advancedturizmuyg/view/userview/userpage/loginview.dart';
import 'package:advancedturizmuyg/view/userview/lokasyondetay.dart';
import 'package:advancedturizmuyg/view/userview/userpage/registerview.dart';
import 'package:advancedturizmuyg/view/userview/searchpage/searchpage.dart';
import 'package:advancedturizmuyg/view/userview/userpage/userview.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return GetMaterialApp(
      translations: Dil(),
      locale: Get.deviceLocale,
      fallbackLocale: Dil.varsayilan,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages:[
      GetPage(name: '/login',page: ()=> const UserLoginPage(),transition: Transition.cupertino),
      GetPage(name: '/register',page: ()=> const RegisterPage(),transition: Transition.cupertino),
      GetPage(name: '/home',page: ()=> HomePage(),transition: Transition.noTransition),
      GetPage(name: '/search',page: ()=> const SearchPageView(),transition: Transition.noTransition),
      GetPage(name: '/user',page: ()=> const UserPageView(),transition: Transition.noTransition),
      GetPage(name: '/adminlogin',page: ()=> const AdminLoginView(),transition: Transition.cupertino),
      GetPage(name: '/adminPage',page: ()=> const AdminHomePage(),transition: Transition.cupertino),
      GetPage(name: '/lokasyonAddPage',page: ()=> const LokasyonAddView(),transition: Transition.cupertino),
      GetPage(name: '/sehiradd',page: ()=> const MyWidget(),transition: Transition.cupertino),
      GetPage(name: '/lokasyonDetay',page: ()=> const LokasyonDetayView(),transition: Transition.cupertino),
      ]
    );
  }
}


