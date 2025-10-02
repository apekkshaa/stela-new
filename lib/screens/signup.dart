// ✅ Fixed version of SIGNUP.DART
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/subjects.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final List<String> userRoles = ['Student', 'Faculty', 'Admin'];
  String _selectedRole = 'Student';

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controllers
  String _name = "", _enrollment = "", _contact = "", _email = "";
  String _password = "", _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryWhite,
        appBar: AppBar(
          title: Text('STELA', style: TextStyle(color: Colors.white)),
          backgroundColor: primaryBar,
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
                    _buildHeader(),
                    SizedBox(height: 32),
                    _buildInputFields(),
                    SizedBox(height: 24),
                    _buildRoleDropdown(),
                    SizedBox(height: 32),
                    _buildSignupButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: primaryBar,
          child: Icon(Icons.person_add, color: Colors.white, size: 40),
        ),
        SizedBox(height: 24),
        Text('Create Account',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: primaryBar)),
        SizedBox(height: 8),
        Text('Join STELA today',
            style: TextStyle(fontSize: 16, color: primaryBar.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildTextField("Full Name", (val) => _name = val,
            prefixIcon: Icons.person_outline),
        SizedBox(height: 16),
        _buildTextField("Enrollment Number", (val) => _enrollment = val,
            prefixIcon: Icons.badge_outlined),
        SizedBox(height: 16),
        _buildTextField("Contact Number", (val) => _contact = val,
            prefixIcon: Icons.phone_outlined, keyboard: TextInputType.phone),
        SizedBox(height: 16),
        _buildTextField("Email Address", (val) => _email = val,
            prefixIcon: Icons.email_outlined,
            keyboard: TextInputType.emailAddress),
        SizedBox(height: 16),
        _buildTextField("Password", (val) => _password = val,
            obscure: _obscurePassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _togglePassword()),
        SizedBox(height: 16),
        _buildTextField("Confirm Password", (val) => _confirmPassword = val,
            obscure: _obscureConfirmPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _toggleConfirmPassword()),
      ],
    );
  }

  Widget _togglePassword() => IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      );

  Widget _toggleConfirmPassword() => IconButton(
        icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
        onPressed: () =>
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
      );

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select your role",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: primaryBar, fontSize: 16)),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: primaryBar.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: primaryBar),
              onChanged: (val) => setState(() => _selectedRole = val!),
              items: userRoles
                  .map((role) =>
                      DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return isLoading
        ? CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButton,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Create Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          );
  }

  Widget _buildTextField(String hint, Function(String) onChanged,
      {bool obscure = false,
      TextInputType keyboard = TextInputType.text,
      IconData? prefixIcon,
      Widget? suffixIcon}) {
    return TextFormField(
      obscureText: obscure,
      keyboardType: keyboard,
      onChanged: onChanged,
      validator: (val) =>
          val == null || val.isEmpty ? 'Please enter $hint' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }
    setState(() => isLoading = true);

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      final userUID = newUser.user?.uid;
      await FirebaseFirestore.instance.collection('students').doc(userUID).set({
        'name': _name,
        'contactNumber': _contact,
        'emailAddress': _email,
        'enrollmentNumber': _enrollment,
        'password': _password,
        'userRole': _selectedRole,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userRole', _selectedRole);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Subjects()));
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Signup Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("OK"))
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
