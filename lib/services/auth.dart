import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> signInAnon(BuildContext context) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      // var user = result.user;
      String uid = result.user!.uid;
      print('this is the uid: $uid');

      await _db.collection('users').doc(uid).set({
        'deposits': 0,
        'withdrawals': 0,
        'winnings': 0,
        'losses': 0,
      });
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unknown error happen.\n${e.toString()}'),
        ),
      );
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

  Future updateUserInput(String mode, int newVal) async {
    String uid = _auth.currentUser!.uid;
    final ref = await _db.collection('users').doc(uid).get();
    var preVal = ref[mode];

    return _db.collection('users').doc(uid).update({
      mode: preVal + newVal,
    });
  }

  // withdrawals - deposits
  Stream<String> performNetProfit() {
    String uid = _auth.currentUser!.uid;

    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      var withdrawals = data['withdrawals'];
      var deposits = data['deposits'];

      return (withdrawals - deposits).toString();
    });
  }

  // winnings - losses
  Stream<String> performNetGambling() {
    String uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      var winnings = data['winnings'];
      var losses = data['losses'];

      return (winnings - losses).toString();
    });
  }

  /*
  get the 4 user values
   */
  Future<int> getUserStat(String mode) async {
    String uid = _auth.currentUser!.uid;
    final ref = await _db.collection('users').doc(uid).get();
    return ref[mode];
  }
}
