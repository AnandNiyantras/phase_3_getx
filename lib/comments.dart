import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'fun.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController body = TextEditingController();
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState stateTextWithIcon1 = ButtonState.idle;
  String errText = "";
  final baseCommentUrl = "https://gorest.co.in/public/v2/posts";

  // final basePostUrl = "https://gorest.co.in/public/v2/posts";
  List userDetails = [];
  List<dynamic> _UserComments = [];
  bool todo = false;
  bool getcomments = true;
  late bool addcomments;
  bool entry = true;
  bool err = false;
  bool searchPost = true;
  String utitle = "";
  String ubody = "";
  bool comments = false;

  onPressedIconWithText() {
    userDetails.clear();
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(
          Duration(seconds: 2),
          () async {
            await getdata();
            if (getcomments != false) {
              await getComments();
            }
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
    Response responce =
        await get(Uri.parse("$baseCommentUrl/${id.text}/"), headers: header);
    userDetails.clear();
    userDetails.add(
      jsonDecode(responce.body),
    );
    if (responce.statusCode == 200) {
      if (responce.body.length > 50) {
        setState(
          () {
            // getcomments = true;
            err = false;
            entry = false;
          },
        );
      } else {
        setState(
          () {
            getcomments = false;
            err = true;
            entry = false;
            customSnackBar("Failed", "Post Not Found");
          },
        );
      }
    }
    if (responce.statusCode == 404) {
      setState(
        () {
          getcomments = false;
          entry = false;
          err = true;
          customSnackBar("Failed", "Post Not Found");
        },
      );
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print(responce.body);
    // print("$baseUrl/${id.text}/posts");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(userDetails);
    // print(userDetails[0]['id']);
    // print(userDetails[0][0]);
    // print(userDetails[0].length);
    // print(userDetails[0][1]);
  }

  Future<void> getComments() async {
    Response responce = await get(
        Uri.parse("$baseCommentUrl/${id.text}/comments"),
        headers: header);
    _UserComments.clear();
    _UserComments.add(
      jsonDecode(responce.body),
    );
    if (responce.statusCode == 200) {
      if (responce.body.length > 50) {
        setState(
          () {
            getcomments = true;
            customSnackBar("Success", "Post And Comment Found");
          },
        );
      } else {
        getcomments = false;
        customSnackBar("Failed", "No Comment Found on Post");
      }
    }
    if (responce.statusCode == 404) {
      setState(
        () {
          getcomments = false;
          customSnackBar("Failed", "Something Went Wrong");
        },
      );
    }
    FocusScope.of(context).unfocus();
    // print(responce.statusCode);
    // print(responce.body.length);
    // print(responce.body);
    // print("$_baseURL/${id.text}/comments");
    // _UserDetails.add(
    //   jsonDecode(responce.body),
    // );
    // print(_UserComments[0]['id']);
    // print(_UserDetails[0]);
    // print(_UserDetails[1][0]['id']);

    // print(_UserDetails[0][0]);
    // print(userDetails[0].length);
    // print(_UserDetails[0][1]);
  }

  Future<void> userPost() async {
    final data = jsonEncode(
      <String, String>{
        'post_id': id.text,
        'name': name.text,
        'email': email.text,
        'body': body.text,
      },
    );
    Response responce = await post(
      Uri.parse("$baseCommentUrl/${id.text}/comments"),
      headers: header,
      body: data,
    );

    if (responce.statusCode == 201) {
      if (responce.body.length > 50) {
        addcomments = true;
        customSnackBar("Success", "Comment Added");
      }
    } else if (responce.statusCode == 422) {
      addcomments = false;
      customSnackBar("Failed", "User Not Found");
    } else {
      addcomments = false;
      customSnackBar("Failed", "Something Went Wrong");
    }
    FocusScope.of(context).unfocus();
    // print("$_baseURL/${id.text}/comments");
    // print(data);
    // print(id.text);
    // print(name.text);
    // print(email.text);
    // print(body.text);
    // print(responce.statusCode);
    // print(responce.body);
    // print(responce.contentLength);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const customAppBar(title: "Comments"),
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
                ), //BoxShadow
              ],
            ),
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  height: double.maxFinite,
                  child: !comments
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(
                              Icons.numbers,
                              "Enter Post ID",
                              false,
                              false,
                              id,
                            ),
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
                                ? const Text("")
                                : !err
                                    ? Column(
                                        children: [
                                          SingleChildScrollView(
                                            child: Container(
                                              height: 500,
                                              child: ListView.builder(
                                                itemCount: userDetails.length,
                                                itemBuilder:
                                                    (context, int index) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        height: userDetails[index]
                                                                        ["body"]
                                                                    .length <
                                                                25
                                                            ? 100
                                                            : userDetails[index]
                                                                        ["body"]
                                                                    .length *
                                                                0.65,
                                                        child: InkWell(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            HapticFeedback
                                                                .lightImpact();
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xff040039)
                                                                      .withOpacity(
                                                                          .15),
                                                                  blurRadius:
                                                                      99,
                                                                ),
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    25),
                                                              ),
                                                            ),
                                                            child: ListTile(
                                                              title: Text(
                                                                userDetails[
                                                                        index]
                                                                    ["title"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                              subtitle: Text(
                                                                userDetails[
                                                                        index]
                                                                    ["body"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      getcomments
                                                          ? Container(
                                                              height: _UserComments
                                                                      .length *
                                                                  130,
                                                              child: ListView
                                                                  .builder(
                                                                itemCount:
                                                                    _UserComments
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return InkWell(
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap: () {
                                                                      HapticFeedback
                                                                          .lightImpact();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              15),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Color(0xff040039).withOpacity(.15),
                                                                            blurRadius:
                                                                                99,
                                                                          ),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              25),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          ListTile(
                                                                        title:
                                                                            Text(
                                                                          _UserComments[0][index]
                                                                              [
                                                                              "name"],
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                        subtitle:
                                                                            Text(
                                                                          _UserComments[0][index]
                                                                              [
                                                                              "body"],
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : CustomErrorText(
                                                              textTitle:
                                                                  "No Comments Found")
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : CustomErrorText(
                                        textTitle: "No Post Found")
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.numbers,
                                "Enter Post ID", false, false, id),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(
                                Icons.person, "Enter Name", false, false, name),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.email,
                                "Enter Email Address", false, true, email),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldcomponent(Icons.description,
                                "Enter Description", false, false, body),
                            const SizedBox(
                              height: 20,
                            ),
                            //TODO BUTTON
                            // MaterialButton(
                            //   minWidth: 150,
                            //   height: 50,
                            //   color: Colors.blue,
                            //   child: const Text("Add Post"),
                            //   onPressed: () async {
                            //     await userPost();
                            //   },
                            // ),
                            Center(
                              child: ProgressButton.icon(
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                        text: 'Add Comment',
                                        icon: Icon(Icons.add_comment,
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
          Icons.add_comment,
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            comments = !comments;
            id.clear();
          });
        },
        label: Text(
          "Add Comment",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
    );
  }
}
