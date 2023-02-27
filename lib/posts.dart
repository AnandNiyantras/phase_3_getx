import 'dart:async';
import 'dart:convert';
import 'const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fun.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  TextEditingController id = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState stateTextWithIcon1 = ButtonState.idle;
  bool addpost = false;
  late bool postSuccess;
  late bool postSearch;
  List userDetails = [];
  bool entry = true;
  bool err = false;
  bool searchPost = true;
  String utitle = "";
  String ubody = "";

  onPressedIconWithText() async {
    entry = true;
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            addpost = false;
            await getdata();
            setState(
              () {
                stateTextWithIcon =
                    postSearch ? ButtonState.success : ButtonState.fail;
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

  onPressedIconWithText1() async {
    userDetails.clear();
    entry = true;
    switch (stateTextWithIcon1) {
      case ButtonState.idle:
        stateTextWithIcon1 = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            await userPost();
            setState(
              () {
                stateTextWithIcon1 =
                    postSuccess ? ButtonState.success : ButtonState.fail;
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
        await http.get(Uri.parse("$baseUrl/${id.text}/posts"), headers: header);
    userDetails.clear();
    userDetails.add(
      jsonDecode(responce.body),
    );
    if (responce.statusCode == 200) {
      if (responce.body.length > 50) {
        setState(
          () {
            postSearch = true;
            err = false;
            entry = false;
            customSnackBar("Success", "Post Added");
          },
        );
      } else {
        setState(
          () {
            postSearch = false;
            err = true;
            entry = false;
            customSnackBar("Failed", "No Post Found");
          },
        );
      }
    }
    if (responce.statusCode == 404) {
      setState(
        () {
          postSearch = false;
          err = true;
          customSnackBar("Failed", "User Not Found");
        },
      );
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print(responce.body);
    // print(userDetails[0][0]["id"]);
    // print("$baseUrl/${id.text}/posts");
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
        'body': body.text,
      },
    );
    http.Response responce = await http.post(
      Uri.parse("$baseUrl/${id.text}/posts"),
      headers: header,
      body: data,
    );
    if (responce.statusCode == 201) {
      if (responce.body.length > 50) {
        setState(() {
          postSuccess = true;
        });
        customSnackBar("Success", "Post Added Successfully");
      }
    } else if (responce.statusCode == 422) {
      setState(() {
        postSuccess = false;
      });
      customSnackBar("Failed", "Users Not Found");
    } else {
      postSuccess = false;
      customSnackBar("Failed", "Something Went Wrong");
      // print("$baseUrl${id.text}/posts");
      // print(data);
      // print(id.text);
      // print(title.text);
      // print(body.text);
      // print(responce.statusCode);
      // print(responce.body);
      // print(responce.contentLength);
    }
    FocusScope.of(context).unfocus();
  }

  final UserDetails UD = Get.put(UserDetails());

  void initState() {
    super.initState();
    UD.getUserPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const customAppBar(title: "Posts"),
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
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 80.0,
                ),
              ],
            ),
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  height: 725,
                  padding: EdgeInsets.all(15.0),
                  child: !addpost
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.search,
                                "Enter User ID", false, false, id),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: ProgressButton.icon(
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                        text: 'Search',
                                        icon: Icon(Icons.search,
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
                            const SizedBox(
                              height: 30,
                            ),
                            entry
                                ? Obx(
                                    () => UD.SearchedUserPostWithNameList
                                                .isNotEmpty
                                        ? Expanded(
                                            child: ListView.separated(
                                              itemCount: UD
                                                  .SearchedUserPostWithNameList
                                                  .length,
                                              itemBuilder: (_, int index) {
                                                return homePageCard3(
                                                  UD.SearchedUserPostWithNameList[
                                                      index]["name"],
                                                  UD.SearchedUserPostWithNameList[
                                                      index]["title"],
                                                  UD.SearchedUserPostWithNameList[
                                                      index]["body"],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SizedBox(height: 20,);
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
                                            // return ListTile(
                                            //   leading: Padding(
                                            //     padding: const EdgeInsets.only(
                                            //         right: 8.0),
                                            //     child: Text(
                                            //       userDetails[0][index]["id"]
                                            //           .toString(),
                                            //     ),
                                            //   ),
                                            //   title: Text(
                                            //     userDetails[0][index]["title"],
                                            //   ),
                                            //   subtitle: Text(
                                            //     userDetails[0][index]["body"],
                                            //   ),
                                            // );
                                            return homePageCard2(
                                              userDetails[0][index]["id"]
                                                  .toString(),
                                              userDetails[0][index]["title"],
                                              userDetails[0][index]["body"],
                                            );
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
                                    : const Center(
                                        child: CustomErrorText(
                                            textTitle: "No Post Found"),
                                      ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormFieldcomponent(Icons.account_circle,
                                  "Enter User ID", false, false, id),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormFieldcomponent(Icons.title, "Enter Title",
                                  false, false, title),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormFieldcomponent(Icons.description,
                                  "Enter Message", false, false, body),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: ProgressButton.icon(
                                    iconedButtons: {
                                      ButtonState.idle: IconedButton(
                                          text: 'Add Post',
                                          icon: Icon(Icons.post_add,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        // isExtended: true,
        icon: Icon(
          Icons.add,
          color: Colors.black.withOpacity(0.6),
        ),
        label: Text(
          "Add Post",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            addpost = !addpost;
            id.clear();
            String utitle = "";
            String ubody = "";
          });
        },
      ),
    );
  }
}
