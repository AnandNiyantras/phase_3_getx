import 'dart:convert';
import 'package:flutter/services.dart';
import 'const.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart';
import 'fun.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  ButtonState stateTextWithIcon = ButtonState.idle;
  List userDetails = [];
  bool entry = true;
  bool err = false;
  late bool getinfo;
  late bool updatedUser;
  String errText = "";
  String uName = "";
  String uid = "";
  String uemail = "";
  String gender = "";
  String status = "completed";

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

  Future<void> createAlbum() async {
    entry = false;
    Response response = await patch(
      Uri.parse("$baseUrl/${id.text}"),
      headers: header,
      body: jsonEncode(
        <String, String>{
          // 'id': id.text.toString(),
          'name': name.text,
          'email': email.text,
          'gender': gender,
          'status': status,
        },
      ),
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(
        () {
          err = true;
          updatedUser = true;
          errText = "Data Updated Successfully";
          customSnackBar("Success", "Data Updated Successfully");
          if (globUserDetail['id'] == id.text.toString()) {
            globUserDetail['name'] = name.text;
            globUserDetail['email'] = email.text;
            globUserDetail['gender'] = gender;
            globUserDetail['status'] = status;
          }
        },
      );
    } else if (response.statusCode == 404) {
      setState(
        () {
          err = true;
          updatedUser = false;
          errText = "User Not Found";
        },
      );
    } else {
      err = true;
      updatedUser = false;
      errText = "${response.statusCode}";
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> getdata() async {
    Response responce = await get(
      Uri.parse("$baseUrl/${id.text}"),
      headers: header,
    );
    userDetails.clear();
    uName = "";
    uid = "";
    uemail = "";
    gender = "";
    status = "";
    userDetails.add(
      jsonDecode(responce.body),
    );
    entry = false;
    if (responce.statusCode == 200) {
      if (responce.body.length > 10) {
        setState(
          () {
            err = false;
            getinfo = true;
            uName = userDetails[0]['name'];
            uid = userDetails[0]['id'].toString();
            uemail = userDetails[0]['email'];
            gender = userDetails[0]['gender'];
            status = userDetails[0]['status'];
          },
        );
      }
    }
    if (responce.statusCode == 404) {
      setState(
        () {
          getinfo = false;
          err = true;
          errText = "User Not Found";
          customSnackBar("Failed", "User Not Found");
        },
      );
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print("$baseUrl/${id.text}");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(_UserDetails[0]['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const customAppBar(title: "Update User Details"),
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
                ),
              ],
            ),
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  height: 800,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldcomponent(
                          Icons.person, "Enter User ID", false, false, id),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ProgressButton.icon(
                            iconedButtons: {
                              ButtonState.idle: IconedButton(
                                  text: 'Search',
                                  icon: Icon(Icons.search, color: Colors.white),
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
                            onPressed: onPressedIconWithText,
                            state: stateTextWithIcon),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      entry
                          ? Text("")
                          : !err
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFormFieldcomponent(
                                        Icons.person,
                                        "Change Name",
                                        false,
                                        false,
                                        name..text = uName),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormFieldcomponent(
                                        Icons.email,
                                        "Change Email",
                                        false,
                                        false,
                                        email..text = uemail),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
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
                                              color: Color(0xff040039)
                                                  .withOpacity(.15),
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
                                                  fontSize: 18,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
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
                                                                gender = value
                                                                    .toString();
                                                              },
                                                            );
                                                          }),
                                                      Expanded(
                                                        child: Text(
                                                          'Male',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
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
                                                              gender = value
                                                                  .toString();
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Female',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
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
                                              color: Color(0xff040039)
                                                  .withOpacity(.15),
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
                                                  fontSize: 18,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
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
                                                                status = value
                                                                    .toString();
                                                              },
                                                            );
                                                          }),
                                                      Expanded(
                                                        child: Text(
                                                          'Active',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
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
                                                              status = value
                                                                  .toString();
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Inactive',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    MaterialButton(
                                      minWidth: 180,
                                      height: 50,
                                      color: Colors.green.withOpacity(0.8),
                                      child: const Text(
                                        "Update",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      onPressed: () {
                                        setState(
                                          () {
                                            uName = name.text;
                                            uemail = email.text;
                                          },
                                        );
                                        createAlbum();
                                      },
                                    ),
                                  ],
                                )
                              : CustomErrorText(
                                  textTitle: errText,
                                ),
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
