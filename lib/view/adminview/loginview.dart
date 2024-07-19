import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  final AdminLoginController _controller = Get.put(AdminLoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(padding:const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [GestureDetector(onTap: (){
               
              },child: Logo())],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: textFormField(
                    hintText: "Personel No:",
                    controller: _controller.adminNoController,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Obx(()=> Expanded(
                    child: TextFormField(
                  obscureText: _controller.passwordVisible.value,
                  controller: _controller.passwordController,
                  decoration: InputDecorations.passwordDecoration(
                    _controller.passwordVisible.value, () { _controller.passwordVisible.toggle(); }
                    ),
                )))
              ],
            ),
            const SizedBox(height: 20,),
            Row(children: [Expanded(child: customButton(height: 60,text: "Giriş Yap", onTap: ()async{
              bool isValid = await _controller.validateAdmin();
              if(isValid){
                Get.toNamed('/adminPage');
              }
              else{
                Get.snackbar("Hata", "Personel No veya Şifre Hatalı");
              }
            }))],)
          ],
        ),
      ),
    ));
  }
}
