import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MachineLearningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Learning'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Show uploaded PDFs from Firestore
            StudentSubjectResources(subjectLabel: "Machine Learning"),
            SizedBox(height: 24),
            Text(
              'Assignments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Assignment 1'),
              onTap: () {
                // Open assignment
              },
            ),
            SizedBox(height: 24),
            Text(
              'Quizzes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('Quiz 1'),
              onTap: () {
                // Open quiz
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to show PDFs for this subject
class StudentSubjectResources extends StatelessWidget {
  final String subjectLabel;
  const StudentSubjectResources({required this.subjectLabel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('resources')
          .where('subject', isEqualTo: subjectLabel)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Center(child: Text('No resources yet.'));
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(data['fileName']),
              onTap: () async {
                final url = data['url'];
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}