import 'package:attendance_dock/constants.dart';
import 'package:attendance_dock/screens/student/studentDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Student extends StatefulWidget {
  final String name;
  final String contact;
  final List course;

  Student({this.name, this.contact, this.course});

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  void initState() {
    super.initState();
  }

  Widget subject() {
    return ListView.builder(
      itemCount: widget.course.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple.withOpacity(0.1),
          ),
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            '${index + 1}. ${widget.course[index]}',
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student',
        ),
      ),
      body: Column(
        children: [
          Container(
            // width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple.withOpacity(0.1),
            ),
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.abel(
                        color: Colors.purple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.contact),
                    Text(widget.course.toString()),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "↓ My courses ↓",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: mainColor,
              fontSize: 20,
            ),
          ),
          subject(),
        ],
      ),

      // Center(
      //   child: Column(
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(10),
      //           color: Colors.purple.withOpacity(0.1),
      //         ),
      //         margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Column(
      //                 children: [
      //                   Text(
      //                     widget.name,
      //                     style: GoogleFonts.abel(
      //                       color: Colors.purple,
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   Text(widget.contact),
      //                   Text(widget.course.toString()),
      //                   subject(),
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //       // Text(name),
      //       // Text(contact),
      //       // Text(course.toString()),
      //     ],
      //   ),
      // ),
      drawer: StudentDrawer(
        name: widget.name,
        contact: widget.contact,
        course: widget.course,
      ),
    );
  }
}
