import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/faculty_subject_manage.dart';

class FacultySubjects extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {
      "label": "Artificial Intelligence - Programming Tools",
      "icon": Icons.psychology,
      "description": "Learn AI programming tools and techniques",
      "color": Colors.orange,
    },
    {
      "label": "Cloud Computing",
      "icon": Icons.cloud,
      "description": "Explore cloud computing concepts and practices",
      "color": Colors.blue,
    },
    {
      "label": "Compiler Design",
      "icon": Icons.build,
      "description": "Learn about compiler construction and design",
      "color": Colors.redAccent,
    },
    {
      "label": "Computer Networks",
      "icon": Icons.network_check,
      "description": "Study computer networking concepts and protocols",
      "color": Colors.lightBlue,
    },
    {
      "label": "Computer Organization and Architecture",
      "icon": Icons.computer,
      "description": "Understand computer architecture and organization",
      "color": Colors.green,
    },
    {
      "label": "Machine Learning",
      "icon": Icons.memory,
      "description": "Introduction to machine learning concepts and algorithms",
      "color": Colors.deepPurple,
    },
    {
      "label": "Theory of Computation",
      "icon": Icons.functions,
      "description": "Study automata, formal languages, computability, and complexity",
      "color": Colors.indigo,
    },
    {
      "label": "Wireless Networks",
      "icon": Icons.wifi,
      "description": "Study wireless communication and networking",
      "color": Colors.cyan,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
        backgroundColor: primaryBar,
      ),
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
                title: Text(
                  subject['label'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryBar,
                  ),
                ),
                subtitle: Text(
                  subject['description'],
                  style: TextStyle(color: primaryBar.withOpacity(0.7)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacultySubjectManage(subject: subject),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}