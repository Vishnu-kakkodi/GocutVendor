import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class Authentication {
//   static Future<User?> signInWithGoogle({required BuildContext context}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     if (kIsWeb) {
//       GoogleAuthProvider authProvider = GoogleAuthProvider();

//       try {
//         final UserCredential userCredential =
//             await auth.signInWithPopup(authProvider);

//         user = userCredential.user;
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       final GoogleSignIn googleSignIn = GoogleSignIn();

//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();

//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;

//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );

//         try {
//           final UserCredential userCredential =
//               await auth.signInWithCredential(credential);

//           user = userCredential.user;
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'account-exists-with-different-credential') {
//             // ...
//           } else if (e.code == 'invalid-credential') {
//             // ...
//           }
//         } catch (e) {
//           // ...
//         }
//       }
//     }

//     return user;
//   }
// }




















class Authentication {
  static Future<GoogleSignInAccount?> signInWithGoogle( BuildContext context,) async {
  try {
        final GoogleSignIn googleSignIn = GoogleSignIn();


  final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      print('🚨 Google Sign-In Canceled');
      return null;
    }

    // Detailed authentication logging
    print('🔍 Google User Details:');
    print('Email: ${googleUser.email}');
    print('Display Name: ${googleUser.displayName}');
        print('UUID: ${googleUser.id}');


    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Null checks for tokens
    // if (googleAuth.accessToken == null || googleAuth.idToken == null) {
    //   print('🚨 Missing authentication tokens');
    //   return null;
    // }

    // print('🔑 Access Token: ${googleAuth.accessToken}');
    // print('🔑 ID Token: ${googleAuth.idToken?.substring(0, 10)}...');

    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // final UserCredential authResult = await _auth.signInWithCredential(credential);
    //     print('Email Printing: ${authResult.user?.email}');
    //             print('Email Printing: ${authResult.user?.uid}');

    //     print('Email Printing: ${authResult.user?.displayName}');
    return googleUser;

  } catch (error) {
    print('🚨 Detailed Google Sign-In Error:');
    print(error.toString());

    // More detailed error handling
    if (error is FirebaseAuthException) {
      print('Firebase Error Code: ${error.code}');
      print('Firebase Error Message: ${error.message}');
    }

    return null;
  }
}
}
