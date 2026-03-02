import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/userDetails.dart';
import 'package:stela_app/screens/student_dashboard.dart';
import 'package:stela_app/screens/faculty_dashboard.dart';
import 'package:stela_app/screens/admin_dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool _obscurePassword = true;
  String email = "", password = "", role = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: primaryWhite,
          appBar: AppBar(
            title: Text(
              'STELA',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PTSerif-Bold',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: primaryBar,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                padding: EdgeInsets.all(32),
                margin: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBar.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo/Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: primaryBar,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryBar.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 24),

                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'PTSerif-Bold',
                          fontWeight: FontWeight.bold,
                          color: primaryBar,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSerif',
                          color: primaryBar.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Email Field
                      TextFormField(
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          hintStyle: TextStyle(
                            color: primaryBar.withOpacity(0.5),
                            fontFamily: 'PTSerif',
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: primaryBar.withOpacity(0.7),
                          ),
                          filled: true,
                          fillColor: primaryWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryBar.withOpacity(0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryBar.withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryButton, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password Field with Eye Icon
                      TextFormField(
                        textAlign: TextAlign.left,
                        obscureText: _obscurePassword,
                        onChanged: (value) => password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: primaryBar.withOpacity(0.5),
                            fontFamily: 'PTSerif',
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: primaryBar.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: primaryBar.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: primaryWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryBar.withOpacity(0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryBar.withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryButton, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showResetPasswordDialog(context);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: primaryButton,
                              fontSize: 14,
                              fontFamily: 'PTSerif',
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Login Button
                      isLoading
                          ? Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: primaryButton.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(primaryBar),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryButton,
                                  foregroundColor: primaryBar,
                                  elevation: 4,
                                  shadowColor: primaryButton.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ Firebase login successful");

      userUID = FirebaseAuth.instance.currentUser?.uid;
      print("📦 UID fetched: $userUID");

      // Try to find the user document in students -> faculty -> admins
      DocumentSnapshot? docSnapshot;
      String? foundCollection;

      final studentDoc = await FirebaseFirestore.instance.collection('students').doc(userUID).get();
      if (studentDoc.exists) {
        docSnapshot = studentDoc;
        foundCollection = 'students';
      } else {
        final facultyDoc = await FirebaseFirestore.instance.collection('faculty').doc(userUID).get();
        if (facultyDoc.exists) {
          docSnapshot = facultyDoc;
          foundCollection = 'faculty';
        } else {
          final adminDoc = await FirebaseFirestore.instance.collection('admins').doc(userUID).get();
          if (adminDoc.exists) {
            docSnapshot = adminDoc;
            foundCollection = 'admins';
          }
        }
      }

      if (docSnapshot == null || !docSnapshot.exists) {
        print("❌ No user document found for UID $userUID in students/faculty/admins");
        throw Exception("No user document found.");
      }

      // Prefer explicit userRole stored in the document; fall back to collection inference
      role = (docSnapshot.data() as Map<String, dynamic>?)?['userRole'] ??
          (foundCollection == 'faculty' ? 'Faculty' : foundCollection == 'admins' ? 'Admin' : 'Student');
      print("🟡 Role from Firestore ($foundCollection): $role");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userRole', role);

      // Navigate based on role
      if (role == 'Student') {
        print("➡️ Navigating to StudentDashboard...");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => StudentDashboard()));
      } else if (role == 'Faculty') {
        print("➡️ Navigating to FacultyDashboard...");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => FacultyDashboard()));
      } else if (role == 'Admin') {
        print("➡️ Navigating to AdminDashboard...");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AdminDashboard()));
      } else {
        print("❗ Unknown role: $role");
        throw Exception("Invalid user role: $role");
      }
    } catch (e) {
      print("❌ Login Exception: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Login Failed"),
          content: Text("Wrong credentials or no user role found."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showResetPasswordDialog(BuildContext context) {
    String resetEmail = '';

    // Capture the parent context (the one that contains the Scaffold) so
    // we can show a SnackBar after closing the dialog. The dialog's
    // builder provides a new context that is NOT a descendant of the
    // page's Scaffold, so calling ScaffoldMessenger.of(dialogContext)
    // would fail.
    final parentContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: TextField(
            onChanged: (value) => resetEmail = value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your email",
            ),
          ),
          actions: [
            TextButton(
              child: Text("Send"),
              onPressed: () async {
                if (resetEmail.isEmpty || !resetEmail.contains('@')) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text("Enter a valid email address.")));
                  return;
                }

                try {
                  // Check whether an account exists for this email. If there
                  // are no providers returned, there's no user registered with
                  // that email and Firebase may not send a reset link.
                  final methods = await _auth.fetchSignInMethodsForEmail(resetEmail);
                  if (methods.isEmpty) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text("No account found for $resetEmail")));
                    return;
                  }

                  await _auth.sendPasswordResetEmail(email: resetEmail);
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text("Reset link sent to $resetEmail")));
                } on FirebaseAuthException catch (e) {
                  Navigator.pop(dialogContext);
                  // Show the FirebaseAuthException message which is more
                  // descriptive (e.g. user-not-found, invalid-email, etc.).
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text("Failed to send reset link: ${e.message}")));
                } catch (e) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text("Failed to send reset link: $e")));
                }
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(dialogContext),
            ),
          ],
        );
      },
    );
  }
}
