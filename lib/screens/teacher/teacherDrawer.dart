import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/logins/stuAndTeacLogin.dart';
import 'package:attendance_dock/screens/teacher/TAttendance.dart';
import 'package:attendance_dock/screens/teacher/home.dart';
import 'package:attendance_dock/screens/teacher/tStudent.dart';
import 'package:attendance_dock/screens/teacher/viewAttendance.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeacherDrawer extends StatefulWidget {
  final String name;
  TeacherDrawer({this.name});
  @override
  _TeacherDrawerState createState() => _TeacherDrawerState();
}

class _TeacherDrawerState extends State<TeacherDrawer> {
  @override
  Widget build(BuildContext context) {
    List divName = widget.name.split(" ");
    final String letter = divName[1];
    letter.split("");
    // print(letter[0]);
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
                    child: Text(
                      letter[0],
                      style: TextStyle(
                        fontSize: 60,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Hello, ' + divName[1],
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
              FontAwesomeIcons.home,
              color: mainColor,
            ),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => Teacher(
                  name: widget.name,
                ),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.users,
              color: mainColor,
            ),
            title: Text("Students"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => TStudent(name: widget.name),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.pencilAlt,
              color: mainColor,
            ),
            title: Text("Take Attendance"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => TAttendance(
                  name: widget.name,
                ),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.bookOpen,
              color: mainColor,
            ),
            title: Text("View Attendance"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => ViewAttendance(name: widget.name),
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
                builder: (_) => StudentAndTeacher(),
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
