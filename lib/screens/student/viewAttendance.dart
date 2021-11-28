import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/screens/student/studentDrawer.dart';
import 'package:attendance_dock/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentAttendanceView extends StatefulWidget {
  final String name;
  final String contact;
  final List course;

  StudentAttendanceView({this.name, this.contact, this.course});

  @override
  _StudentAttendanceViewState createState() => _StudentAttendanceViewState();
}

class _StudentAttendanceViewState extends State<StudentAttendanceView> {
  DateTime pickedDate;
  String selectedCourse;
  bool isData = false;
  List attendanceData = [];

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    attendanceData.clear();
  }

  Widget date() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple.withOpacity(0.1),
      ),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${pickedDate.day}-${pickedDate.month}-${pickedDate.year}',
                    style: GoogleFonts.abel(
                      color: Colors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: FloatingActionButton(
                onPressed: _pickDate,
                child: Icon(Icons.calendar_today),
              ),
            )
            // Icon(Icons.ac_unit_outlined),
          ],
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        pickedDate = date;
        attendanceData.clear();
      });
    }
  }

  Widget attendanceList() {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: attendanceData.length != 0
          ? ListView.builder(
              itemCount: attendanceData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AttenTile(
                  student: attendanceData[index]['student'],
                  attendance: attendanceData[index]['attendance'],
                );
              },
            )
          : Text("No data available!"),
    );
  }

  Widget dropdown() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.code,
              color: mainColor,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .80,
              child: DropdownButton(
                hint: Text('Select Course'),
                items: widget.course.map((item) {
                  return DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
                isExpanded: true,
                onChanged: (courseValue) {
                  setState(() {
                    selectedCourse = courseValue;
                    attendanceData.clear();
                  });
                  String date =
                      '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';

                  // print(selectedCourse);
                  // print(date);
                  dynamic userRef = databaseMethods.getAttendance(
                      time: date, course: selectedCourse);

                  userRef.then((value) {
                    value.documents.forEach((element) {
                      if (element['student'] == widget.name) {
                        setState(() {
                          attendanceData.add({
                            "student": element['student'],
                            "attendance": element['attendance'],
                          });
                        });
                        // print(attendanceData.toString());
                        // print(element['student']);
                        // print(element['attendance']);
                      }
                      setState(() {
                        isData = true;
                      });
                    });
                  });
                },
                value: selectedCourse,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        date(),
        dropdown(),
        isData
            ? attendanceList()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("No data available!"),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Attendance'),
        centerTitle: true,
      ),
      body: body(),
      drawer: StudentDrawer(
        name: widget.name,
        contact: widget.contact,
        course: widget.course,
      ),
    );
  }
}

class AttenTile extends StatelessWidget {
  final bool attendance;
  final String student;
  AttenTile({this.attendance, this.student});

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      student,
                      style: GoogleFonts.abel(
                        color: Colors.purple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: attendance
                          ? Colors.green.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                        child: attendance
                            ? Text(
                                "P",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "A",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
