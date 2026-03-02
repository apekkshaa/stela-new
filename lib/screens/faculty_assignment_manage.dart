import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'faculty_create_assignment.dart';

class FacultyAssignmentManage extends StatefulWidget {
  final Map<String, dynamic> subject;
  const FacultyAssignmentManage({required this.subject});

  @override
  State<FacultyAssignmentManage> createState() => _FacultyAssignmentManageState();
}

class _FacultyAssignmentManageState extends State<FacultyAssignmentManage> {
  String get _subjectId => (widget.subject['id'] ?? widget.subject['value'] ?? '').toString();

  Query<Map<String, dynamic>> _baseQuery(String uid) {
    return FirebaseFirestore.instance.collection('assignments').where('facultyUID', isEqualTo: uid);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Assignments - ${widget.subject['label']}"),
        backgroundColor: widget.subject['color'],
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
                backgroundColor: widget.subject['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FacultyCreateAssignment(preselectedSubject: widget.subject)),
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
              child: uid.isEmpty
                  ? Text('Please sign in to view assignments.')
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _baseQuery(uid).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text('Failed to load assignments: ${snapshot.error}');
                        }

                        final docs = snapshot.data?.docs ?? const [];
                        final items = docs
                            .map((d) => {'id': d.id, ...d.data()})
                            .where((a) => (a['subjectId'] ?? '').toString() == _subjectId)
                            .toList();

                        items.sort((a, b) {
                          final at = a['createdAt'];
                          final bt = b['createdAt'];
                          final aMs = at is Timestamp ? at.millisecondsSinceEpoch : 0;
                          final bMs = bt is Timestamp ? bt.millisecondsSinceEpoch : 0;
                          return bMs.compareTo(aMs);
                        });

                        if (items.isEmpty) {
                          return Text('No assignments created yet.');
                        }

                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final assignment = items[index];
                            final title = (assignment['title'] ?? '').toString();
                            final due = assignment['dueDate'];
                            final dueText = due is Timestamp
                                ? due.toDate().toLocal().toString().split(' ')[0]
                                : 'No due date';

                            return Card(
                              child: ListTile(
                                leading: Icon(Icons.assignment, color: widget.subject['color']),
                                title: Text(title.isEmpty ? 'Untitled Assignment' : title),
                                subtitle: Text('Due: $dueText'),
                              ),
                            );
                          },
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