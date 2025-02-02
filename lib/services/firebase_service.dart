import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String USER_COLLECTION = "users";

class FirebaseService {
  Map? currentuser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId;
  FirebaseService();
  num? lastScore;

  Future<bool> userRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _userId = _userCredential.user!.uid;
      // Use whenComplete instead of then
      try {
        await _db.collection(USER_COLLECTION).doc(_userId).set({
          "name": name,
          "email": email,
          "lastScore": 0,
          "maxScore": 0,
        });
        // Handle success (e.g., show a success message)
        return true;
      } catch (e) {
        print(e);
        print("Error during image upload or Firestore update: $e");
        // Handle error (e.g., show an error message)
        return false;
      }

      return true; // Return true after whenComplete
    } catch (e) {
      print(e);
      print("Error during user creation: $e");
      // Handle error (e.g., show an error message)
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential.user != null) {
        currentuser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("-----------------------------------------------");
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

//   Future<bool> setUserScore(double lstScr) async {
//     lastScore = lstScr;
//     try {
//       DocumentSnapshot doc = await _db.collection(USER_COLLECTION).doc(_userId).get();
// if(doc.exists)
//  {
//    await _db.collection(USER_COLLECTION).doc(_userId).update(
//      {
//        "name": currentuser!["name"],
//        "email": currentuser!["email"],
//        "lastScore": lastScore!,
//        "maxScore": max(lastScore!, currentuser!["maxScore"] as num),
//      },
//    );
//    // Handle success (e.g., show a success message)
//    return true;
//  }
// else {
//   return false;
// }
//     } catch (e) {
//       print(e);
//       print("Error during image upload or Firestore update: $e");
//       // Handle error (e.g., show an error message)
//       return false;
//     }
//
//     return true; // Return true after whenComplete
//   }
  Future<bool> setUserScore(double newScore) async {
    try {
      num currentMaxScore = currentuser?["maxScore"] ?? newScore;

      num updatedMaxScore = max(newScore, currentMaxScore);

      // Update the document using set() with merge: true.
      await _db.collection(USER_COLLECTION).doc(_auth.currentUser!.uid).set({
        "lastScore": newScore,
        "maxScore": updatedMaxScore,
      }, SetOptions(merge: true));

      // Optionally update the local currentuser map if needed.
      currentuser!["lastScore"] = newScore;
      currentuser!["maxScore"] = updatedMaxScore;

      print("User score updated successfully!");
      return true;
    } catch (e) {
      print("Error updating user score: $e");
      return false;
    }
  }
}
