import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'searchUser.dart';
import 'fun.dart';
import 'package:get/get.dart';

class NewAllUser extends StatefulWidget {
  const NewAllUser({Key? key}) : super(key: key);

  @override
  State<NewAllUser> createState() => _NewAllUserState();
}

class _NewAllUserState extends State<NewAllUser> {
  final UserDetails UD = Get.put(UserDetails());
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false) {
      setState(
        () {
          _isLoadMoreRunning = true;
        },
      );
      UD.increment();
      UD.getUser();
      setState(
        () {
          _isLoadMoreRunning = false;
        },
      );
    }
  }

  void _firstLoad() async {
    setState(
      () {
        _isFirstLoadRunning = true;
      },
    );

    UD.getUser();

    setState(
      () {
        _isFirstLoadRunning = false;
      },
    );
  }

  late ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
        elevation: 13.0,
        title: Text(
          "User Details",
          style: TextStyle(color: Colors.black.withOpacity(.6), fontSize: 20.0),
        ),
      ),
      body: Obx(
        () => UD.length() == 0
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15.0),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: _controller,
                        itemCount: UD.length(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => userDetail(users: _posts[index]),));
                              // Get.testMode = true;
                              Get.to(() =>
                                  userDetail(users: UD.UserDetailsList[index]));
                            },
                            child: AnimationConfiguration.staggeredList(
                              position: index,
                              delay: const Duration(milliseconds: 100),
                              child: SlideAnimation(
                                horizontalOffset: 30,
                                verticalOffset: 300,
                                duration: const Duration(milliseconds: 2500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: FlipAnimation(
                                  flipAxis: FlipAxis.y,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  duration: const Duration(milliseconds: 3000),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    height: 100,
                                    decoration: BoxDecoration(
                                      // color: Colors.indigo.withOpacity(0.09),
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 40,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                UD.UserDetailsList[index]
                                                    ["name"],
                                                // posts[index]["name"],
                                                style: const TextStyle(
                                                  fontSize: 17.0,
                                                ),
                                              ),
                                              subtitle: Text(
                                                UD.UserDetailsList[index]
                                                    ["email"],
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Card(
                                                  elevation: 10.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                  shadowColor: Colors.black,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 17.0,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 40,
                      ),
                      color: Colors.amber,
                      child: const Center(
                        child: Text(
                          'You have fetched all of the content',
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final UserDetails UD = Get.put(UserDetails());

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black.withOpacity(0.6),
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    UD.searchUser(query);
    print(UD.err.value);

    return Obx(
      () => UD.dataFetched.value != 100
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : UD.err.value
              ? CustomErrorText(textTitle: "No result found for '$query'")
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: AnimationLimiter(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(15.0),
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: UD.SearchedUserDetailsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => userDetail(users: _posts[index]),));
                                // Get.testMode = true;
                                Get.to(
                                  () => userDetail(
                                    users: UD.SearchedUserDetailsList[index],
                                  ),
                                );
                              },
                              child: AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(milliseconds: 100),
                                child: SlideAnimation(
                                  horizontalOffset: 30,
                                  verticalOffset: 300,
                                  duration: const Duration(milliseconds: 2500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FlipAnimation(
                                    flipAxis: FlipAxis.y,
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    duration:
                                        const Duration(milliseconds: 3000),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      height: 100,
                                      decoration: BoxDecoration(
                                        // color: Colors.indigo.withOpacity(0.09),
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 40,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  UD.SearchedUserDetailsList[
                                                      index]["name"],
                                                  style:
                                                      TextStyle(fontSize: 17.0),
                                                ),
                                                subtitle: Text(
                                                  UD.SearchedUserDetailsList[
                                                      index]["email"],
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                trailing: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Card(
                                                    elevation: 10.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    shadowColor: Colors.black,
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 17.0,
                                                        color: Colors.indigo,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchedUserID = [];
    List<String> searchedUserName = [];
    List<String> searchedUserGender = [];
    List<String> searchedUserEmail = [];
    List<String> searchedUserStatus = [];
    for (var i in UD.UserDetailsList) {
      if (searchedUserID.contains(i['id'].toString())) {
        continue;
      } else if (i['name'].toLowerCase().contains(query.toLowerCase())) {
        searchedUserID.add(i["id"].toString());
        searchedUserName.add(i["name"]);
        searchedUserEmail.add(i["email"]);
        searchedUserGender.add(i["gender"]);
        searchedUserStatus.add(i["status"]);
      }
    }
    return query.isNotEmpty
        ? searchedUserID.isNotEmpty
            ? ListView.builder(
                itemCount: searchedUserID.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => userDetail(users: _posts[index]),));
                      // Get.testMode = true;
                      Get.to(
                        () => userDetail(
                          users: {
                            'name': searchedUserName[index],
                            'id': searchedUserID[index],
                            'email': searchedUserEmail[index],
                            'gender': searchedUserGender[index],
                            'status': searchedUserStatus[index],
                          },
                        ),
                      );
                    },
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        horizontalOffset: 30,
                        verticalOffset: 300,
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FlipAnimation(
                          flipAxis: FlipAxis.y,
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 3000),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 100,
                            decoration: BoxDecoration(
                              // color: Colors.indigo.withOpacity(0.09),
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        searchedUserName[index],
                                        // posts[index]["name"],
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      subtitle: Text(
                                        searchedUserEmail[index],
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Card(
                                          elevation: 10.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          shadowColor: Colors.black,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 17.0,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  "Click Search to get all the results",
                  style: TextStyle(fontSize: 22.0),
                ),
              )
        : const Text(
            "",
          );
  }
}
