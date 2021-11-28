import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/logins/stuAndTeacLogin.dart';
import 'package:attendance_dock/screens/student/home.dart';
import 'package:attendance_dock/screens/student/viewAttendance.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentDrawer extends StatefulWidget {
  final String name;
  final String contact;
  final List course;
  StudentDrawer({this.name, this.contact, this.course});

  @override
  _StudentDrawerState createState() => _StudentDrawerState();
}

class _StudentDrawerState extends State<StudentDrawer> {
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
                builder: (_) => Student(
                  name: widget.name,
                  contact: widget.contact,
                  course: widget.course,
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
                builder: (_) => StudentAttendanceView(
                  name: widget.name,
                  contact: widget.contact,
                  course: widget.course,
                ),
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
              Navigator.of(context).push(MaterialPageRoute(
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
