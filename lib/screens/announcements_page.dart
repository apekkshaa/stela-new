import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stela_app/constants/colors.dart';

class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements', style: TextStyle(fontFamily: 'PTSerif-Bold')),
        backgroundColor: primaryBar,
      ),
      backgroundColor: primaryWhite,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('announcements')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading announcements'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(child: Text('No announcements yet.'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final d = docs[index];
              final data = d.data() as Map<String, dynamic>? ?? {};
              final title = data['title'] ?? 'Announcement';
              final body = data['body'] ?? '';
              final ts = data['timestamp'];
              DateTime? date;
              if (ts is Timestamp) date = ts.toDate();
              if (ts is DateTime) date = ts;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryBar, fontFamily: 'PTSerif-Bold')),
                          ),
                          if (date != null)
                            Text('${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}', style: TextStyle(color: primaryBar.withOpacity(0.6), fontSize: 12)),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (body.isNotEmpty)
                        Text(body, style: TextStyle(color: primaryBar.withOpacity(0.8))),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
