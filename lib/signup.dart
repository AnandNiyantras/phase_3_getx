import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'searchUser.dart';
import 'const.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'fun.dart';
import 'new_home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  String gender = "male";
  String status = "active";
  late bool signupsuccess;

  // final baseUrl = "https://gorest.co.in/public/v2/users";
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState stateTextWithIcon1 = ButtonState.idle;
  Future<Album>? _futureAlbum;

  onPressedIconWithText() {
    _futureAlbum = createAlbum();
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            await createAlbum();
            setState(
              () {
                stateTextWithIcon = ButtonState.idle;
              },
            );
          },
        );

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
      },
    );
  }

  onPressedIconWithText1() {
    switch (stateTextWithIcon1) {
      case ButtonState.idle:
        stateTextWithIcon1 = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            Get.off(() => NewHomePage());
            setState(
              () {
                stateTextWithIcon1 = ButtonState.idle;
              },
            );
          },
        );

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon1 = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon1 = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon1 = stateTextWithIcon1;
      },
    );
  }

  Future<Album> createAlbum() async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: header,
      body: jsonEncode(
        <String, String>{
          'name': name.text,
          'email': email.text,
          'gender': gender,
          'status': status,
        },
      ),
    );
    // print(response.body);
    if (response.statusCode == 201) {
      setState(() {
        signupsuccess = true;
      });
      return Album.fromJson(jsonDecode(response.body));
    } else {
      signupsuccess = false;
      throw Exception("No Album Created");
    }
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          setIsLogged(true);
          globUserDetail['id'] = snapshot.data!.id.toString();
          globUserDetail['name'] = snapshot.data!.name;
          globUserDetail['email'] = snapshot.data!.email;
          globUserDetail['gender'] = snapshot.data!.gender;
          globUserDetail['status'] = snapshot.data!.status;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff040039).withOpacity(.15),
                      blurRadius: 99,
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.indigo.withOpacity(0.1),
                      radius: 50,
                      child: Text(
                        snapshot.data!.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    customListTile(snapshot.data!.id.toString(), Colors.purple,
                        Icons.numbers),
                    customListTile(
                        snapshot.data!.name, Colors.lightBlue, Icons.person),
                    customListTile(
                        snapshot.data!.email, Colors.pink, Icons.email),
                    customListTile(
                        snapshot.data!.gender,
                        Colors.green,
                        snapshot.data!.gender == "male"
                            ? Icons.male
                            : Icons.female),
                    customListTile(
                      snapshot.data!.status,
                      Colors.orange,
                      snapshot.data!.status == "active"
                          ? Icons.person_outline
                          : Icons.person_off_outlined,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ProgressButton.icon(
                          iconedButtons: {
                            ButtonState.idle: IconedButton(
                                text: 'Home Page',
                                icon: Icon(Icons.home, color: Colors.white),
                                color: Colors.deepPurple.shade500),
                            ButtonState.loading: IconedButton(
                                text: 'Loading',
                                color: Colors.deepPurple.shade700),
                            ButtonState.fail: IconedButton(
                                text: 'Failed',
                                icon: Icon(Icons.cancel, color: Colors.white),
                                color: Colors.red.shade300),
                            ButtonState.success: IconedButton(
                              text: 'Success',
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              color: Colors.green.shade400,
                            )
                          },
                          onPressed: onPressedIconWithText1,
                          state: stateTextWithIcon1),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // void printer() {
  //   print(name.text);
  //   print(email.text);
  //   print(gender);
  //   print(status);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            IconButton(
              tooltip: "Back",
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black.withOpacity(.6),
              ),
            ),
          ],
        ),
        title: Text(
          "Signup",
          style: TextStyle(
            color: Colors.black.withOpacity(.6),
          ),
        ),
        elevation: 10.0,
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.white),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), //Offset
                  blurRadius: 80.0,
                ),//BoxShadow
              ],
            ),
            child: Container(
              color: Colors.white,
              child: (_futureAlbum == null)
                  ? SingleChildScrollView(
                      child: Container(
                        height: 725,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  radius: 50,
                                  child: Icon(
                                    Icons.person_add,
                                    size: 60,
                                    color: Colors.blue.withOpacity(0.6),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Signup Here",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 32.0),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormFieldcomponent(
                                Icons.person,
                                "First Name        Last Name",
                                false,
                                false,
                                name),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(
                                Icons.email, "Email", false, false, email),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff040039).withOpacity(.15),
                                        blurRadius: 99,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Choose Gender",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Radio(
                                                    value: "male",
                                                    groupValue: gender,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          gender =
                                                              value.toString();
                                                        },
                                                      );
                                                    }),
                                                Expanded(
                                                  child: Text(
                                                    'Male',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: "female",
                                                  groupValue: gender,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        gender =
                                                            value.toString();
                                                      },
                                                    );
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Female',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 20.0, 0.0),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff040039).withOpacity(.15),
                                        blurRadius: 99,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Choose Status",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: "active",
                                                  groupValue: status,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        status =
                                                            value.toString();
                                                      },
                                                    );
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Active',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: "inactive",
                                                  groupValue: status,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        status =
                                                            value.toString();
                                                      },
                                                    );
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Inactive',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ProgressButton.icon(
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                        text: 'Signup',
                                        icon: Icon(Icons.login,
                                            color: Colors.white),
                                        color: Colors.deepPurple.shade500),
                                    ButtonState.loading: IconedButton(
                                        text: 'Loading',
                                        color: Colors.deepPurple.shade700),
                                    ButtonState.fail: IconedButton(
                                        text: 'Failed',
                                        icon: Icon(Icons.cancel,
                                            color: Colors.white),
                                        color: Colors.red.shade300),
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
                            ),
                          ],
                        ),
                      ),
                    )
                  : buildFutureBuilder(),
            ),
          ),
        ),
      ),
    );
  }
}

class Album {
  final int id;
  final String name, email, status, gender;

  // final String email;

  const Album(
      {required this.id,
      required this.email,
      required this.name,
      required this.status,
      required this.gender});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      gender: json['gender'],
    );
  }
}
