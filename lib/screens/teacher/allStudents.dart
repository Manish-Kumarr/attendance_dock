import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AllStudents extends StatefulWidget {
  final String courseName;
  AllStudents({this.courseName});
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  String selectedCourse;
  List<List> courses = [];
  bool isData = true;
  List<Map> data = [];

  @override
  void initState() {
    super.initState();
    get();
    setState(() {});
  }

  get() {
    final userRef = Firestore.instance.collection('students');
    userRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        List<dynamic> list = element.data['course'];
        list.forEach((e) => {
              if (e == widget.courseName)
                {
                  data.add({
                    "student": element.data['fullName'],
                    "course": widget.courseName,
                    "contact": element.data['contact']
                  })
                }
            });
        setState(() {});
        if (value == null) {
          setState(() {
            isData = false;
          });
        }
      });
      // print(data[0]);
      // print(data.length);
    });
  }

  Widget bodyWidget() {
    return isData
        ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return StudentTile(
                course: data[index]['course'],
                student: data[index]['student'],
                contact: data[index]['contact'],
              );
            },
          )
        : Center(
            child: Text('No student in this course!'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        centerTitle: true,
      ),
      body: bodyWidget(),
    );
  }
}

class StudentTile extends StatelessWidget {
  final String student;
  final String course;
  final String contact;

  StudentTile({this.student, this.course, this.contact});

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('Could not launch $command');
    }
  }

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
                    student,
                    style: GoogleFonts.abel(
                      color: Colors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(course),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      // color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: FloatingActionButton(
                      heroTag: contact,
                      child: Icon(
                        Icons.call,
                      ),
                      onPressed: () {
                        customLaunch('tel:+91$contact');
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
