import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Expanded(
          child: PageView(children: [
            AdminContent1(),           
            AdminContent2(),
            AdminContent3()
          ],),
        )
      ),
      );
    
  }
}
class AdminContent1 extends StatefulWidget {
  const AdminContent1({super.key});

  @override
  State<AdminContent1> createState() => _AdminContent1State();
}

class _AdminContent1State extends State<AdminContent1> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children:[ Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Lokasyon İşlemleri",style: Theme.of(context).textTheme.headlineSmall,)],),
         Container(
        decoration:BoxDecoration(color: Color.fromARGB(255, 212, 218, 221),borderRadius: BorderRadius.circular(16)),child: Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(children: [
            
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Expanded(
                child: customButton(text: "Lokasyon Ekle", onTap:(){
                  Get.toNamed('/lokasyonAddPage');
                },height: 100),
              ), 
            ],
            ),
            const SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              Expanded(child: customButton(text: "Lokasyon Güncelle", onTap:(){}, height: 100,)),
            ],),
            const SizedBox(height: 10,),
            Row(children: [
              Expanded(child: customButton(text: "Lokasyon Sil", onTap:(){}, height: 100))
            ],)
          ],),
        ), 
      ),
    ]);
  }
}
class AdminContent2 extends StatefulWidget {
  const AdminContent2({super.key});

  @override
  State<AdminContent2> createState() => _AdminContent2State();
}

class _AdminContent2State extends State<AdminContent2> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children:[ Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Kullanıcı İşlemleri",style: Theme.of(context).textTheme.headlineSmall,)],),
         Container(
        decoration:BoxDecoration(color: Color.fromARGB(255, 211, 216, 219),borderRadius: BorderRadius.circular(16)),child: Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(children: [
            
            Row(
              children: [
              Expanded(child: customButton(text: "Yorum İşlemleri", onTap:(){}, height: 100)), 
            ],
            ),
            const SizedBox(height: 10,),
            Row(children: [
              Expanded(child: customButton(text: "Yorum Kaldır", onTap:(){}, height: 100)),
              
            ],),
            const SizedBox(height: 10,),
            Row(children: [
              Expanded(child: Expanded(child: customButton(text: "Kullanıcı Kaldır", onTap: (){}, height: 100)))
            ],)
          ],),
        ), 
      ),
    ]);
  }
}
class AdminContent3 extends StatefulWidget {
  const AdminContent3({super.key});

  @override
  State<AdminContent3> createState() => _AdminContent3State();
}

class _AdminContent3State extends State<AdminContent3> {
  @override
  Widget build(BuildContext context) {
    return 
    Column(mainAxisAlignment: MainAxisAlignment.center,
      children:[ Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Diğer İşlemler",style: Theme.of(context).textTheme.headlineSmall,)],),
         Container(
        decoration:BoxDecoration(color: Color.fromARGB(255, 211, 216, 219),borderRadius: BorderRadius.circular(16)),child: Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(children: [
            
            Row(
              children: [
              Expanded(
                child: customButton(text: "Şehir Ekle", onTap:(){
                  Get.offNamed('/sehiradd');
                }, height: 100,),
              ), 
            ],
            ),
            const SizedBox(height: 10,),
            Row(children: [
              Expanded(child: customButton(text: "Şehir Sil", onTap:(){}, height: 100)),
             
            ],),
            const SizedBox(height: 10,),
            Row(children: [
               Expanded(child: customButton(text: "Login Sayfasına Dön", onTap:(){
                Get.offAndToNamed('/login');
               }, height: 100,)),
            ],)
          ],),
        ), 
      ),
    ]);
  }
}