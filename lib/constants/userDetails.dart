import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var userUID;

String name = "",
    email = "",
    enrollmentNo = "",
    contactNum = "",
    password = "",
    confirmPassword = "",
    userRole = "";

Map<String, dynamic>? data, document;
var userDetails;

// ✅ FIXED: Return type changed from void ➝ Future<void>
Future<void> getDetails() async {
  // Ensure we have a valid UID; prefer the shared `userUID` but fall back
  // to the currently authenticated user if it's not set (handles hot-reload
  // or direct navigation cases).
  var uid = userUID ?? FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) {
    print('⚠️ getDetails(): no user UID found (user not signed in?)');
    // Clear any existing values to avoid showing stale data
    name = email = enrollmentNo = contactNum = userRole = "";
    return;
  }

  // Try to locate the user document in students -> faculty -> admins
  // (mirrors the login logic). This ensures faculty users also get the
  // correct profile fields when opening Profile from a faculty account.
  DocumentSnapshot? docSnap;
  final colOrder = ['students', 'faculty', 'admins'];
  for (final col in colOrder) {
    final snap = await FirebaseFirestore.instance.collection(col).doc(uid).get();
    if (snap.exists) {
      docSnap = snap;
      break;
    }
  }

  if (docSnap == null || !docSnap.exists) {
    print('❌ getDetails(): no user document found for UID $uid in students/faculty/admins');
    // Clear any existing values to avoid showing stale data
    name = email = enrollmentNo = contactNum = userRole = "";
    return;
  }

  userDetails = docSnap;
  data = userDetails.data() as Map<String, dynamic>?; // gets details in the form of a map

  // Remember which collection we found by checking a likely userRole field
  userRole = data?['userRole'] ?? userRole ?? "";

  // Assign values from the found document with common fallback keys.
  name = data?['name'] ?? data?['fullName'] ?? "";
  email = data?['email'] ?? data?['emailAddress'] ?? FirebaseAuth.instance.currentUser?.email ?? "";
  enrollmentNo = data?['enrollmentNumber'] ?? data?['enrollmentNo'] ?? "";
  contactNum = data?['contactNumber'] ?? data?['phone'] ?? "";

  // Ensure the global userUID is set so other code can rely on it
  userUID = uid;

  // Debugging: if all fields are empty, print the raw document to help
  // diagnose why profile shows 'Not available'. Remove or lower verbosity
  // in production if desired.
  if ((name.isEmpty) && (email.isEmpty) && (enrollmentNo.isEmpty) && (contactNum.isEmpty)) {
    print('🔎 getDetails(): fetched document data is empty or missing keys:');
    print(data);
  }
}

// (Optional: Keep it commented if not used)
Future<void> getAssessmentLink() async {
  final assesmentLinks = await FirebaseFirestore.instance
      .collection('assessments')
      .doc('Assessments')
      .get(); // gets document

  document = assesmentLinks.data();
}
