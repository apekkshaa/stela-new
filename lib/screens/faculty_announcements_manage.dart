import 'package:flutter/material.dart';

class FacultyAnnouncementsManage extends StatelessWidget {
  final Map<String, dynamic> subject;
  const FacultyAnnouncementsManage({required this.subject});

  @override
  Widget build(BuildContext context) {
    // Dummy previous announcements list
    final List<Map<String, String>> announcements = [
      {"title": "Exam Date Announced", "date": "2024-07-10"},
      {"title": "Assignment Deadline Extended", "date": "2024-07-15"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements - ${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Create New Announcement"),
              style: ElevatedButton.styleFrom(
                backgroundColor: subject['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // TODO: Navigate to announcement creation form
              },
            ),
            SizedBox(height: 24),
            Text(
              "Previous Announcements",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            Expanded(
              child: announcements.isEmpty
                  ? Text("No announcements yet.")
                  : ListView.builder(
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.announcement, color: subject['color']),
                            title: Text(announcement['title'] ?? ''),
                            subtitle: Text("Date: ${announcement['date']}"),
                            onTap: () {
                              // Optionally, view announcement details
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}