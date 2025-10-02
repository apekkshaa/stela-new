import 'package:cloud_firestore/cloud_firestore.dart';

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
  userDetails = await FirebaseFirestore.instance
      .collection('students')
      .doc(userUID)
      .get(); // gets user

  data = userDetails.data(); // gets details in the form of a map

  // Assigning values from Firestore document
  name = data?["name"] ?? "";
  email = data?['emailAddress'] ?? "";
  enrollmentNo = data?['enrollmentNumber'] ?? "";
  contactNum = data?['contactNumber'] ?? "";
  userRole = data?['userRole'] ?? "";
}

// (Optional: Keep it commented if not used)
Future<void> getAssessmentLink() async {
  final assesmentLinks = await FirebaseFirestore.instance
      .collection('assessments')
      .doc('Assessments')
      .get(); // gets document

  document = assesmentLinks.data();
}
