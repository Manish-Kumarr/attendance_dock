import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadTeacherinfo(userMap) {
    Firestore.instance.collection("teachers").add(userMap);
  }

  uploadStudentinfo(userMap) {
    Firestore.instance.collection("students").add(userMap);
  }

  uploadCourseInfo(courseMap) {
    Firestore.instance.collection("courses").add(courseMap);
    return "done";
  }

  uploadAttendance({time, course, attendanceMap}) async {
    await Firestore.instance
        .collection("attendances")
        .document(time)
        .collection(course)
        .add(attendanceMap);
    return "done";
  }

  getAllCourses() async {
    return await Firestore.instance.collection("courses").getDocuments();
  }

  getAttendance({time, course}) async {
    return await Firestore.instance
        .collection("attendances")
        .document(time)
        .collection(course)
        .getDocuments();
  }
}
