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

  // reverse parameter will inverse operation to running sum
  void updateUserInput(String mode, int newVal, bool reverse) async {
    String uid = _auth.currentUser!.uid;
    final ref = await _db.collection('users').doc(uid).get();
    var preVal = ref[mode];

    if (reverse) {
      _db.collection('users').doc(uid).update({
        mode: preVal - newVal,
      });
      return; // exit
    }
    // updates running sum
    _db.collection('users').doc(uid).update({
      mode: preVal + newVal,
    });

    // logs transaction
    _db.collection('users').doc(uid).collection('transactions').add(
      {
        'type': mode,
        'amount': newVal,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
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

  // user history
  Future<List> getUserHistory() async {
    String uid = _auth.currentUser!.uid;
    List data = [];
    final querySnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy("timestamp", descending: true)
        .get();

    for (var docSnapshot in querySnapshot.docs) {
      var docData = docSnapshot.data();
      docData['id'] = docSnapshot.id;
      data.add(docData);
    }
    return data;
  }

  // delete a history
  Future<void> deleteHistory(String docId, String mode, int newVal) async {
    String uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(docId)
        .delete();

    // call to update running sum
    updateUserInput(mode, newVal, true);
  }
}
