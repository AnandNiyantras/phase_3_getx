import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import 'const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fun.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class Todos extends StatefulWidget {
  const Todos({Key? key}) : super(key: key);

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController id = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController status = TextEditingController();
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState stateTextWithIcon1 = ButtonState.idle;
  late bool getinfo;
  List userDetails = [];
  bool entry = true;
  bool addtodo = false;
  bool err = false;
  bool searchPost = true;
  late bool postsuccess;
  String errText = "";
  String utitle = "";
  String ubody = "";

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

  onPressedIconWithText1() {
    switch (stateTextWithIcon1) {
      case ButtonState.idle:
        stateTextWithIcon1 = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            await userPost();
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
    http.Response responce =
        await http.get(Uri.parse("$baseUrl/${id.text}/todos"), headers: header);
    userDetails.clear();
    userDetails.add(
      jsonDecode(responce.body),
    );
    if (responce.statusCode == 200) {
      if (responce.body.length > 50) {
        setState(
          () {
            getinfo = true;
            err = false;
            entry = false;
          },
        );
      } else {
        setState(
          () {
            getinfo = false;
            err = true;
            entry = false;
            errText = "No User's TODO Found";
            customSnackBar("Failed", "User's TODO Not Found");
          },
        );
      }
    }
    if (responce.statusCode == 404) {
      setState(
        () {
          getinfo = false;
          err = true;
          entry = false;
          errText = "User Not Found";
          customSnackBar("Failed", "User Not Found");
        },
      );
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print(responce.body);
    // print("$baseUrl/${id.text}/todos");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(_UserDetails[0][0]);
    // print(_UserDetails[0].length);
    // print(_UserDetails[0][1]);
  }

  Future<void> userPost() async {
    final data = jsonEncode(
      <String, String>{
        'user_id': id.text,
        'title': title.text,
        'status': status.text,
        'due_on': "${date.text}T00:00:00.000+05:30"
      },
    );
    http.Response responce = await http.post(
      Uri.parse("$baseUrl/${id.text}/todos"),
      headers: header,
      body: data,
    );
    //NEED IMPROVEMENT
    if (responce.statusCode == 201) {
      if (responce.body.length > 50) {
        postsuccess = true;
        customSnackBar("Success", "TODO Added");
      }
    } else if (responce.statusCode == 422) {
      postsuccess = false;
      customSnackBar("Failed", "User Not Found");
    } else {
      postsuccess = false;
      customSnackBar("Failed", "Something Went Wrong");
    }
    FocusScope.of(context).unfocus();
    // print("$baseUrl/${id.text}/todos");
    // print(data);
    // print(id.text);
    // print(title.text);
    // print(status);
    // print("${date.text}T00:00:00.000+05:30");
    // print(responce.statusCode);
    // print(responce.body);
    // print(responce.contentLength);
  }

  final UserDetails UD = Get.put(UserDetails());

  void initState() {
    super.initState();
    UD.getUserTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const customAppBar(title: "Todos"),
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
                  height: 725,
                  padding: const EdgeInsets.all(15.0),
                  child: !addtodo
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.person,
                                "Enter User ID", false, false, id),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: ProgressButton.icon(
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                        text: 'Search',
                                        icon: const Icon(Icons.search,
                                            color: Colors.white),
                                        color: Colors.deepPurple.shade500),
                                    ButtonState.loading: IconedButton(
                                        text: 'Loading',
                                        color: Colors.deepPurple.shade700),
                                    ButtonState.fail: IconedButton(
                                        text: 'Failed',
                                        icon: const Icon(Icons.cancel,
                                            color: Colors.white),
                                        color: Colors.red.shade300),
                                    ButtonState.success: IconedButton(
                                      text: 'Success',
                                      icon: const Icon(
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
                                ? Obx(
                                    () => UD.SearchedUserTodoWithNameList
                                            .isNotEmpty
                                        ? Expanded(
                                            child: ListView.separated(
                                              itemCount: UD
                                                  .SearchedUserTodoWithNameList
                                                  .length,
                                              itemBuilder: (_, int index) {
                                                return homePageCard3(
                                                    UD.SearchedUserTodoWithNameList[
                                                        index]["name"],
                                                    UD.SearchedUserTodoWithNameList[
                                                        index]["title"],
                                                    "${UD.SearchedUserTodoWithNameList[index]["status"]}\n${UD.SearchedUserTodoWithNameList[index]["due_on"]}");
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SizedBox(
                                                  height: 10,
                                                );
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.purple.shade800
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                  )
                                : !err
                                    ? Expanded(
                                        child: ListView.separated(
                                          itemCount: userDetails[0].length,
                                          itemBuilder: (context, int index) {
                                            return homePageCard2(
                                                userDetails[0][index]["id"]
                                                    .toString(),
                                                userDetails[0][index]["title"],
                                                '${userDetails[0][index]["status"]}\n\n${userDetails[0][index]["due_on"]}');
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(
                                              height: 20,
                                            );
                                          },
                                        ),
                                      )
                                    : CustomErrorText(textTitle: errText)
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.person,
                                "Enter User ID", false, false, id),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.title, "Enter Title",
                                false, false, title),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.book_online,
                                "Enter Status", false, false, status),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(
                                Icons.date_range,
                                "Enter Date in YYYY-MM-DD Formate",
                                false,
                                false,
                                date),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ProgressButton.icon(
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                        text: 'Add Todo',
                                        icon: Icon(Icons.add_task,
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
                                  onPressed: onPressedIconWithText1,
                                  state: stateTextWithIcon1),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        // isExtended: true,
        icon: Icon(
          Icons.add,
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            addtodo = !addtodo;
            id.clear();
            String utitle = "";
            String ubody = "";
            entry = true;
          });
        },
        label: Text(
          "Add Todo",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
    );
  }
}
