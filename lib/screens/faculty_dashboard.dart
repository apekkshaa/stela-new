import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/faculty_subject_picker.dart';
import 'package:stela_app/screens/faculty_subjects.dart'; // <-- import the FacultySubjects screen
import 'package:stela_app/screens/faculty_upload_resource.dart';
import 'package:stela_app/screens/faculty_subjects_data.dart';
import 'package:stela_app/screens/faculty_subject_manage.dart';
import 'package:stela_app/screens/faculty_quiz_manage.dart';
import 'package:stela_app/screens/faculty_assignment_manage.dart';
import 'package:stela_app/screens/faculty_submissions_manage.dart';
import 'package:stela_app/screens/faculty_announcements_manage.dart';
import 'package:stela_app/screens/faculty_progress_manage.dart';
import 'package:stela_app/screens/subjects.dart';

// Import your upload, assignment, quiz, etc. pages here

class FacultyDashboard extends StatefulWidget {
  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  final List<Map<String, dynamic>> features = [
    {
      "title": "View Subjects",
      "icon": Icons.book_outlined,
      "route": Subjects(),
      "desc": "Browse all your subjects"
    },
    {
      "title": "Upload Resource",
      "icon": Icons.upload_file,
      "route": Builder(
        builder: (context) => FacultySubjectPicker(
          subjects: facultySubjects, // Pass your subjects list here
          onSubjectTap: (subject) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FacultyUploadResource(subject: subject),
              ),
            );
          },
          title: "Select Subject to Upload Resource",
        ),
      ),
      "desc": "Upload PDFs, links, or videos"
    },
    {
      "title": "Create Assignment",
      "icon": Icons.assignment,
      "route": Builder(
        builder: (context) => FacultySubjectPicker(
          subjects: facultySubjects,
          onSubjectTap: (subject) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FacultyAssignmentManage(subject: subject),
              ),
            );
          },
          title: "Select Subject to Create Assignment",
        ),
      ),
      "desc": "Add new assignments"
    },
    {
      "title": "Create Quiz",
      "icon": Icons.quiz,
      "route": Builder(
        builder: (context) => FacultySubjectPicker(
          subjects: facultySubjects,
          onSubjectTap: (subject) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FacultyQuizManage(subject: subject),
              ),
            );
          },
          title: "Select Subject to Create Quiz",
        ),
      ),
      "desc": "Add quizzes for students"
    },
    {
      "title": "View Submissions",
      "icon": Icons.assignment_turned_in,
      "route": Builder(
        builder: (context) => FacultySubjectPicker(
          subjects: facultySubjects,
          onSubjectTap: (subject) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FacultySubmissionsManage(subject: subject),
              ),
            );
          },
          title: "Select Subject to View Submissions",
        ),
      ),
      "desc": "See student submissions"
    },
    {
      "title": "Announcements",
      "icon": Icons.announcement,
      "route": Builder(
        builder: (context) => FacultySubjectPicker(
          subjects: facultySubjects,
          onSubjectTap: (subject) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FacultyAnnouncementsManage(subject: subject),
              ),
            );
          },
          title: "Select Subject to Manage Announcements",
        ),
      ),
      "desc": "Post updates for students"
    },
    {
      "title": "Student Progress",
      "icon": Icons.bar_chart,
      "route": Builder(
        builder: (context) => FacultySubjectPicker(
          subjects: facultySubjects,
          onSubjectTap: (subject) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FacultyProgressManage(subject: subject),
              ),
            );
          },
          title: "Select Subject to View Progress",
        ),
      ),
      "desc": "Track student progress"
    },
  ];

  // Example color palette for cards
  final List<Color> cardColors = [
    Color(0xFFe3f2fd),
    Color(0xFFfce4ec),
    Color(0xFFe8f5e9),
    Color(0xFFfff3e0),
    Color(0xFFede7f6),
    Color(0xFFf3e5f5),
    Color(0xFFf9fbe7),
    Color(0xFFe0f2f1),
    Color(0xFFfbe9e7),
  ];

  void _navigateToProfile() {
    // Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
  }

  void _logout() {
    // Add your logout logic here
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.school, color: primaryBar),
            SizedBox(width: 8),
            Text(
              "Faculty Dashboard",
              style: TextStyle(
                color: primaryBar,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'PTSerif-Bold',
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person, color: primaryBar),
            label: Text(
              "Profile",
              style: TextStyle(color: primaryBar, fontWeight: FontWeight.w600),
            ),
            onPressed: _navigateToProfile,
            style: TextButton.styleFrom(
              foregroundColor: primaryBar,
            ),
          ),
          SizedBox(width: 8),
          TextButton.icon(
            icon: Icon(Icons.logout, color: primaryBar),
            label: Text(
              "Logout",
              style: TextStyle(color: primaryBar, fontWeight: FontWeight.w600),
            ),
            onPressed: _logout,
            style: TextButton.styleFrom(
              foregroundColor: primaryBar,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBar.withOpacity(0.93), Colors.blueAccent.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    "Welcome, Faculty!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Manage your subjects and resources easily.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double aspectRatio = 2.5;
                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 4;
                    aspectRatio = 3.2;
                  } else if (constraints.maxWidth > 800) {
                    crossAxisCount = 3;
                    aspectRatio = 3.0;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                    aspectRatio = 2.8;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth > 600 ? 16 : 12,
                      vertical: 12,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: features.length,
                      itemBuilder: (context, index) {
                        final feature = features[index];
                        final cardColor = cardColors[index % cardColors.length];
                        return _FeatureCard(feature: feature, cardColor: cardColor);
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

class _FeatureCard extends StatelessWidget {
  final Map<String, dynamic> feature;
  final Color cardColor;
  const _FeatureCard({required this.feature, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => feature['route']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.blueAccent.withOpacity(0.13), width: 1),
        ),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryBar.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(feature['icon'], color: primaryBar, size: 28),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    feature['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBar,
                      fontFamily: 'PTSerif-Bold',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    feature['desc'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryBar.withOpacity(0.7),
                      fontFamily: 'PTSerif',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: primaryBar),
          ],
        ),
      ),
    );
  }
}