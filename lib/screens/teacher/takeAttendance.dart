import 'dart:async';
import 'package:attendance_dock/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/database.dart';

class TakeAttendance extends StatefulWidget {
  final String courseName;
  TakeAttendance({this.courseName});
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  String selectedCourse;
  List<List> courses = [];
  bool isData = true;
  List<Map> data = [];
  bool isLoading = false;
  DateTime pickedDate;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    super.initState();
    setState(() {
      data.clear();
    });
    get();
    setState(() {});
    pickedDate = DateTime.now();
    print(data);
    // print(pickedDate.day);
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
                    "contact": element.data['contact'],
                    "attendance": false,
                  })
                }
            });
        // print(data);
        setState(() {});
      });
      // print(data[0]);
      // print(data.length);
    });
  }

  Widget bodyWidget(BuildContext context) {
    return Column(
      children: [
        isData
            ? ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
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
                                  data[index]['student'],
                                  style: GoogleFonts.abel(
                                    color: Colors.purple,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(data[index]['course']),
                                // Text(data[index]['attendance']),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    data[index]['attendance'] =
                                        !data[index]['attendance'];
                                  });
                                  // print(data);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: data[index]['attendance']
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "P",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: !data[index]['attendance']
                                          ? mainColor
                                          : Colors.white,
                                    ),
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    data[index]['attendance'] =
                                        !data[index]['attendance'];
                                  });
                                  // print(data);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: !data[index]['attendance']
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "A",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: !data[index]['attendance']
                                          ? Colors.white
                                          : mainColor,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Center(
                child: Text('No student in this course!'),
              ),
        Spacer(),
        button(context),
      ],
    );
  }

  takeAttendance(BuildContext context) async {
    Timer(Duration(seconds: 1), () {
      SnackBar snackBar = SnackBar(content: Text('Attendance marked!'));
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {});
    });

    String date = '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';

    for (int i = 0; i < data.length; i++) {
      Map<String, dynamic> attendanceInfo = {
        "student": data[i]['student'],
        "course": data[i]['course'],
        "contact": data[i]['contact'],
        "attendance": data[i]['attendance']
      };
      // dynamic result =

      await databaseMethods.uploadAttendance(
          course: data[i]['course'], time: date, attendanceMap: attendanceInfo);
    }
    Navigator.of(context).pop();
  }

  Widget button(BuildContext context) {
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
              takeAttendance(context);
            },
            child: Text(
              "Submit",
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
      appBar: AppBar(
        title: Text(widget.courseName),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return !isLoading
              ? bodyWidget(context)
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

// class StudentTile extends StatefulWidget {
//   final String student;
//   final String course;
//   final String contact;
//   bool att;

//   StudentTile({this.student, this.course, this.contact, this.att});

//   @override
//   _StudentTileState createState() => _StudentTileState();
// }

// class _StudentTileState extends State<StudentTile> {
//   bool colorP = false;
//   bool colorA = true;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.purple.withOpacity(0.1),
//       ),
//       margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.student,
//                     style: GoogleFonts.abel(
//                       color: Colors.purple,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(widget.course),
//                   Text(widget.att.toString()),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       colorP = !colorP;
//                       colorA = !colorA;
//                       widget.att = !widget.att;

//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(right: 20),
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       color: colorP
//                           ? Colors.green.withOpacity(0.5)
//                           : Colors.purple.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: Center(
//                         child: Text(
//                       "P",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: !colorP ? mainColor : Colors.white,
//                       ),
//                     )),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       widget.att = !widget.att;
//                       colorA = !colorA;
//                       colorP = !colorP;
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(right: 20),
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       color: colorA
//                           ? Colors.red.withOpacity(0.5)
//                           : Colors.purple.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: Center(
//                         child: Text(
//                       "A",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: colorA ? Colors.white : mainColor,
//                       ),
//                     )),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
