import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/services/auth.dart';
import 'package:attendance_dock/services/database.dart';
import 'package:flutter/material.dart';

class AddTeacher extends StatefulWidget {
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final _formKey = GlobalKey<FormState>();
  final fieldFullName = TextEditingController();
  final fieldContact = TextEditingController();
  final fieldEmail = TextEditingController();
  final fieldPass = TextEditingController();

  String fullName, contact, email, password;

  AuthServices authServices = new AuthServices();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;

  void clearText() {
    fieldFullName.clear();
    fieldContact.clear();
    fieldEmail.clear();
    fieldPass.clear();
  }

  Widget _buildFirstNameRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: TextFormField(
        controller: fieldFullName,
        validator: (val) => val.isEmpty ? 'Enter full name' : null,
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

  addTeacher(BuildContext context) async {
    if (_formKey.currentState.validate()) {
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
        };
        setState(() {
          isLoading = false;
        });
        databaseMethods.uploadTeacherinfo(userInfo);
        SnackBar snackBar = SnackBar(content: Text('Teacher Added!'));
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
              addTeacher(context);
            },
            child: Text(
              "Add Teacher",
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
        _buildFirstNameRow(),
        _buildContactRow(),
        _buildEmailRow(),
        _buildPasswordRow(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Teacher"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => isLoading
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
              ),
      ),
    );
  }
}
