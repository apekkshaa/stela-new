import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/faculty_quiz_manage.dart';
import 'package:stela_app/screens/faculty_subjects_data.dart';

class FacultyQuizPortal extends StatefulWidget {
  static const String routeName = '/faculty-quiz-portal';

  @override
  _FacultyQuizPortalState createState() => _FacultyQuizPortalState();
}

class _FacultyQuizPortalState extends State<FacultyQuizPortal> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> get categories {
    Set<String> categorySet = {'All'};
    for (var subject in facultySubjects) {
      if (subject['category'] != null) {
        categorySet.add(subject['category']);
      }
    }
    return categorySet.toList();
  }

  List<Map<String, dynamic>> get filteredSubjects {
    if (_selectedCategory == 'All') return facultySubjects;
    return facultySubjects.where((subject) => subject['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > 1200) {
      crossAxisCount = 4;
      childAspectRatio = 1.1;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
      childAspectRatio = 1.0;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
      childAspectRatio = 0.9;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 1.2;
    }

    return Scaffold(
      backgroundColor: primaryWhite,
      body: CustomScrollView(
        slivers: [
          // Modern Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: primaryButton,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryButton,
                      primaryButton.withOpacity(0.8),
                      Color(0xFF1565C0),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background decoration
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    
                    // Header content
                    SafeArea(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.quiz,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quiz Management',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'PTSerif-Bold',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Create and manage quizzes for your subjects',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 16,
                                            fontFamily: 'PTSerif',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Subject',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBar,
                      fontFamily: 'PTSerif-Bold',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose a subject to create or manage quizzes',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryBar.withOpacity(0.7),
                      fontFamily: 'PTSerif',
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Category chips
                  if (categories.length > 1)
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = _selectedCategory == category;
                          return Container(
                            margin: EdgeInsets.only(right: 12),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : primaryBar,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: primaryButton,
                              checkmarkColor: Colors.white,
                              elevation: isSelected ? 4 : 1,
                              shadowColor: primaryButton.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Subjects Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final subject = filteredSubjects[index];
                  return _buildSubjectCard(context, subject, index);
                },
                childCount: filteredSubjects.length,
              ),
            ),
          ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map<String, dynamic> subject, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildSubjectCardContent(context, subject),
          ),
        );
      },
    );
  }

  Widget _buildSubjectCardContent(BuildContext context, Map<String, dynamic> subject) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToQuizManage(context, subject),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject icon and title
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: subject['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        subject['icon'],
                        color: subject['color'],
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subject['label'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryBar,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Description
                Text(
                  subject['description'] ?? 'Subject description',
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryBar.withOpacity(0.7),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                Spacer(),
                
                // Units info and action button
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: subject['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '4 Units',
                        style: TextStyle(
                          fontSize: 12,
                          color: subject['color'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: subject['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToQuizManage(BuildContext context, Map<String, dynamic> subject) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FacultyQuizManage(subject: subject),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }
}