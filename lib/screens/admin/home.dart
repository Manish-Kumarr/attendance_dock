import 'package:attendance_dock/screens/admin/addStudent.dart';
import 'package:attendance_dock/screens/admin/adminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

final userRef = Firestore.instance.collection('students');

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  QuerySnapshot students;
  bool isData = true;

  @override
  void initState() {
    super.initState();
    get();
    setState(() {});
  }

  get() {
    Firestore.instance.collection("students").getDocuments().then((value) {
      if (value.documents.isEmpty) {
        setState(() {
          isData = false;
        });
      }
      setState(() {
        students = value;
      });
    });
  }

  Widget bodyWidget() {
    return students != null
        ? isData
            ? ListView.builder(
                itemCount: students.documents.length,
                itemBuilder: (context, index) {
                  return StudentTile(
                    fullName: students.documents[index].data['fullName'],
                    contact: students.documents[index].data['contact'],
                    email: students.documents[index].data['email'],
                    courses: students.documents[index].data['course'],
                  );
                },
              )
            : Center(child: Text('No Student Found !'))
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students',
        ),
        centerTitle: true,
      ),
      body: bodyWidget(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddStudent(),
          ));
        },
      ),
      drawer: AdminDrawer(),
    );
  }
}

class StudentTile extends StatelessWidget {
  final String fullName;
  final String contact;
  final String email;
  final List courses;
  StudentTile({this.contact, this.email, this.fullName, this.courses});

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
                    fullName,
                    style: GoogleFonts.abel(
                      color: Colors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(courses.toString()),
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
                      heroTag: 'con1',
                      child: Icon(
                        Icons.call,
                      ),
                      onPressed: () {
                        customLaunch('tel:+91$contact');
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: FloatingActionButton(
                      heroTag: 'mail',
                      child: Icon(Icons.mail),
                      onPressed: () {
                        customLaunch('mailto:$email');
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
