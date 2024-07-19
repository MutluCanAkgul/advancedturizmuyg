import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final RegisterController _controller = Get.put(RegisterController());

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDials(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Form(
            key: _controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ Logo()],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Turizmuyg " + "register".tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: textFormField(
                            hintText: "name".tr,
                            validator: _controller.validateName,
                            controller: _controller.nameController))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: textFormField(
                            hintText: "surname".tr,
                            validator: _controller.validateSurname,
                            controller: _controller.surnameController))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      validator: _controller.validateEmail,
                      controller: _controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecorations.emailDecoration(),
                    ))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Obx(() => Expanded(
                            child: TextFormField(
                          controller: _controller.passwordController,
                          validator: _controller.validatePassword,
                          obscureText: _controller.passwordVisible.value,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 2, 0, 117)),
                          decoration: InputDecorations.passwordDecoration(
                              _controller.passwordVisible.value, () {
                            _controller.passwordVisible.toggle();
                          }),
                        )))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: customButton(
                        height: 60,
                          text: "register".tr,
                          onTap: () => _controller.register(context)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "youSignIn".tr,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.toNamed('/login');
                            },
                            child: Text(
                              "title".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: Colors.lightBlue),
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
