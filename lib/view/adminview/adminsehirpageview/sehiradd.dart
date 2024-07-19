import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

final SehirValidayon _controller = Get.put(SehirValidayon());

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 222, 222),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Şehir Ekle",style: Theme.of(context).textTheme.bodyLarge,),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: textFormField(
                              hintText: "Şehir isim: ",
                              controller: _controller.sehircontroller,
                              validator: _controller.validateSehir,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: customButton(
                              text: "Şehir Ekle",
                              onTap: () {

                                _controller.buttonClick(context);
                              },
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
