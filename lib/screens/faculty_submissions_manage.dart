import 'package:flutter/material.dart';

class FacultySubmissionsManage extends StatelessWidget {
  final Map<String, dynamic> subject;
  const FacultySubmissionsManage({required this.subject});

  @override
  Widget build(BuildContext context) {
    // Dummy submissions list
    final List<Map<String, String>> submissions = [
      {"student": "Alice", "assignment": "Assignment 1", "date": "2024-07-15"},
      {"student": "Bob", "assignment": "Assignment 1", "date": "2024-07-16"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Submissions - ${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: submissions.isEmpty
            ? Text("No submissions yet.")
            : ListView.builder(
                itemCount: submissions.length,
                itemBuilder: (context, index) {
                  final submission = submissions[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.assignment_turned_in, color: subject['color']),
                      title: Text(submission['student'] ?? ''),
                      subtitle: Text(
                        "${submission['assignment']} • Submitted: ${submission['date']}",
                      ),
                      onTap: () {
                        // Optionally, view submission details
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}