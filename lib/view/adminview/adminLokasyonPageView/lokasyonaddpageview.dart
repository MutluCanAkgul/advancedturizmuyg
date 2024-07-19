import 'dart:io';
import 'dart:convert';
import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LokasyonAddView extends StatefulWidget {
  const LokasyonAddView({super.key});

  @override
  State<LokasyonAddView> createState() => _LokasyanAddViewState();
}

class _LokasyanAddViewState extends State<LokasyonAddView> {
  final LokasyonValidasyon _controller = Get.put(LokasyonValidasyon());
  final SehirValidayon _sehirlerController = Get.put(SehirValidayon());
  final ImagePicker _picker = ImagePicker();
  final List<File> selectedImages = [];
  final List<String> languages = ["Türkçe", "English", "Русский"];
   

 Future<void> _pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    print("Picked image path: ${pickedFile.path}");
    bool alreadySelected = selectedImages.any((image) => image.path == pickedFile.path);
    if(selectedImages.length > 4){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("En fazla 5 resim eklenebilir."),
        duration: Duration(seconds: 1),
      ));
    }
    else{
    if (alreadySelected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bu resim zaten seçildi."),
        duration: Duration(seconds: 1),
      ));
    } else {
      File imageFile = File(pickedFile.path);
      String base64Image = await _convertImageToBase64(imageFile);
      setState(() {
        selectedImages.add(imageFile);
        _controller.base64Images.add(base64Image);
      });
    }
    }
  }
}

Future<String> _convertImageToBase64(File imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();
  return base64Encode(imageBytes);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(key: _controller.formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Lokasyon Ekle",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 222, 222, 222),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: textFormField(
                                hintText: "Lokasyon Adı:",
                                controller: _controller.nameController,
                                validator: _controller.lokasyonName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: textFormField(
                                hintText: "Lokasyonun Adresi: ",
                                controller: _controller.adressController,
                                validator: _controller.lokasyonAdress,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                       Row(
                  children: [
                    Obx(() => Expanded(
                      child: DropdownButtonFormField<String>(
                        value: null,
                        items: _sehirlerController.sehirler.map((sehir) {
                          return DropdownMenuItem<String>(
                            value: sehir['sehirAdi'].toString(),
                            child: Text(sehir['sehirAdi'].toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            print("Seçilen şehir: $newValue"); // Seçilen şehri kontrol et
                            _controller.selectedSehir.value = newValue;
                          }
                        },
                        validator: _controller.lokasyonSehir,
                        decoration: InputDecoration(
                          hintText: "Şehir Seçin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 1, 248, 38),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Resim Yükle",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(selectedImages[index])),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 222, 222, 222),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: textFormField(
                                        hintText: "İçerik.",
                                        controller: _controller.contentController,
                                        validator: _controller.lokasyonContent,
                                        maxLines: null))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: null,
                                    items: languages.map((String language) {
                                      return DropdownMenuItem<String>(
                                          value: language, child: Text(language));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        _controller.selectedLanguages.value = newValue;
                                      }
                                    },
                                    validator: _controller.lokasyonLanguage,
                                    decoration: InputDecoration(
                                      hintText:
                                          "Lokasyon içeriklerinin metin dilini seçin",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: customButton(text: "Lakosyon Ekle", onTap: (){
                                  _controller.lokasyonAdd()
                                  ;
                                }, height: 60))
                              ],
                            )
                          ],
                        ),
                      ),
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
