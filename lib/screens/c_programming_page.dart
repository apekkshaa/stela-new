import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';

class CProgrammingPage extends StatefulWidget {
  @override
  _CProgrammingPageState createState() => _CProgrammingPageState();
}

class _CProgrammingPageState extends State<CProgrammingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          'C Programming',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBar,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: primaryWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryButton.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryButton.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryButton,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.code,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'C Programming',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'PTSerif-Bold',
                              fontWeight: FontWeight.bold,
                              color: primaryBar,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Master the fundamentals of C programming language, from basic syntax to advanced concepts.',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PTSerif',
                        color: primaryBar.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              
              // Course Modules Section
              Text(
                'Course Modules',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'PTSerif-Bold',
                  fontWeight: FontWeight.bold,
                  color: primaryBar,
                ),
              ),
              SizedBox(height: 16),
              
              _buildModuleCard(
                icon: Icons.play_circle,
                title: 'C Basics',
                description: 'Introduction to C, syntax, variables, and data types',
                color: Colors.blue,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.account_tree,
                title: 'Control Structures',
                description: 'Conditional statements, loops, and decision making',
                color: Colors.green,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.functions,
                title: 'Functions',
                description: 'Function definition, parameters, recursion, and scope',
                color: Colors.orange,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.view_array,
                title: 'Arrays & Strings',
                description: 'Array operations, string manipulation, and character handling',
                color: Colors.purple,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.link,
                title: 'Pointers',
                description: 'Pointer concepts, memory management, and dynamic allocation',
                color: Colors.red,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.storage,
                title: 'Data Structures',
                description: 'Structures, unions, and user-defined data types',
                color: Colors.teal,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.folder_open,
                title: 'File Handling',
                description: 'File operations, reading, writing, and file management',
                color: Colors.indigo,
              ),
              
              SizedBox(height: 24),
              
              // Programming Practice Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.green[700],
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Practice Makes Perfect',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PTSerif-Bold',
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Practice coding exercises, solve programming problems, and build projects to strengthen your C programming skills.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PTSerif',
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // Coming Soon Notice
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.amber[700],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Interactive coding exercises and assessments coming soon!',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PTSerif',
                          color: Colors.amber[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: primaryBar,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Subjects()),
                );
              },
              icon: Icon(
                Icons.home,
                color: primaryWhite,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              icon: Icon(
                Icons.account_circle,
                color: primaryWhite,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModuleCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PTSerif-Bold',
                    fontWeight: FontWeight.bold,
                    color: primaryBar,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'PTSerif',
                    color: primaryBar.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: color.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}