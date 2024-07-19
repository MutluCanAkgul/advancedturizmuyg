import 'package:advancedturizmuyg/view/userview/userpage/passwordForget.dart';
import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final LoginController _controller = Get.put(LoginController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDials(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [GestureDetector( onTap:(){
                    Get.toNamed('/adminlogin');
                  },child: const Logo())],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'title'.tr,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: _controller.validateEmail,
                        controller: _controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecorations.emailDecoration(),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Obx(() => Expanded(
                          child: TextFormField(
                            validator: _controller.validatePassword,
                            controller: _controller.passwordController,
                            obscureText: _controller.passwordVisible.value,
                            decoration: InputDecorations.passwordDecoration(_controller.passwordVisible.value, () {_controller.passwordVisible.toggle();})
                             
                            ),
                          ),
                        )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(()=> const CheckEmailPage());
                          },
                          child: Text(
                            "forgetPass".tr,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.lightBlue),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                               "rememberMe".tr,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Obx(
                              () => Switch(
                                value: _controller.isSwitched.value,
                                onChanged: (value) {
                                  setState(() {
                                    _controller.isSwitched.value = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: customButton(height: 60,text: "title".tr, onTap:()=> _controller.login(context)))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "youNew".tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Get.offAllNamed('/register');
                        },
                        child: Text(
                          "register".tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.lightBlue),
                        ))
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
 }

