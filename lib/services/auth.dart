import 'package:attendance_dock/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userfromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future signInEmailAndPass(String email, String pass) async {
    try {
      AuthResult authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser firebaseUser = authResult.user;
      return _userfromFirebase(firebaseUser);
    } catch (e) {
      print(e.code);
      switch (e.code) {
        case 'ERROR_WRONG_PASSWORD':
          return "Invalid Password!";
          break;
        // case 'ERROR_INVALID_EMAIL':
        //   return "Invalid email!";
        //   break;
        case 'ERROR_USER_NOT_FOUND':
          return "User this email doesn't exist!";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          return "Too many attempts. Try again later!";
          break;
        default:
          return "Error";
          break;
      }
      // print(e.message);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return _userfromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
