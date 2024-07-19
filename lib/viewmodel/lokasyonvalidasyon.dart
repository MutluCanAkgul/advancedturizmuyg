import 'package:advancedturizmuyg/viewmodel/services/adminservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LokasyonValidasyon extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final adressController = TextEditingController();
  final contentController = TextEditingController();
  Rx<String> selectedSehir = Rx<String>('');
  Rx<String> selectedLanguages = Rx<String>('');
  RxList<String> base64Images = <String>[].obs;

  String? lokasyonName(String? value) {
    if (value == null || value.isEmpty) {
      return "Lokasyon adı zorunludur";
    }
    return null;
  }

  String? lokasyonAdress(String? value) {
    if (value == null || value.isEmpty) {
      return "Lokasyon Adresi zorunludur";
    }
    return null;
  }

  String? lokasyonSehir(String? value) {
    if (value == null || value.isEmpty) {
      return "Şehir Seçimi Zorunludur";
    }
    return null;
  }

  String? lokasyonContent(String? value) {
    if (value == null || value.isEmpty) {
      return "Lokasyon ile içerik yazılması zorunludur";
    }
    return null;
  }

  String? lokasyonLanguage(String? value) {
    if (value == null || value.isEmpty) {
      return "Lokasyon içerik dili seçilmesi zorunludur";
    }
    return null;
  }

  Future<void> lokasyonAdd() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      await AdminAddDataBase().insertLokasyon(
        lokasyonAdi: nameController.text,
        lokasyonAdresi: adressController.text,
        sehir: selectedSehir.value,
        icerik: contentController.text,
        icerikDili: selectedLanguages.value,
        images: base64Images.toList(),
      );

      Get.snackbar(
        "Başarılı",
        "Lokasyon başarıyla eklendi.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      nameController.clear();
      adressController.clear();
      contentController.clear();
      selectedSehir.value = '';
      selectedLanguages.value = '';
      base64Images.clear();
    } catch (e) {
      Get.snackbar(
        "Hata",
        "Lokasyon eklenirken bir hata oluştu.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }
}
class SehirValidayon extends GetxController{
   final  formKey = GlobalKey<FormState>();
   final sehircontroller = TextEditingController();
   
  RxList<Map<String, dynamic>> sehirler = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSehirler(); 
  }

  Future<void> fetchSehirler() async {
    try {
      AdminAddDataBase dbService = AdminAddDataBase();
      sehirler.assignAll(await dbService.getSehirler());
    } catch (e) {
      print('Hata oluştu: $e');
      
    }
  }
   
  String? validateSehir(String? value){
    if(value == null || value.isEmpty){
      return "Bu alan boş bırakılamaz";
    }
    return null;
  }
  
  Future<void> buttonClick(BuildContext context) async{
    if (!formKey.currentState!.validate()) {
      return;
    }
    final sehirAdi = sehircontroller.text;
    AdminAddDataBase dbService = AdminAddDataBase();
    await dbService.insertSehir(sehirAdi);

    // Başarılı ekleme bildirimi
    Get.snackbar("Başarılı", "Şehir başarıyla eklendi");

   
    sehircontroller.clear();
    formKey.currentState!.reset();
  }   
}
class LokasyonController extends GetxController{
  RxString selectedId = RxString("");
  void updateSelectedId(String id){
  selectedId.value = id;
  }
}