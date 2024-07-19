// ignore_for_file: use_build_context_synchronously
import 'package:advancedturizmuyg/model/adminLogModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:advancedturizmuyg/model/services/apiConnection.dart';
import 'package:advancedturizmuyg/viewmodel/services/authservice.dart';

class RegisterController extends GetxController {
  final UserAuthService _userAuthService = UserAuthService();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool passwordVisible = true.obs;

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "nameReq".tr;
    }
    return null;
  }

  String? validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return "surnameReq".tr;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "emailReq".tr;
    }
    if (!GetUtils.isEmail(value)) {
      return "emailInvalid".tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "passwordReq".tr;
    }
    if (value.length < 8) {
      return "passwordLength".tr;
    }
    return null;
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await _userAuthService.insertUser({
        'name': nameController.text,
        'surname': surnameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Center(
            child: Text(
              "registerSuccess".tr,
            ),
          ),
        ),
      );
      Get.toNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("registerFail".tr + "$e"),
          ),
        ),
      );
    }
  }
}
class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool passwordVisible = true.obs;
  RxBool isSwitched = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkRememberMe();
  }

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void checkRememberMe() {
    if (box.read('isRemembered') ?? false) {
      emailController.text = box.read('email') ?? '';
      passwordController.text = box.read('password') ?? '';
      login(Get.context!);
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "emailReq".tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "passwordReq".tr;
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      String email = emailController.text;
      String password = passwordController.text;

      Map<String, dynamic>? user = await UserAuthService().loginUser(email, password);

      if (user != null) {
        if (isSwitched.value) {
          box.write('isRemembered', true);
          box.write('email', email);
          box.write('password', password);
        } else {
          box.remove('isRemembered');
          box.remove('email');
          box.remove('password');
        }
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("error".tr, "loginIncorrect".tr);
      }
    }
  }
}
class UserController extends GetxController{
  RxString userName = ''.obs;
  RxString userSurname = ''.obs;
   RxString kulId = ''.obs;
  void setUsername(String name){
    userName.value = name;
 
  }
  void setUserSurname(String surname){
    userSurname.value = surname;
 
  }
  void setUserId(String userId){
   
    kulId.value = userId; 
  }
}


class AdminLoginController extends GetxController{
  final TextEditingController adminNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey  = GlobalKey<FormState>();

  String? validateadminNo(String? value){
   if(value == null || value.isEmpty)
   {
    return "Personel No Girin";
   }
   return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return "Şifrenizi Girin";
    }
    return null;
  }
  RxBool passwordVisible = true.obs;

  void togglePasswordVisibility(){
    passwordVisible.value = !passwordVisible.value;
  }
  final AdminDataServices loginService = AdminDataServices();

  Future<bool> validateAdmin() async{
    if(formKey.currentState?.validate() ?? false){
      String adminNo = adminNoController.text;
      String password = passwordController.text;
      try{
      AdminLogDataModel? adminData = await loginService.apiCall();
      if(adminData != null){
        for(Item item in adminData.items){
          if(item.personelNo == adminNo && item.password == password){
            return true;
          }
        }
      }
    }
    catch(e){
      print(e);
    }
    }
    return false;
  }
}
class VerificationController extends GetxController {
  var verificationCodes = <String, String>{}.obs; // email ve kod çiftlerini saklamak için

  void saveVerificationCode(String email, String code) {
    verificationCodes[email] = code;
  }

  String? getVerificationCode(String email) {
    return verificationCodes[email];
  }

  void removeVerificationCode(String email) {
    verificationCodes.remove(email);
  }
}