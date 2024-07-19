import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Image.asset(
        "images/logo.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

Widget textFormField(
    {required hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int? expanded,
    int? maxLength,
    int? maxLines}) {
  if (expanded != null) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(color: Color.fromARGB(255, 2, 0, 117)),
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.white,
          filled: true,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 2, 0, 117)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        validator: validator,
      ),
    );
  }
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    maxLength: maxLength,
    keyboardType: TextInputType.name,
    style: const TextStyle(color: Color.fromARGB(255, 2, 0, 117)),
    decoration: InputDecoration(
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 2, 0, 117)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    ),
    validator: validator,
  );
}

class InputDecorations {
  static InputDecoration emailDecoration() {
    return InputDecoration(
        hintText: "Email : ",
        hintStyle: const TextStyle(color: Color.fromARGB(255, 2, 0, 117)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: const Icon(
          Icons.mail,
          color: Color.fromARGB(255, 2, 0, 117),
        ));
  }

  static InputDecoration passwordDecoration(
      bool passwordVisible, VoidCallback onPressed) {
    return InputDecoration(
        hintText: "password".tr,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 2, 0, 117),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(255, 2, 0, 117),
          ),
          onPressed: onPressed,
        ));
  }
}

Widget customButton(
    {required String text,
    required VoidCallback onTap,
    required double height,
    int? expanded,
    double? width}) {
  if (expanded != null) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: Colors.lightBlue),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.lightBlue),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

class BottomAppBars extends StatefulWidget {
  final RxInt index;
  const BottomAppBars({super.key, required this.index});

  @override
  State<BottomAppBars> createState() => _BottomAppBarsState();
}

class _BottomAppBarsState extends State<BottomAppBars> {
  // ignore: unused_field
  final NavigationController _controller = Get.put(NavigationController());


  @override
  Widget build(BuildContext context) {
    
    return CurvedNavigationBar(
      index: 0,
      items: const [
        Icon(Icons.home),
        Icon(Icons.search),
        Icon(Icons.person),
      ],
      color: Colors.lightBlue,
      buttonBackgroundColor: Colors.lightBlue,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      height: 50,
      onTap: (i) {
        setState(() {
          widget.index.value = i;

        });
      },
      letIndexChange: (index) => true,
    );
  }
}

class NavigationController extends GetxController {
  //final RxInt selectedIndex = 0.obs;
}

class AppBars extends StatelessWidget {
  const AppBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
          height: 50,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.black,
          ))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Logo()],
          )),
    );
  }
}

Widget listTiles(
    {required VoidCallback onTap,
    required String text,
    required icon,
    dynamic color,
    int? expanded}) {
  if (expanded != null) {
    return Expanded(
        child: Container(
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.lightBlue),
      child: ListTile(
        title: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white)),
        onTap: onTap,
        trailing: icon,
      ),
    ));
  }
  return Container(
    height: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: Colors.lightBlue),
    child: ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white)),
      ),
      onTap: onTap,
      trailing: icon,
    ),
  );
}
class SpeedDials extends StatefulWidget {
  @override
  State<SpeedDials> createState() => _SpeedDialsState();
}

class _SpeedDialsState extends State<SpeedDials> {
  @override
  Widget build(BuildContext context) {

    return SpeedDial(
    icon: Icons.language_sharp,
    backgroundColor: Colors.lightBlue,
    overlayColor: Colors.black,
    overlayOpacity: 0.4,
    children: [SpeedDialChild(
      label: 'Türkçe',
      onTap:(){
        Get.updateLocale(Locale('tr','TR'));
           } 
    ),
    SpeedDialChild(
      label: 'English',
      onTap:(){
          Get.updateLocale(Locale('en','US'));        
      } 
    ),
    SpeedDialChild(
      label: 'Русский',
      onTap:(){
           Get.updateLocale(Locale('ru','RU'));  
      } 
    )
    ],
  );
  }
}