import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/screens/teacher/allStudents.dart';
import 'package:attendance_dock/screens/teacher/teacherDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TStudent extends StatefulWidget {
  final String name;
  TStudent({this.name});
  @override
  _TStudentState createState() => _TStudentState();
}

class _TStudentState extends State<TStudent> {
  String selectedCourse;
  List<DropdownMenuItem> courses = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    get();
  }

  get() {
    final userRef = Firestore.instance.collection('courses');
    userRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        if (element.data['teacher'] == widget.name) {
          String code = element.data['courseCode'];
          courses.add(
            DropdownMenuItem(
              child: Text(code),
              value: code,
            ),
          );
        }
        setState(() {});
        // if (value == null) {
        //   // setState(() {
        //   //   isData = false;
        //   // });
        // }
      });
    });
  }

  Widget body() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.code,
              color: mainColor,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .80,
              child: DropdownButtonFormField(
                // validator: (val) => val == null ? "Please select course" : null,
                hint: Text('Select Course'),
                items: courses,
                isExpanded: true,
                onChanged: (courseValue) {
                  setState(() {
                    selectedCourse = courseValue;
                  });

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return AllStudents(
                      courseName: selectedCourse,
                    );
                  }));
                },
                value: selectedCourse,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student'),
        centerTitle: true,
      ),
      drawer: TeacherDrawer(
        name: widget.name,
      ),
      body: body(),
    );
  }
}
