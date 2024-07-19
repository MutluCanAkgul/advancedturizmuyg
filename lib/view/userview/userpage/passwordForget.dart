import 'dart:async';

import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/services/authservice.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EmailVerificationController extends GetxController {
  var verifiedEmail = ''.obs;
}

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  final TextEditingController checkEmailController = TextEditingController();
  final UserAuthService _uController = UserAuthService();
  final EmailVerificationController _emailVerificationController =
      Get.put(EmailVerificationController());
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  Future<void> clicked() async {
    if (_formKey1.currentState?.validate() ?? false) {
      RxString email = checkEmailController.text.obs;
      print("Girdi e-postası: ${email.value}");

      try {
        await _uController.checkEmail(email);
        print("checkEmail fonksiyonu çağrıldı.");

        _emailVerificationController.verifiedEmail.value = email.value;
        print("Doğrulama e-postası ayarlandı: ${_emailVerificationController.verifiedEmail.value}");

        Get.to(() => const CheckEmailCode());
      } catch (e) {
        print("Bir hata oluştu: $e");
      }
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'emailReq'.tr;
    }
    if (!GetUtils.isEmail(value)) {
      return "emailInvalid".tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text('emailTitle'.tr,
                  style: Theme.of(context).textTheme.displaySmall),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: textFormField(
                              hintText: "Email : ",
                              controller: checkEmailController,
                              validator: emailValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: customButton(
                              text: "verification".tr,
                              onTap: clicked,
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CheckEmailCode extends StatefulWidget {
  const CheckEmailCode({super.key});

  @override
  State<CheckEmailCode> createState() => _CheckEmailCodeState();
}

class _CheckEmailCodeState extends State<CheckEmailCode> {
  final TextEditingController _codeController = TextEditingController();
  final EmailVerificationController _eController =
      Get.put(EmailVerificationController());
  final EmailVerificationTimer _eTimerController =
      Get.put(EmailVerificationTimer());
  final UserAuthService _authService = UserAuthService();
  @override
  void initState() {
    super.initState();
    _eTimerController.startTimer(_sendNewCode);
  }

  void _verifyCode() {
    if (_authService.verifyCode(_codeController.text)) {
      _eTimerController.stopTimer();
      Get.to(() => const RefleshPasswordPage());
    } else {
      Get.snackbar('error'.tr, 'validateInvalid'.tr);
    }
  }

  void _sendNewCode() {
    _authService.checkEmail(_eController.verifiedEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  _eController.verifiedEmail.value + 'verdes'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: textFormField(
                          hintText: 'code'.tr,
                          controller: _codeController,
                          maxLength: 6)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => TextButton(
                    onPressed: _eTimerController.isWaiting.value
                        ? null
                        : _sendNewCode,
                    child: Text(_eTimerController.isWaiting.value
                        ? 'Kod gelmedi: ${_eTimerController.timeLeft.value} saniye'
                        : 'Yeni Kod Gönder'),
                  )),
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text('Doğrula'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class RefleshPasswordPage extends StatefulWidget {
  const RefleshPasswordPage({super.key});

  @override
  State<RefleshPasswordPage> createState() => _RefleshPasswordPageState();
}

class _RefleshPasswordPageState extends State<RefleshPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}

class EmailVerificationTimer extends GetxController {
  RxBool isWaiting = false.obs;
  Timer? _timer;
  RxInt timeLeft = 0.obs;

  void startTimer(Function onTimerComplete) {
    isWaiting.value = true;
    timeLeft.value = 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        stopTimer();
        onTimerComplete();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isWaiting.value = false;
  }
}