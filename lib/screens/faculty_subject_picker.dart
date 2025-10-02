import 'package:flutter/material.dart';

class FacultySubjectPicker extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;
  final void Function(Map<String, dynamic>) onSubjectTap;
  final String title;

  const FacultySubjectPicker({
    required this.subjects,
    required this.onSubjectTap,
    this.title = "Select Subject",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.8,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return Card(
              color: subject['color'].withOpacity(0.12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: Icon(subject['icon'], color: subject['color'], size: 32),
                title: Text(subject['label'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(subject['description']),
                onTap: () => onSubjectTap(subject),
              ),
            );
          },
        ),
      ),
    );
  }
}