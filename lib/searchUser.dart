import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fun.dart';

class userDetail extends StatelessWidget {
  final users;

  const userDetail({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const customAppBar(title: "User Profile"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // CircleAvatar(
            //   backgroundColor: Colors.indigo.withOpacity(0.1),
            //   radius: 50,
            //   child: Icon(Icons.account_circle, color: Colors.indigo.withOpacity(0.6),size: 100,)
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff040039).withOpacity(.15),
                      blurRadius: 99,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    customListTile(
                        users["name"], Colors.lightBlue, Icons.person),
                    customListTile(users["email"], Colors.pink, Icons.email),
                    customListTile(users["gender"], Colors.green,
                        users["gender"] == "male" ? Icons.male : Icons.female),
                    customListTile(
                      users["status"],
                      Colors.orange,
                      users["status"] == "active"
                          ? Icons.person_outline
                          : Icons.person_off_outlined,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget customListTile(String data, Color color, IconData icon) {
  return ListTile(
    title: Text(
      data,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black.withOpacity(0.6),
      ),
    ),
    leading: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color.withOpacity(0.6),
        size: 30,
      ),
    ),
  );
}
