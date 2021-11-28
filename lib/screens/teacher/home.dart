import 'package:attendance_dock/screens/teacher/teacherDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Teacher extends StatefulWidget {
  final String name;
  Teacher({this.name});
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  // QuerySnapshot courses;
  List<Map> courses = [];
  bool isData = true;

  @override
  void initState() {
    super.initState();
    get();
    setState(() {});
  }

  get() {
    final userRef = Firestore.instance.collection('courses');
    userRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        if (element.data['teacher'] == widget.name) {
          courses.add({
            "courseCode": element.data['courseCode'],
            "courseName": element.data['courseName'],
          });

          // print(element.data['courseCode']);
          // print(element.data['courseName']);
        }
        setState(() {});
        // print(courses);

        if (value == null) {
          setState(() {
            isData = false;
          });
        }
      });
    });
  }

  Widget bodyWidget() {
    return courses != null
        ? isData
            ? ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseTile(
                    courseCode: courses[index]['courseCode'],
                    courseName: courses[index]['courseName'],
                  );
                },
              )
            : Center(child: Text('No Courses Found !'))
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teacher',
        ),
      ),
      body: bodyWidget(),
      drawer: TeacherDrawer(name: widget.name),
    );
  }
}

class CourseTile extends StatelessWidget {
  final String courseCode;
  final String courseName;
  CourseTile({this.courseCode, this.courseName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple.withOpacity(0.1),
      ),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseCode,
                    style: GoogleFonts.abel(
                      color: Colors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(courseName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
