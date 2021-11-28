import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/logins/login.dart';
import 'package:attendance_dock/screens/admin/coursePage.dart';
import 'package:attendance_dock/screens/admin/home.dart';
import 'package:attendance_dock/screens/admin/teacherPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: mainColor,
            height: MediaQuery.of(context).size.height * .18,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white54,
                  radius: 55,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset('assets/images/admin.png'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Hello, Admin',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.userPlus,
              color: mainColor,
            ),
            title: Text("Student"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => Admin(),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.userAlt,
              color: mainColor,
            ),
            title: Text("Teacher"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => TeacherPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.book,
              color: mainColor,
            ),
            title: Text("Course"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => CoursePage(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.backspace,
              color: mainColor,
            ),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => LoginPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.close,
              size: 36,
              color: mainColor,
            ),
            title: Text("Close"),
            onTap: () => {
              Navigator.of(context).pop(),
            },
          ),
        ],
      ),
    );
  }
}
