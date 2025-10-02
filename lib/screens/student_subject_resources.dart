import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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