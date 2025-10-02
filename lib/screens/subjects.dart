import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/login.dart';
import 'package:stela_app/screens/MyFiles.dart';
import 'package:stela_app/screens/PythonTutorial.dart';
import 'package:stela_app/screens/CCTutorial.dart';
import 'package:stela_app/screens/COATutorial.dart';
import 'package:stela_app/screens/student_dashboard.dart';
import 'package:stela_app/screens/machine_learning_page.dart';
import 'package:stela_app/screens/wireless_networks_page.dart';
import 'package:stela_app/screens/compiler_design_page.dart';
import 'package:stela_app/screens/computer_networks_page.dart';
import 'package:stela_app/screens/internet_of_things_page.dart';
import 'package:stela_app/screens/c_programming_page.dart';
String usermanual1 =
    "https://docs.google.com/document/d/1-55-CJP_Be6KlZgdGFk6K_j7sFQeqGulqfCrZPD2bcA/edit?usp=sharing";
String feedback =
    "https://docs.google.com/spreadsheets/d/1SOxjjg91ezT3o8LFjrQ5F0GPOmRKqdrrGuBjVyYdo5A/edit?usp=sharing";

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  final List<Map<String, dynamic>> subjects = [
    {
      "label": "Artificial Intelligence - Programming Tools",
      "widget": PythonTutorial(),
      "icon": Icons.psychology,
      "description": "Learn AI programming tools and techniques",
      "category": "Core Subjects",
      "color": Colors.orange,
    },
    {
      "label": "Cloud Computing",
      "widget": CCTutorial(),
      "icon": Icons.cloud,
      "description": "Explore cloud computing concepts and practices",
      "category": "Core Subjects",
      "color": Colors.blue,
    },
    {
  "label": "Compiler Design",
  "icon": Icons.build, // or any suitable icon
  "description": "Learn about compiler construction and design",
  "category": "Core Subjects",
  "color": Colors.redAccent,
  "widget": CompilerDesignPage(),
},
    {
      "label": "Computer Networks",
      "widget": ComputerNetworksPage(),
      "icon": Icons.network_check,
      "description": "Study computer networking concepts and protocols",
      "category": "Core Subjects",
      "color": Colors.lightBlue,
    },

    {
      "label": "Computer Organization and Architecture",
      "widget": COATutorial(),
      "icon": Icons.computer,
      "description": "Understand computer architecture and organization",
      "category": "Core Subjects",
      "color": Colors.green,
    },
    {
      "label": "Machine Learning",
      "icon": Icons.memory,
      "description": "Introduction to machine learning concepts and algorithms",
      "category": "Core Subjects",
      "color": Colors.deepPurple,
      "widget": MachineLearningPage(), // Uncomment and import if you have a page for this
    },
    // --- Add Wireless Networks subject ---
    {
      "label": "Wireless Networks",
      "icon": Icons.wifi,
      "description": "Study wireless communication and networking",
      "category": "Core Subjects",
      "color": Colors.cyan,
      "widget": WirelessNetworksPage(), // Uncomment and import if you have a page for this
    },
    {
      "label": "Internet of Things",
      "icon": Icons.sensors,
      "description": "Learn about connected devices, sensor networks, and IoT applications",
      "category": "Core Subjects",
      "color": Colors.deepOrange,
      "widget": InternetOfThingsPage(),
    },
    {
      "label": "C Programming",
      "icon": Icons.code,
      "description": "Master the fundamentals of C programming language",
      "category": "Core Subjects",
      "color": Colors.blueGrey,
      "widget": CProgrammingPage(),
    },
    {
      "label": "My Python Codes and Practice",
      "widget": MyFiles(),
      "icon": Icons.code,
      "description": "Access your Python codes and practice materials",
      "category": "Practice",
      "color": Colors.purple,
    },
    {
      "label": "User Manual for Students",
      "url": usermanual1,
      "icon": Icons.menu_book,
      "description": "Complete user manual and guidelines",
      "category": "Resources",
      "color": Colors.teal,
    },
    {
      "label": "Feedback of the Users",
      "url": feedback,
      "icon": Icons.feedback,
      "description": "View and submit user feedback",
      "category": "Resources",
      "color": Colors.indigo,
    },
  ];

  String selectedCategory = "All";
  final List<String> categories = [
    "All",
    "Core Subjects",
    "Practice",
    "Resources"
  ];

  // Navigation methods
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => StudentDashboard()),
    );
  }

  void _navigateToSubjects() {
    // Already on subjects page
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Profile()),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Login()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Build responsive app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Subjects',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'PTSerif-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: primaryBar,
      elevation: 0,
      actions: [
        // Show hamburger menu for small screens, top nav for large screens
        if (MediaQuery.of(context).size.width > 600) ...[
          // Top navigation for larger screens
          TextButton(
            onPressed: _navigateToHome,
            child: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PTSerif',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _navigateToSubjects,
            child: Text(
              'Subjects',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PTSerif-Bold',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: _navigateToProfile,
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PTSerif',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ] else ...[
          // Hamburger menu for small screens
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ],
    );
  }

  // Build drawer for small screens
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: primaryWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryBar,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryBar, primaryButton],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'STELA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'PTSerif-Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Learning Platform',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontFamily: 'PTSerif',
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: _navigateToHome,
            ),
            _buildDrawerItem(
              icon: Icons.school,
              title: 'Subjects',
              onTap: _navigateToSubjects,
              isSelected: true,
            ),
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Profile',
              onTap: _navigateToProfile,
            ),
            Divider(color: primaryBar.withOpacity(0.2)),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? primaryButton : primaryBar,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryButton : primaryBar,
          fontFamily: 'PTSerif',
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      onTap: onTap,
      tileColor: isSelected ? primaryButton.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = selectedCategory == "All"
        ? subjects
        : subjects
            .where((subject) => subject['category'] == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: _buildAppBar(),
      drawer: MediaQuery.of(context).size.width <= 600 ? _buildDrawer() : null,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryBar,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to STELA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'PTSerif-Bold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explore your learning modules and resources',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontFamily: 'PTSerif',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : primaryBar,
                          fontFamily: 'PTSerif',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: primaryButton,
                      checkmarkColor: Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? primaryButton.withOpacity(0.3)
                            : primaryBar.withOpacity(0.2),
                        width: isSelected ? 1.5 : 1,
                      ),
                      elevation: isSelected ? 6 : 2,
                      shadowColor: isSelected
                          ? primaryButton.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid configuration
                int crossAxisCount;
                double childAspectRatio;

                if (constraints.maxWidth > 1200) {
                  // Desktop
                  crossAxisCount = 4;
                  childAspectRatio = 1.1;
                } else if (constraints.maxWidth > 800) {
                  // Tablet
                  crossAxisCount = 3;
                  childAspectRatio = 1.05;
                } else if (constraints.maxWidth > 600) {
                  // Large mobile
                  crossAxisCount = 2;
                  childAspectRatio = 1.0;
                } else {
                  // Small mobile
                  crossAxisCount = 1;
                  childAspectRatio = 1.8;
                }

                return Padding(
                  padding: EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final item = filteredSubjects[index];
                      return _buildSubjectCard(context, item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Only show bottom navigation for small screens when drawer is not available
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
              backgroundColor: primaryBar,
              selectedItemColor: primaryWhite,
              unselectedItemColor: primaryWhite.withOpacity(0.7),
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Subjects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    _navigateToHome();
                    break;
                  case 1:
                    _navigateToSubjects();
                    break;
                  case 2:
                    _navigateToProfile();
                    break;
                }
              },
            )
          : null,
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () async {
        if (item.containsKey('widget')) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => item['widget']));
        } else if (item.containsKey('url')) {
          final Uri uri = Uri.parse(item['url']);
          try {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Could not launch ${item['url']}'),
                backgroundColor: Colors.red,
              ));
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error launching link: $e'),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: item['color'].withOpacity(0.1),
              blurRadius: 12,
              offset: Offset(0, 0),
            ),
          ],
          border: Border.all(
            color: item['color'].withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: item['color'],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          item['icon'],
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['category'],
                          style: TextStyle(
                            color: item['color'],
                            fontSize: 9,
                            fontFamily: 'PTSerif',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    item['label'],
                    style: TextStyle(
                      color: primaryBar,
                      fontSize: 13,
                      fontFamily: 'PTSerif-Bold',
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['description'],
                      style: TextStyle(
                        color: primaryBar.withOpacity(0.6),
                        fontSize: 11,
                        fontFamily: 'PTSerif',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryButton.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.containsKey('url')
                                ? 'External Link'
                                : 'Open Module',
                            style: TextStyle(
                              color: primaryButton,
                              fontSize: 9,
                              fontFamily: 'PTSerif',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            item.containsKey('url')
                                ? Icons.open_in_new
                                : Icons.arrow_forward,
                            color: primaryButton,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
