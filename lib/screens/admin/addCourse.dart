import 'dart:async';
import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  final fieldCourseCode = TextEditingController();
  final fieldCourseName = TextEditingController();

  String courseCode, courseName, selectedTeacher;

  bool isLoading = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    // get();
    super.initState();
  }

  void clearText() {
    fieldCourseCode.clear();
    fieldCourseName.clear();
    setState(() {
      selectedTeacher = null;
    });
  }

  Widget _buildCourseCodeRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldCourseCode,
        validator: (val) => val.isEmpty ? 'Enter course code' : null,
        onChanged: (value) {
          setState(() {
            courseCode = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.code,
              color: mainColor,
            ),
            labelText: 'Course code'),
      ),
    );
  }

  Widget _buildCourseNameRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldCourseName,
        validator: (val) => val.isEmpty ? 'Enter course name' : null,
        onChanged: (value) {
          setState(() {
            courseName = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.text_fields,
              color: mainColor,
            ),
            labelText: 'Course name'),
      ),
    );
  }

  addCourse(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> courseInfo = {
        "courseCode": courseCode,
        "courseName": courseName,
        "teacher": selectedTeacher,
      };
      dynamic result = await databaseMethods.uploadCourseInfo(courseInfo);

      if (result != null) {
        Timer(Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
          SnackBar snackBar = SnackBar(content: Text('Course Added!'));
          Scaffold.of(context).showSnackBar(snackBar);
          clearText();
        });
      }
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.2 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 60, top: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              addCourse(context);
            },
            child: Text(
              "Add Course",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget formContainer() {
    return Column(
      children: [
        _buildCourseCodeRow(),
        _buildCourseNameRow(),
        // _dropdown(),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("teachers").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text("Loading...");
            else {
              List<DropdownMenuItem> teachersList = [];
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                DocumentSnapshot snap = snapshot.data.documents[i];
                String fullName = snap.data['fullName'];
                teachersList.add(
                  DropdownMenuItem(
                    child: Text(fullName),
                    value: fullName,
                  ),
                );
              }
              return Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.userAlt,
                      color: mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .80,
                      child: DropdownButtonFormField(
                        validator: (val) =>
                            val == null ? "Please select teacher" : null,
                        hint: Text('Select Teacher'),
                        items: teachersList,
                        isExpanded: true,
                        onChanged: (teacherValue) {
                          setState(() {
                            selectedTeacher = teacherValue;
                          });
                        },
                        value: selectedTeacher,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: formContainer(),
                      ),
                      Spacer(),
                      _buildLoginButton(context),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final String name;
//   SearchTile({this.name});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(name),
//     );
//   }
// }
