import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      var user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // deletes account
  Future signOutAnon() async {
    try {
      await _auth.currentUser!.delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
