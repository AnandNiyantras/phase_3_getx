import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phase_3_getx/new_simple_login_page.dart';
import 'fun.dart';
import 'const.dart';
import 'new_home_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: mainTitle,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    late bool isLogged;
    super.initState();
    getIsLogged().then((value) => isLogged = value);
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        isLogged
            ? MaterialPageRoute(
                builder: (context) => NewHomePage(),
              )
            : MaterialPageRoute(
                builder: (context) => newLogin(),
              ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(SplashImageAddress),
          ),
        ),
      ),
    );
  }
}
