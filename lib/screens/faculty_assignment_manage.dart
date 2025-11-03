import 'package:flutter/material.dart';
import 'faculty_create_assignment.dart';

class FacultyAssignmentManage extends StatelessWidget {
  final Map<String, dynamic> subject;
  const FacultyAssignmentManage({required this.subject});

  @override
  Widget build(BuildContext context) {
    // Dummy previous assignments list
    final List<Map<String, String>> previousAssignments = [
      {"title": "Assignment 1: Basics", "due": "2024-07-15"},
      {"title": "Assignment 2: Advanced", "due": "2024-07-22"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Assignments - ${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Create New Assignment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: subject['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FacultyCreateAssignment(preselectedSubject: subject)),
                );
              },
            ),
            SizedBox(height: 24),
            Text(
              "Previous Assignments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            Expanded(
              child: previousAssignments.isEmpty
                  ? Text("No assignments created yet.")
                  : ListView.builder(
                      itemCount: previousAssignments.length,
                      itemBuilder: (context, index) {
                        final assignment = previousAssignments[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.assignment, color: subject['color']),
                            title: Text(assignment['title'] ?? ''),
                            subtitle: Text("Due: ${assignment['due']}"),
                            onTap: () {
                              // Optionally, view assignment details or submissions
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