import 'package:attendance_dock/screens/admin/addCourse.dart';
import 'package:attendance_dock/screens/admin/adminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  QuerySnapshot courses;
  bool isData = true;

  get() {
    Firestore.instance.collection("courses").getDocuments().then((value) {
      if (value.documents.isEmpty) {
        setState(() {
          isData = false;
        });
      }
      setState(() {
        courses = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    get();
    setState(() {});
  }

  Widget bodyWidget() {
    return courses != null
        ? isData
            ? ListView.builder(
                itemCount: courses.documents.length,
                itemBuilder: (context, index) {
                  return CourseTile(
                    courseCode: courses.documents[index].data['courseCode'],
                    courseName: courses.documents[index].data['courseName'],
                    teacher: courses.documents[index].data['teacher'],
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
          'Courses',
        ),
        centerTitle: true,
      ),
      body: bodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddCourse(),
          ));
        },
      ),
      drawer: AdminDrawer(),
    );
  }
}

class CourseTile extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String teacher;
  CourseTile({this.courseCode, this.courseName, this.teacher});

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
                  Text("Teacher - $teacher")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
