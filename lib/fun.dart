import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'const.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

//Shared Preferences
Future<bool> setIsLogged(bool b) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setBool("isLogged", b);
}

Future<bool> getIsLogged() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLogged") ?? false;
}

Future<bool> setData(String data) async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString("Data", data);
}

Future<String> getData() async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("Data") ?? " ";
}

//Text
class customAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const customAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      // elevation: 10.0,
      title: Text(
        title,
        style: TextStyle(color: Colors.black.withOpacity(.6), fontSize: 20.0),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomErrorText extends StatelessWidget {
  const CustomErrorText({Key? key, required this.textTitle}) : super(key: key);
  final textTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        textTitle,
        style: const TextStyle(
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black,
              offset: Offset(0.0, 0.0),
            ),
          ],
          fontSize: 40.0,
          color: Colors.indigo,
          fontFamily: "Lora",
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }
}

class customTextFormField extends StatelessWidget {
  TextEditingController tdc;
  String hintText;
  String labelText;

  customTextFormField(
      {required this.tdc, required this.hintText, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: tdc,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.black54,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.black54,
            width: 2.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.black54,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

Widget TextFormFieldcomponent(IconData icon, String hintText, bool isPassword,
    bool isEmail, TextEditingController tec) {
  // Size size = Size(411.4, 867.4);
  return Container(
    height: size.height / 14,
    width: size.width / 1.25,
    alignment: Alignment.center,
    padding: EdgeInsets.only(right: size.width / 30),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      controller: tec,
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.black.withOpacity(.6),
      ),
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black.withOpacity(.6),
          size: 23,
        ),
        border: InputBorder.none,
        hintMaxLines: 1,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18,
          color: Colors.black.withOpacity(.6),
        ),
      ),
    ),
  );
}

Widget homePageCard(
  Color color,
  String id,
  String userName,
  String email,
  String gender,
  String status,
) {
  return InkWell(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Icon(Icons.numbers),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(id),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.account_circle),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(userName),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.email),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(email),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon((gender == "male") ? Icons.male : Icons.female),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(gender),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon((status == "active")
                  ? Icons.outbond_outlined
                  : Icons.highlight_off_sharp),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(status),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}

Widget homePageCard2(
  String id,
  String title,
  String body,
) {
  return InkWell(
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
        child: ListTile(
          leading: Text(id),
          title: Text(
            title,
            textAlign: TextAlign.justify,
          ),
          subtitle: Text(
            body,
            textAlign: TextAlign.justify,
          ),
        )),
  );
}

Widget homePageCard3(
  String name,
  String title,
  String body,
) {
  return InkWell(
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
            ListTile(
              title: Text(name),
            ),
            ListTile(
              title: Text(
                "$title",
                textAlign: TextAlign.justify,
              ),
              subtitle: Text(
                body,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        )),
  );
}

SnackbarController customSnackBar(
  String title,
  String subtitle,
) {
  bool temp = title == "Success";
  Color color = title == "Success" ? Colors.green : Colors.red;
  return Get.snackbar(
    title,
    subtitle,
    titleText: Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    ),
    messageText: Text(
      subtitle,
      style: TextStyle(
        fontSize: 15.0,
        color: color,
        fontStyle: FontStyle.italic,
      ),
    ),
    icon: Icon(
      temp ? Icons.task_alt : Icons.error,
      color: color,
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color.withOpacity(0.2),
    barBlur: 10.0,
    borderRadius: 20,
    margin: EdgeInsets.all(15),
    colorText: color,
    overlayBlur: 1.5,
    duration: Duration(seconds: 3),
    forwardAnimationCurve: Curves.decelerate,
  );
}

class UserDetails extends GetConnect {
  List UserDetailsList = [].obs;
  List SearchedUserDetailsList = [].obs;
  List SearchedUserPostList = [].obs;
  List SearchedUserPostWithNameList = [].obs;
  List SearchedUserTodoList = [].obs;
  List SearchedUserTodoWithNameList = [].obs;
  var _page = 1.obs;
  final err = false.obs;
  final dataFetched = false.obs;

  increment() => _page++;

  length() => UserDetailsList.length;

  Future<void> getUser() async {
    http.Response res = await http.get(Uri.parse(
        "https://gorest.co.in/public/v2/users?page=$_page&per_page=100"));
    if (res.statusCode == 200) {
      UserDetailsList.addAll(json.decode(res.body));
    }
  }

  Future<void> searchUser(String query) async {
    SearchedUserDetailsList.clear();
    err.value = false;
    http.Response res = await http
        .get(Uri.parse("https://gorest.co.in/public/v2/users?name=$query"));
    SearchedUserDetailsList.addAll(json.decode(res.body));
    dataFetched.value = true;
    if (res.statusCode == 200) {
      if (res.body.length > 10) {
        err.value = false;
        dataFetched.value = true;
      } else {
        err.value = true;
        dataFetched.value = true;
      }
    }
    print(err.value);
    print(res.statusCode);
    print(res.body);
  }

  Future<void> getUserPost() async {
    print("inside getUserPOst");
    http.Response res = await http.get(
        Uri.parse("https://gorest.co.in/public/v2/posts?page=1&per_page=100"));
    if (res.statusCode == 200) {
      SearchedUserPostList.addAll(
        json.decode(res.body),
      );
      postUserName();
    }
  }

  Future<void> getUserTodo() async {
    print("inside getUserPOst");
    http.Response res = await http.get(
        Uri.parse("https://gorest.co.in/public/v2/todos?page=1&per_page=100"));
    if (res.statusCode == 200) {
      SearchedUserTodoList.addAll(
        json.decode(res.body),
      );
      todoUserName();
    }
  }

  postUserName() async {
    if (UserDetailsList.isEmpty) {
      await getUser();
    }
    for (var i in SearchedUserPostList) {
      for (var j in UserDetailsList) {
        if (i["user_id"] == j["id"]) {
          SearchedUserPostWithNameList.add(
            {
              'name': j["name"],
              'title': i["title"],
              "body": i["body"],
            },
          );
        } else {
          SearchedUserPostWithNameList.add(
            {
              'name': "No Username",
              'title': i["title"],
              "body": i["body"],
            },
          );
        }
      }
    }
  }

  todoUserName() async {
    if (UserDetailsList.isEmpty) {
      await getUser();
    }
    for (var i in SearchedUserTodoList) {
      for (var j in UserDetailsList) {
        if (i["user_id"] == j["id"]) {
          SearchedUserTodoWithNameList.add(
            {
              'name': j["name"],
              'title': i["title"],
              'due_on': i["due_on"],
            },
          );
        } else {
          SearchedUserTodoWithNameList.add(
            {
              'name': "No Username",
              'title': i["title"],
              'due_on': i["due_on"],
              'status': i["status"],
            },
          );
        }
      }
    }
  }
}
