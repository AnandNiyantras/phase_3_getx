import 'dart:convert';
import 'searchUser.dart';

import 'const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'fun.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({Key? key}) : super(key: key);

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  TextEditingController id = TextEditingController();

  ButtonState stateTextWithIcon = ButtonState.idle;

  ButtonState stateTextWithIcon1 = ButtonState.idle;
  List userDetails = [];
  late bool getinfo;
  late bool deleteinfo;
  bool err = false;
  bool entry = true;
  String errText = "";
  String uName = "";
  String uid = "";
  String uemail = "";
  String ugender = "";
  String status = "";

  onPressedIconWithText() {
    userDetails.clear();
    uName = "";
    uid = "";
    uemail = "";
    ugender = "";
    status = "";
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

  onPressedIconWithText1() {
    switch (stateTextWithIcon1) {
      case ButtonState.idle:
        stateTextWithIcon1 = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            await deletedata();
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

  Future<void> getdata() async {
    Response responce =
        await get(Uri.parse("$baseUrl/${id.text}"), headers: header);
    userDetails.add(
      jsonDecode(responce.body),
    );
    if (responce.statusCode == 200) {
      if (responce.body.length > 10) {
        entry = false;
        getinfo = true;
        err = false;
        uName = userDetails[0]['name'];
        uid = userDetails[0]['id'].toString();
        uemail = userDetails[0]['email'];
        ugender = userDetails[0]['gender'];
        status = userDetails[0]['status'];
      }
    }
    if (responce.statusCode == 404) {
      entry = false;
      getinfo = false;
      err = true;
      errText = "No User Found";
      customSnackBar("Failed", "User Not Found");
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print("$_baseURL/${id.text}");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(_UserDetails[0]['id']);
  }

  Future<void> deletedata() async {
    Response responce =
        await delete(Uri.parse("$baseUrl/${id.text}"), headers: header);
    print(responce.statusCode);
    if (responce.statusCode == 204) {
      // setIsLogged(false);
      deleteinfo = true;
      entry = false;
      err = true;
      errText = "User Deleted";
      customSnackBar("Success", "User Deleted");
    }
    if (responce.statusCode == 404) {
      entry = false;
      deleteinfo = false;
      err = true;
      errText = "No User Found";
      customSnackBar("Failed", "User Not Found");
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print("$_baseURL/${id.text}");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(_UserDetails[0]['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const customAppBar(title: "Delete User"),
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
              child: SingleChildScrollView(
                child: Container(
                  height: 725,
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldcomponent(
                          Icons.search, "Enter User ID", false, false, id),
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
                                  children: [
                                    // homePageCard(Colors.white, uid, uName, uemail, ugender, status),
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
                                            customListTile(uid, Colors.purple,
                                                Icons.numbers),
                                            customListTile(uName,
                                                Colors.lightBlue, Icons.person),
                                            customListTile(uemail, Colors.pink,
                                                Icons.email),
                                            customListTile(
                                                ugender,
                                                Colors.green,
                                                ugender == "male"
                                                    ? Icons.male
                                                    : Icons.female),
                                            customListTile(
                                                status,
                                                Colors.orange,
                                                status == "active"
                                                    ? Icons.person_outline
                                                    : Icons
                                                        .person_off_outlined),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                      child: ProgressButton.icon(
                                        iconedButtons: {
                                          ButtonState.idle: IconedButton(
                                              text: 'Delete',
                                              icon: Icon(Icons.delete_forever,
                                                  color: Colors.white),
                                              color:
                                                  Colors.deepPurple.shade500),
                                          ButtonState.loading: IconedButton(
                                              text: 'Loading',
                                              color:
                                                  Colors.deepPurple.shade700),
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
                                        onPressed: onPressedIconWithText1,
                                        state: stateTextWithIcon1,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: CustomErrorText(
                                    textTitle: errText,
                                  ),
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
