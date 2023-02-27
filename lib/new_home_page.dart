import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:phase_3_getx/new_simple_login_page.dart';
import 'searchUser.dart';
import 'comments.dart';
import 'const.dart';
import 'deleteUser.dart';
import 'new_all_user.dart';
import 'posts.dart';
import 'todos.dart';
import 'updateUser.dart';
import 'fun.dart';

getterData() async {
  List Data = [];
  var temp = await getData();
  Data.add(json.decode(temp).split(","));
  print(Data[0][0]["name"]);
    // globUserDetail['name'] = Data[0]['name'];
    // // globUserDetail['id'] = Data[0]['id']!;
    // globUserDetail['email'] = Data[0]['email'];
    // globUserDetail['status'] = Data[0]['status'];
    // globUserDetail['gender'] = Data[0]['gender'];
    print(globUserDetail);
  // if (globUserDetail['name']!.length > 0) {
  //   // Map decodeData = json.decode(Data);
  //   globUserDetail['name'] = decodeData['name']!;
  //   globUserDetail['email'] = decodeData['email']!;
  //   globUserDetail['status'] = decodeData['status']!;
  //   globUserDetail['gender'] = decodeData['gender']!;
  // }
}

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;
  List userDetails = [];
  String Data = "";
  String uName = "";
  String uid = "";
  String uemail = "";
  String ugender = "";
  String status = "";
  final UserDetails UD = Get.put(UserDetails());

  @override
  void initState() {
    print("home page reached");
    super.initState();
    print("getting data");
    getterData();
    // if (globUserDetail['name']!.length > 0) {
    //   Map<String, String> decodeData = jsonDecode(Data);
    //   globUserDetail['name'] = decodeData['name']!;
    //   globUserDetail['email'] = decodeData['email']!;
    //   globUserDetail['status'] = decodeData['status']!;
    //   globUserDetail['gender'] = decodeData['gender']!;
    // }
    UD.getUser();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: -30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(_w / 17, _w / 20, 0, _w / 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    globUserDetail['name']!.isNotEmpty ? Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (globUserDetail['name']!.isNotEmpty) {
                              Get.to(() => userDetail(users: globUserDetail));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: CircleAvatar(
                              radius: _w / 25,
                              backgroundColor: Colors.indigo.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: Colors.indigo.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            globUserDetail["name"]!,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black.withOpacity(.6),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ) : const Text(""),
                  ],
                ),
              ),
              homePageCardsGroup(
                Color(0xfff37736),
                Icons.list,
                'User List',
                context,
                NewAllUser(),
                Color(0xffFF6D6D),
                Icons.task_alt,
                "Get User's TODO",
                Todos(),
              ),
              homePageCardsGroup(
                  Colors.lightGreen,
                  Icons.delete_forever_rounded,
                  'Delete User',
                  context,
                  DeleteUser(),
                  Color(0xffffa700),
                  Icons.update,
                  'Update User Info',
                  UpdateUser()),
              homePageCardsGroup(
                  Color(0xff63ace5),
                  Icons.post_add,
                  "Get User's Post",
                  context,
                  Posts(),
                  Color(0xfff37736),
                  Icons.comment,
                  "Get User's Comments",
                  Comments()),
              SizedBox(height: _w / 20),
            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, _w / 7.5, _w / 17, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setIsLogged(false);
                    HapticFeedback.lightImpact();
                    Get.off(newLogin());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: GestureDetector(
                        onTap: (() {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              title: Text(alertTitle),
                              content: Text(alertSignoutText),
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
                                    setIsLogged(false);
                                    Get.to(() => newLogin());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45.0),
                                        color: Colors.purple.shade700),
                                    padding: const EdgeInsets.all(14),
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        child: Container(
                          height: _w / 9,
                          width: _w / 9,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.05),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.logout,
                              size: _w / 18,
                              color: Colors.black.withOpacity(.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Blur the Status bar
          blurTheStatusBar(context),
        ],
      ),
    );
  }

  Widget homePageCardsGroup(
      Color color,
      IconData icon,
      String title,
      BuildContext context,
      Widget route,
      Color color2,
      IconData icon2,
      String title2,
      Widget route2) {
    double _w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: _w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(color, icon, title, context, route),
          homePageCard(color2, icon2, title2, context, route2),
        ],
      ),
    );
  }

  Widget homePageCard(Color color, IconData icon, String title,
      BuildContext context, Widget route) {
    double _w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.lightImpact();
            Get.to(() => route);
          },
          child: Container(
            padding: EdgeInsets.all(15),
            height: _w / 2,
            width: _w / 2.4,
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
                SizedBox(),
                Container(
                  height: _w / 7,
                  width: _w / 7,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color.withOpacity(.6),
                    size: _w / 12,
                  ),
                ),
                Text(
                  title,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(.5),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blurTheStatusBar(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          height: _w / 18,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class RouteWhereYouGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 50,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(.5),
        title: Text(
          'EXAMPLE  PAGE',
          style: TextStyle(
              color: Colors.black.withOpacity(.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black.withOpacity(.8),
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
