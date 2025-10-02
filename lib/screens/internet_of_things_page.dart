import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';

class InternetOfThingsPage extends StatefulWidget {
  @override
  _InternetOfThingsPageState createState() => _InternetOfThingsPageState();
}

class _InternetOfThingsPageState extends State<InternetOfThingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          'Internet of Things',
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
                            Icons.sensors,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Internet of Things (IoT)',
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
                      'Learn about connected devices, sensor networks, and IoT applications in various domains.',
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
                icon: Icons.device_hub,
                title: 'IoT Fundamentals',
                description: 'Introduction to IoT concepts, architecture, and protocols',
                color: Colors.blue,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.memory,
                title: 'Sensor Networks',
                description: 'Understanding sensors, actuators, and wireless communication',
                color: Colors.green,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.cloud,
                title: 'IoT Platforms',
                description: 'Cloud platforms, data analytics, and device management',
                color: Colors.orange,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.security,
                title: 'IoT Security',
                description: 'Security challenges and solutions in IoT systems',
                color: Colors.red,
              ),
              SizedBox(height: 12),
              
              _buildModuleCard(
                icon: Icons.build,
                title: 'Practical Projects',
                description: 'Hands-on IoT projects and implementations',
                color: Colors.purple,
              ),
              
              SizedBox(height: 24),
              
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
                        'Course content and interactive modules coming soon!',
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