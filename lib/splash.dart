import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:u_packed/presentation/route/app_routes.dart';
import 'package:u_packed/presentation/screen/luggage/luggage_bottom_nav.dart';
import 'package:u_packed/presentation/screen/main_tab_bar/main_tab_bar.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var box = GetStorage();

  void chooseScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (box.read('auth') == 'Done') {
        Future.delayed(const Duration(seconds: 3)).then((value) {
         Get.to(()=>MainHomeTabBar());
        });
      } else if (box.read('auth') == null) {
        Future.delayed(const Duration(seconds: 3)).then((value) async{
         Get.offAndToNamed(phoneverificationScreen);
        });
      }
    });
  }

   String? _version;

  void _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;

    _version = version;
    box.write('version', _version);
  }
  
  receiveAdminNotification()async{
    try {
      await FirebaseMessaging.instance.subscribeToTopic("upackedadmin");
    } catch (e) {
      print(e);
    }
  }
  
  @override
  void initState() {
    chooseScreen();
     _getAppVersion();
     receiveAdminNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBD4D9),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            "assets/logo/app_logo.png",
            height: 150,
            width: 150,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
