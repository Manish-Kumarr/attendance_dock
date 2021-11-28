import 'package:attendance_dock/screens/admin/addTeacher.dart';
import 'package:attendance_dock/screens/admin/adminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  QuerySnapshot teachers;
  bool isData = true;
  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    Firestore.instance.collection("teachers").getDocuments().then((value) {
      if (value.documents.isEmpty) {
        setState(() {
          isData = false;
        });
      }

      setState(() {
        teachers = value;
      });
    });
  }

  Widget bodyWidget() {
    return teachers != null
        ? isData
            ? ListView.builder(
                itemCount: teachers.documents.length,
                itemBuilder: (context, index) {
                  return TeacherTile(
                    fullName: teachers.documents[index].data['fullName'],
                    contact: teachers.documents[index].data['contact'],
                    email: teachers.documents[index].data['email'],
                  );
                },
              )
            : Center(child: Text('No Teacher Found !'))
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teachers',
        ),
        centerTitle: true,
      ),
      body: bodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddTeacher(),
          ));
        },
      ),
      drawer: AdminDrawer(),
    );
  }
}

class TeacherTile extends StatelessWidget {
  final String fullName;
  final String contact;
  final String email;
  TeacherTile({this.contact, this.email, this.fullName});

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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: FloatingActionButton(
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

// Text(fullName),
// Text(email),
// Text(contact),
// Divider(),
