import 'dart:async';

import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/services/auth.dart';
import 'package:attendance_dock/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final fieldFullName = TextEditingController();
  final fieldContact = TextEditingController();
  final fieldEmail = TextEditingController();
  final fieldPass = TextEditingController();

  String fullName, contact, email, password, selectedCourse;

  bool isLoading = false;

  AuthServices authServices = new AuthServices();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  List courses = [];
  List<Map> listCourses = [];

  void clearText() {
    fieldFullName.clear();
    fieldContact.clear();
    fieldEmail.clear();
    fieldPass.clear();
    setState(() {
      selectedCourse = null;
    });
  }

  Widget _buildFirstNameRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldFullName,
        validator: (val) => val.isEmpty ? 'Enter fullname' : null,
        onChanged: (value) {
          setState(() {
            fullName = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.people_rounded,
              color: mainColor,
            ),
            labelText: 'Full name'),
      ),
    );
  }

  Widget _buildContactRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldContact,
        validator: (val) {
          if (val.isEmpty) {
            return 'Enter phone number';
          }

          if (val.length < 10) {
            return 'Please enter 10 digit number';
          }
        },
        keyboardType: TextInputType.phone,
        onChanged: (value) {
          setState(() {
            contact = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone_android,
              color: mainColor,
            ),
            labelText: 'Contact number'),
      ),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldEmail,
        validator: (val) {
          if (val.isEmpty) {
            return 'Enter email id';
          }

          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(val)) {
            return 'Please enter a valid email Address';
          }

          return null;
        },
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail,
              color: mainColor,
            ),
            labelText: 'Email Id'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldPass,
        validator: (val) => val.length < 5 ? 'Password must be 6 letter' : null,
        keyboardType: TextInputType.text,
        obscureText: true,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: mainColor,
          ),
          labelText: 'Password',
        ),
      ),
    );
  }

  addStudent(BuildContext context) async {
    List<String> courses = [];

    for (int i = 0; i < listCourses.length; i++) {
      if (listCourses[i]['check']) {
        courses.add(listCourses[i]['course']);
      }
    }

    if (courses.length == 0) {
      SnackBar snack =
          SnackBar(content: Text('Please select atleast one course!'));
      Scaffold.of(context).showSnackBar(snack);
    }

    if (_formKey.currentState.validate() && courses.length >= 1) {
      setState(() {
        isLoading = true;
      });
      clearText();

      dynamic result =
          await authServices.signUpWithEmailAndPassword(email, password);

      if (result == null) {
        SnackBar snackBar = SnackBar(content: Text('Email already registerd!'));
        Scaffold.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      } else {
        Map<String, dynamic> userInfo = {
          "fullName": fullName,
          "contact": contact,
          "email": email,
          "course": courses,
        };

        databaseMethods.uploadStudentinfo(userInfo);

        for (int i = 0; i < listCourses.length; i++) {
          if (listCourses[i]['check']) {
            setState(() {
              listCourses[i]['check'] = false;
            });
          }
        }

        setState(() {
          isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text('Student Added!'));
        Scaffold.of(context).showSnackBar(snackBar);
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
              addStudent(context);
            },
            child: Text(
              "Add Student",
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

  final userRef = Firestore.instance.collection('courses');

  get() {
    userRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        setState(() {
          listCourses.add({
            "course": element.data['courseCode'],
            "check": false,
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  Widget couseList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Text(
              "Add Courses :",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
          ),
          listCourses.length == 0
              ? Align(child: Text("No course available !"))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: listCourses.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple.withOpacity(0.1),
                      ),
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: listCourses[index]['check'],
                            onChanged: (val) {
                              setState(() {
                                listCourses[index]['check'] =
                                    !listCourses[index]['check'];
                              });
                              // print(listCourses);
                            },
                          ),
                          Text(listCourses[index]['course']),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  Widget formContainer() {
    return Column(
      children: [
        _buildFirstNameRow(),
        _buildContactRow(),
        _buildEmailRow(),
        _buildPasswordRow(),
        couseList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.90,
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
                ),
              ),
      ),
    );
  }
}
