import 'package:flutter/material.dart';

// Strings
String mainTitle = "Rest API";
String alertTitle = "Alert";
String alertText =
    "You Don't have the account\nclick cancel to correct email or create new account";
String alertSignoutText =
    "Do you want to logout from this application?";
String loginTitle = "Login Page";
String signupTitle = "Signup Page";
String errText = "Something Went Wrong";

// URLs
String baseUrl = 'https://gorest.co.in/public/v2/users';

// Image Addresses
String SplashImageAddress = "assets/img.png";
String Background1ImageAddress = "assets/background.jpg";
String Background2ImageAddress = "assets/bg.jpg";
String Background3ImageAddress = "assets/istockphoto.jpg";

//Header
Map<String, String> header = {
  'Content-Type': 'application/json',
  'Authorization':
      'Bearer d148e134d12d03ca8fde0850c68e908253cd58a51811236ef44fd2f6384a560c',
};
Map<String, String> globUserDetail = {
  'id': '',
  'name': '',
  'email': '',
  'gender': '',
  'status': '',
};

Size size = Size(411.4, 867.4);

//Regular Expression
final emailRegExp = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final nameRegExp =
    new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
