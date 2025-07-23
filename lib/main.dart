import 'package:baas_db_downloader/constant.dart';
import 'package:baas_db_downloader/home/view/home.v.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  _configEasyLoading();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaaS DB Downloader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor)),
      home: HomeView(),
      builder: EasyLoading.init(),
    );
  }
}

void _configEasyLoading() => EasyLoading.instance
  ..dismissOnTap = false
  ..userInteractions = false
  ..maskType = EasyLoadingMaskType.black
  ..indicatorType = EasyLoadingIndicatorType.fadingCircle;
