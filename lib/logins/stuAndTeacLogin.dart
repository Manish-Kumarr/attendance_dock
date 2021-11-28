import 'dart:async';
import 'package:attendance_dock/logins/login.dart';
import 'package:attendance_dock/screens/student/home.dart';
import 'package:attendance_dock/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../screens/teacher/home.dart';

class StudentAndTeacher extends StatefulWidget {
  @override
  _StudentAndTeacherState createState() => _StudentAndTeacherState();
}

class _StudentAndTeacherState extends State<StudentAndTeacher> {
  final _formKey = GlobalKey<FormState>();
  final fieldText = TextEditingController();
  final fieldPass = TextEditingController();

  String email, password, valueChoose;
  List list = ["Teacher", "Student"];
  bool isLoading = false;

  AuthServices authServices = new AuthServices();

  void clearText() {
    fieldText.clear();
    fieldPass.clear();
    setState(() {
      valueChoose = null;
    });
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'ATTENDANCE DOCK',
            style: GoogleFonts.architectsDaughter(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: fieldText,
        validator: (val) => val.isEmpty ? 'Enter username' : null,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.people_rounded,
              color: mainColor,
            ),
            labelText: 'Username'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
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

  Widget _buildDropdown() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.60,
      child: DropdownButton(
        hint: Text('Login Type'),
        isExpanded: true,
        iconSize: 30,
        value: valueChoose,
        focusColor: Colors.pink,
        onChanged: (newValue) {
          FocusScope.of(context).unfocus();
          setState(() {
            valueChoose = newValue;
          });
        },
        items: list.map((item) {
          return DropdownMenuItem(
            child: Text(item),
            value: item,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "User Login",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                _buildDropdown(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Admin Login '),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Click Here",
                          style: TextStyle(
                            color: Colors.purple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.2 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20, top: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                bool check = true;
                if (valueChoose == null) {
                  SnackBar snackBar =
                      SnackBar(content: Text('Please select login type!'));
                  Scaffold.of(context).showSnackBar(snackBar);
                  return;
                }

                var res =
                    await authServices.signInEmailAndPass(email, password);

                if (res == "Invalid Password!") {
                  SnackBar snackBar =
                      SnackBar(content: Text('Envalid Password!'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else if (res == "User this email doesn't exist!") {
                  SnackBar snackBar = SnackBar(
                      content: Text('User this email doesn\'t exist!'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else if (res == "Too many attempts. Try again later!") {
                  SnackBar snackBar = SnackBar(
                      content: Text('Too many attempts. Try again later!'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  if (valueChoose == "Teacher") {
                    final userRef = Firestore.instance.collection('teachers');
                    userRef.getDocuments().then((value) {
                      value.documents.forEach((element) {
                        if (element.data['email'] == email) {
                          setState(() {
                            check = false;
                          });
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return Teacher(
                              name: element.data['fullName'],
                            );
                          }));
                        }
                      });

                      check
                          ? Timer(Duration(seconds: 1), () {
                              SnackBar snackBar =
                                  SnackBar(content: Text('Change to student!'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            })
                          : null;
                    });
                  } else if (valueChoose == "Student") {
                    final userRef = Firestore.instance.collection('students');
                    userRef.getDocuments().then((value) {
                      value.documents.forEach((element) {
                        if (element.data['email'] == email) {
                          setState(() {
                            check = false;
                          });
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return Student(
                              name: element.data['fullName'],
                              contact: element.data['contact'],
                              course: element.data['course'],
                            );
                          }));
                        }
                      });
                      check
                          ? Timer(Duration(seconds: 0), () {
                              SnackBar snackBar =
                                  SnackBar(content: Text('Change to teacher!'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            })
                          : null;
                    });
                  }
                }
              }
            },
            child: Text(
              "Login",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f3f7),
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) {
          return Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(70),
                      bottomRight: const Radius.circular(70),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLogo(),
                    Form(
                      key: _formKey,
                      child: _buildContainer(context),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
