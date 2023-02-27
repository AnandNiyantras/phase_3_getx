import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'dart:ui';
import 'const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'fun.dart';
import 'new_home_page.dart';

class newLogin extends StatefulWidget {
  const newLogin({Key? key}) : super(key: key);

  @override
  State<newLogin> createState() => _newLoginState();
}

class _newLoginState extends State<newLogin> {
  List userDetails = [];
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;
  late bool loginSuccess;

  onPressedIconWithText() {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            await getdata();
            setState(
              () {
                stateTextWithIcon = ButtonState.idle;
                // loginSuccess ? ButtonState.success : ButtonState.fail;
              },
            );
          },
        );

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        Future.delayed(
          Duration(
            seconds: 1,
          ),
        );
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        Future.delayed(
          Duration(
            seconds: 1,
          ),
        );
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
      },
    );
  }

  TextEditingController e = TextEditingController();

  Future<bool> getdata() async {
    http.Response responce =
        await http.get(Uri.parse("$baseUrl?email=${e.text}"), headers: header);

    if (responce.statusCode == 200) {
      if (responce.body.length > 40) {
        setIsLogged(true);
        loginSuccess = true;
        userDetails = jsonDecode(responce.body);
        globUserDetail["id"] = userDetails[0]["id"].toString();
        globUserDetail["name"] = userDetails[0]["name"];
        globUserDetail["email"] = userDetails[0]["email"];
        globUserDetail["gender"] = userDetails[0]["gender"];
        globUserDetail["status"] = userDetails[0]["status"];
        print(globUserDetail);
        setData(globUserDetail);
        print("json encoded");
        Get.off(() => NewHomePage());
        return true;
      } else {
        loginSuccess = false;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            title: Text(alertTitle),
            content: Text(alertText),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    color: Colors.purple.shade700,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => SignupPage());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45.0),
                      color: Colors.purple.shade700),
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    // print(responce.statusCode);
    // print(responce.body.length);
    // print("$_baseUrl?email=${e.text}");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(_UserDetails);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: customAppBar(title: "Login"),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Center(
          child: Container(
            height: 500,
            width: 500,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3), blurRadius: 80.0)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                color: Colors.white,
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image(
                      //   image: NetworkImage(
                      //     "https://assets.nationbuilder.com/themes/5d1ad55ac2948011ce17704b/attachments/original/1553643295/login.png?1553643295",
                      //   ),
                      //   // color: Colors.purple.shade800.withOpacity(0.9),
                      //   color: Colors.black.withOpacity(0.6),
                      //   width: 100,
                      //   height: 100,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10.0),
                      //   child: Text("Login Here", style: TextStyle(fontSize: 32.0),),
                      // )
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: AnimatedTextKit(
                          displayFullTextOnTap: true,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              "Welcome Back!",
                              textStyle: TextStyle(
                                fontSize: 27,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                              cursor: "_",
                              speed: const Duration(
                                milliseconds: 150,
                              ),
                            ),
                          ],
                          totalRepeatCount: 1,
                          isRepeatingAnimation: false,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      TextFormFieldcomponent(
                        Icons.email,
                        "Enter Email",
                        false,
                        true,
                        e,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ProgressButton.icon(
                          iconedButtons: {
                            ButtonState.idle: IconedButton(
                                text: 'Login',
                                icon: Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                                color: Colors.deepPurple.shade500),
                            ButtonState.loading: IconedButton(
                              text: 'Loading',
                              color: Colors.deepPurple.shade700,
                            ),
                            ButtonState.fail: IconedButton(
                              text: 'Failed',
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              color: Colors.red.shade300,
                            ),
                            ButtonState.success: IconedButton(
                              text: 'Success',
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              color: Colors.green.shade400,
                            )
                          },
                          onPressed: onPressedIconWithText,
                          state: stateTextWithIcon),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
