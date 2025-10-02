import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FacultyUploadResource extends StatelessWidget {
  final Map<String, dynamic> subject;
  const FacultyUploadResource({required this.subject});

  Future<void> _uploadPDF(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref('resources/${subject['label']}/$fileName');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      // Save metadata to Firestore
      await FirebaseFirestore.instance.collection('resources').add({
        'subject': subject['label'],
        'fileName': fileName,
        'url': url,
        'uploadedAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF uploaded successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Resource - ${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: subject['color']),
            title: Text("Upload PDF"),
            onTap: () => _uploadPDF(context),
          ),
        ],
      ),
    );
  }
}