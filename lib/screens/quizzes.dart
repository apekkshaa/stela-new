import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/subject_detail.dart';
import 'package:stela_app/services/quiz_service.dart';

/// Clean, single-file quizzes implementation.
/// Exposes `QuizzesScreen` as the main entry point for the Quizzes route.
class QuizzesScreen extends StatefulWidget {
  static const String routeName = '/quizzes';

  @override
  _QuizzesScreenState createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = 'All';
  final QuizService _quizService = QuizService();
  Map<String, List<Map<String, dynamic>>> _facultyQuizzes = {};
  bool _loadingFacultyQuizzes = true;

  final List<Map<String, dynamic>> subjects = const [
    {
      'id': 'artificial_intelligence_programming_tools', 
      'title': 'Artificial Intelligence - Programming Tools', 
      'icon': Icons.psychology, 
      'color': Colors.orange, 
      'category': 'AI & Data',
      'units': [
        {'name': 'Unit 1', 'topics': ['Introduction to AI', 'Python Basics', 'Data Structures']},
        {'name': 'Unit 2', 'topics': ['Machine Learning Fundamentals', 'Supervised Learning', 'Algorithms']},
        {'name': 'Unit 3', 'topics': ['Neural Networks', 'Deep Learning', 'TensorFlow']},
        {'name': 'Unit 4', 'topics': ['Natural Language Processing', 'Computer Vision', 'AI Applications']}
      ]
    },
    {
      'id': 'cloud_computing', 
      'title': 'Cloud Computing', 
      'icon': Icons.cloud, 
      'color': Colors.blue, 
      'category': 'Engineering',
      'units': [
        {'name': 'Unit 1', 'topics': ['Cloud Fundamentals', 'Service Models', 'Deployment Models']},
        {'name': 'Unit 2', 'topics': ['AWS Services', 'EC2', 'S3 Storage']},
        {'name': 'Unit 3', 'topics': ['Azure Platform', 'Google Cloud', 'Multi-cloud Strategy']},
        {'name': 'Unit 4', 'topics': ['Security', 'Monitoring', 'Cost Optimization']}
      ]
    },
    {
      'id': 'compiler_design', 
      'title': 'Compiler Design', 
      'icon': Icons.build, 
      'color': Colors.redAccent, 
      'category': 'Core Systems',
      'units': [
        {'name': 'Unit 1', 'topics': ['Lexical Analysis', 'Tokens', 'Regular Expressions']},
        {'name': 'Unit 2', 'topics': ['Syntax Analysis', 'Parsing', 'Grammar']},
        {'name': 'Unit 3', 'topics': ['Semantic Analysis', 'Symbol Tables', 'Type Checking']},
        {'name': 'Unit 4', 'topics': ['Code Generation', 'Optimization', 'Runtime Environment']}
      ]
    },
    {
      'id': 'computer_networks', 
      'title': 'Computer Networks', 
      'icon': Icons.network_check, 
      'color': Colors.lightBlue, 
      'category': 'Networking',
      'units': [
        {'name': 'Unit 1', 'topics': ['Network Basics', 'OSI Model', 'TCP/IP']},
        {'name': 'Unit 2', 'topics': ['Data Link Layer', 'Ethernet', 'Switching']},
        {'name': 'Unit 3', 'topics': ['Network Layer', 'Routing', 'IP Addressing']},
        {'name': 'Unit 4', 'topics': ['Transport Layer', 'Application Layer', 'Network Security']}
      ]
    },
    {
      'id': 'computer_organization_and_architecture', 
      'title': 'Computer Organization and Architecture', 
      'icon': Icons.computer, 
      'color': Colors.green, 
      'category': 'Core Systems',
      'units': [
        {'name': 'Unit 1', 'topics': ['Basic Computer Organization', 'CPU', 'Memory']},
        {'name': 'Unit 2', 'topics': ['Instruction Set Architecture', 'RISC vs CISC', 'Assembly Language']},
        {'name': 'Unit 3', 'topics': ['Pipeline Processing', 'Cache Memory', 'Virtual Memory']},
        {'name': 'Unit 4', 'topics': ['I/O Organization', 'Multiprocessors', 'Performance Evaluation']}
      ]
    },
    {
      'id': 'machine_learning', 
      'title': 'Machine Learning', 
      'icon': Icons.memory, 
      'color': Colors.deepPurple, 
      'category': 'AI & Data',
      'units': [
        {'name': 'Unit 1', 'topics': ['ML Introduction', 'Types of Learning', 'Data Preprocessing']},
        {'name': 'Unit 2', 'topics': ['Supervised Learning', 'Classification', 'Regression']},
        {'name': 'Unit 3', 'topics': ['Unsupervised Learning', 'Clustering', 'Dimensionality Reduction']},
        {'name': 'Unit 4', 'topics': ['Deep Learning', 'Neural Networks', 'Model Evaluation']}
      ]
    },
    {
      'id': 'theory_of_computation',
      'title': 'Theory of Computation',
      'icon': Icons.functions,
      'color': Colors.indigo,
      'category': 'Core Systems',
      'units': [
        {'name': 'Unit 1', 'topics': ['Automata Theory', 'Finite Automata', 'Regular Languages']},
        {'name': 'Unit 2', 'topics': ['Context-Free Languages', 'Pushdown Automata', 'Parsing']},
        {'name': 'Unit 3', 'topics': ['Turing Machines', 'Decidability', 'Reducibility']},
        {'name': 'Unit 4', 'topics': ['Complexity Theory', 'P vs NP', 'Approximation Algorithms']},
      ]
    },
    {
      'id': 'wireless_networks', 
      'title': 'Wireless Networks', 
      'icon': Icons.wifi, 
      'color': Colors.cyan, 
      'category': 'Networking',
      'units': [
        {'name': 'Unit 1', 'topics': ['Wireless Fundamentals', 'Radio Waves', 'Antennas']},
        {'name': 'Unit 2', 'topics': ['WiFi Standards', '802.11', 'Access Points']},
        {'name': 'Unit 3', 'topics': ['Cellular Networks', '4G/5G', 'Mobile Communication']},
        {'name': 'Unit 4', 'topics': ['Bluetooth', 'IoT Protocols', 'Network Security']}
      ]
    },
    {
      'id': 'internet_of_things', 
      'title': 'Internet of Things', 
      'icon': Icons.sensors, 
      'color': Colors.deepOrange, 
      'category': 'Engineering',
      'units': [
        {'name': 'Unit 1', 'topics': ['IoT Introduction', 'Sensors', 'Actuators']},
        {'name': 'Unit 2', 'topics': ['Communication Protocols', 'MQTT', 'CoAP']},
        {'name': 'Unit 3', 'topics': ['IoT Platforms', 'Cloud Integration', 'Data Analytics']},
        {'name': 'Unit 4', 'topics': ['Security', 'Edge Computing', 'IoT Applications']}
        ,{'name': 'IOT workshop', 'topics': ['Hands-on Projects', 'Device Setup', 'Practical Implementations']}
      ]
    },
    {
      'id': 'c_programming', 
      'title': 'C Programming', 
      'icon': Icons.code, 
      'color': Colors.blueGrey, 
      'category': 'Programming',
      'units': [
        {'name': 'Unit 1', 'topics': ['C Basics', 'Variables', 'Data Types']},
        {'name': 'Unit 2', 'topics': ['Control Structures', 'Loops', 'Functions']},
        {'name': 'Unit 3', 'topics': ['Arrays', 'Pointers', 'Strings']},
        {'name': 'Unit 4', 'topics': ['Structures', 'File Handling', 'Dynamic Memory']}
      ]
    },
  ];

  final List<String> categories = ['All', 'AI & Data', 'Engineering', 'Core Systems', 'Networking', 'Programming'];

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
    _loadFacultyQuizzes();
  }

  Future<void> _loadFacultyQuizzes() async {
    try {
      final facultyQuizzes = await _quizService.getAllQuizzes();
      setState(() {
        _facultyQuizzes = facultyQuizzes;
        _loadingFacultyQuizzes = false;
      });
    } catch (e) {
      print('Error loading faculty quizzes: $e');
      setState(() {
        _loadingFacultyQuizzes = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredSubjects {
    List<Map<String, dynamic>> updatedSubjects = _mergeWithFacultyQuizzes();
    if (_selectedCategory == 'All') return updatedSubjects;
    return updatedSubjects.where((subject) => subject['category'] == _selectedCategory).toList();
  }

  List<Map<String, dynamic>> _mergeWithFacultyQuizzes() {
    List<Map<String, dynamic>> updatedSubjects = [];
    
    for (var subject in subjects) {
      Map<String, dynamic> updatedSubject = Map<String, dynamic>.from(subject);
      String subjectId = subject['id'];
      
      // Get faculty quizzes for this subject
      List<Map<String, dynamic>> facultyQuizzes = _facultyQuizzes[subjectId] ?? [];
      
      // Create a deep copy of units to make them modifiable
      List<Map<String, dynamic>> units = [];
      for (var unit in (updatedSubject['units'] ?? [])) {
        // Start with clean units (no static quizzes)
        Map<String, dynamic> cleanUnit = {
          'name': unit['name'],
          'topics': unit['topics'],
          'quizzes': [], // Initialize with empty quizzes array
        };
        units.add(cleanUnit);
      }
      
      if (facultyQuizzes.isNotEmpty) {
        // Group faculty quizzes by unit
        Map<String, List<Map<String, dynamic>>> quizzesByUnit = {};
        for (var quiz in facultyQuizzes) {
          String unitName = quiz['unit'] ?? 'Unit 1';
          if (!quizzesByUnit.containsKey(unitName)) {
            quizzesByUnit[unitName] = [];
          }
          
          // Convert to expected format
          quizzesByUnit[unitName]!.add({
            'name': quiz['title'],
            'title': quiz['title'],
            'questions': quiz['questions']?.length ?? 0,
            'duration': quiz['duration'],
            'id': quiz['id'],
            'isFromFaculty': true,
            'date': quiz['date'],
            'unit': quiz['unit'],
            'facultyQuestions': quiz['questions'], // Store full question data
          });
        }
        
        // Add faculty quizzes to the corresponding units
        for (int i = 0; i < units.length; i++) {
          String unitName = units[i]['name'];
          if (quizzesByUnit.containsKey(unitName)) {
            units[i]['quizzes'] = quizzesByUnit[unitName]!;
            
            // Remove from the map since we've processed it
            quizzesByUnit.remove(unitName);
          }
        }
        
        // Create new units for any remaining faculty quizzes that don't match existing units
        quizzesByUnit.forEach((unitName, quizzes) {
          units.add({
            'name': unitName,
            'topics': ['Faculty Created Content'],
            'quizzes': quizzes,
            'isFacultyUnit': true,
          });
        });
      }
      
      updatedSubject['units'] = units;
      updatedSubjects.add(updatedSubject);
    }
    
    return updatedSubjects;
  }

  bool _hasFacultyQuizzes(Map<String, dynamic> subject) {
    String subjectId = subject['id'];
    return _facultyQuizzes[subjectId]?.isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > 1200) {
      crossAxisCount = 3;
      childAspectRatio = 2.2;
    } else if (screenWidth > 800) {
      crossAxisCount = 2;
      childAspectRatio = 2.0;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 2.6;
    }

    return Scaffold(
      backgroundColor: primaryWhite,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: primaryBar,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryBar,
                      primaryButton,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quizzes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PTSerif-Bold',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Test your knowledge across various subjects',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontFamily: 'PTSerif',
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.quiz, color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      '${filteredSubjects.length} subjects available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : primaryBar,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          
          // Subjects Grid with Loading State
          _loadingFacultyQuizzes 
            ? SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryButton),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading faculty quizzes...',
                          style: TextStyle(
                            color: primaryBar.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
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
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map<String, dynamic> subject, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      child: Card(
        elevation: 8,
        shadowColor: subject['color'].withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _navigateToQuiz(context, subject);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  subject['color'].withOpacity(0.05),
                ],
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: subject['color'],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: subject['color'].withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    subject['icon'],
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subject['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryBar,
                          fontFamily: 'PTSerif-Bold',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            subject['category'],
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryBar.withOpacity(0.6),
                              fontFamily: 'PTSerif',
                            ),
                          ),
                          // Show faculty quiz indicator
                          if (_hasFacultyQuizzes(subject)) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Faculty Quizzes',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: subject['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: subject['color'],
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'View Subject',
                        style: TextStyle(
                          color: subject['color'],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context, Map<String, dynamic> subject) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SubjectDetailScreen(subject: subject),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

class QuizTakingScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;
  QuizTakingScreen({required this.quiz});

  @override
  _QuizTakingScreenState createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> with TickerProviderStateMixin {
  int current = 0;
  Map<int, int> answers = {};
  Duration remaining = Duration(minutes: 5);
  Timer? _timer;
  late AnimationController _progressController;
  late AnimationController _questionController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;
  List<Map<String, dynamic>> _mcqs = [];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(seconds: 300), // 5 minutes
      vsync: this,
    );
    _questionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_progressController);
    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _questionController, curve: Curves.easeOut));
    
    _progressController.forward();
    _questionController.forward();
  // Prepare shuffled MCQs for this attempt
  final raw = (widget.quiz['sections']?['mcq'] ?? []) as List;
  _mcqs = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  _shuffleMcqs();
    
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (remaining.inSeconds <= 1) {
        t.cancel();
        _finish();
      } else {
        setState(() => remaining = Duration(seconds: remaining.inSeconds - 1));
      }
    });
  }

  void _shuffleMcqs() {
    // Determine base seed from user id and quiz id so shuffle differs per user
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String quizId = (widget.quiz['id'] ?? widget.quiz['key'] ?? '').toString();
    int baseSeed = uid.isNotEmpty ? _stableSeed(uid + '::' + quizId) : DateTime.now().millisecondsSinceEpoch;

    // Shuffle options inside each question and update correct index using question-specific seed
    for (int i = 0; i < _mcqs.length; i++) {
      final q = Map<String, dynamic>.from(_mcqs[i]);
      final List opts = List.from(q['options'] ?? q['choices'] ?? []);
      final int correctIndex = q['correct'] ?? 0;

      final List<Map<String, dynamic>> paired = [];
      for (int j = 0; j < opts.length; j++) paired.add({'text': opts[j], 'orig': j});

      paired.shuffle(Random(baseSeed + i));
      final List newOptions = paired.map((p) => p['text']).toList();
      final int newCorrect = paired.indexWhere((p) => p['orig'] == correctIndex);

      // Update fields used by this UI
      q['options'] = newOptions;
      q['correct'] = newCorrect >= 0 ? newCorrect : 0;
      _mcqs[i] = q;
    }

    // Shuffle question order using baseSeed to make question ordering stable per user
    _mcqs.shuffle(Random(baseSeed ^ 0x9e3779b1));
  }

  int _stableSeed(String s) {
    int h = 0;
    for (int i = 0; i < s.length; i++) {
      h = (h * 31 + s.codeUnitAt(i)) & 0x7fffffff;
    }
    return h;
  }

  void _finish() {
    _timer?.cancel();
    int score = 0;
    for (int i = 0; i < _mcqs.length; i++) if (answers[i] == _mcqs[i]['correct']) score++;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuizResultScreen(
          score: score,
          total: _mcqs.length,
          quizTitle: widget.quiz['title'] ?? 'Quiz',
          quizColor: widget.quiz['color'] ?? primaryButton,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _nextQuestion() {
    if (current < _mcqs.length - 1) {
      _questionController.reset();
      setState(() => current++);
      _questionController.forward();
    } else {
      _finish();
    }
  }

  void _previousQuestion() {
    if (current > 0) {
      _questionController.reset();
      setState(() => current--);
      _questionController.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  String _fmt(Duration d) => '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
  if (_mcqs.isEmpty) return Scaffold(body: Center(child: Text('No questions')));
  final q = _mcqs[current];
  final quizColor = widget.quiz['color'] ?? primaryButton;

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          widget.quiz['title'] ?? 'Quiz',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: quizColor,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  _fmt(remaining),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: quizColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${current + 1} of ${_mcqs.length}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontFamily: 'PTSerif',
                      ),
                    ),
                    Text(
                      '${((current + 1) / _mcqs.length * 100).round()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (current + 1) / _mcqs.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          
          // Question Section
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: quizColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        q['question'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBar,
                          height: 1.4,
                          fontFamily: 'PTSerif-Bold',
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: (q['options'] as List).length,
                        itemBuilder: (context, optionIndex) {
                          final option = (q['options'] as List)[optionIndex];
                          final isSelected = answers[current] == optionIndex;
                          
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => setState(() => answers[current] = optionIndex),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? quizColor.withOpacity(0.1) : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? quizColor : Colors.grey.withOpacity(0.3),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: quizColor.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ] : [],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? quizColor : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected ? quizColor : Colors.grey.withOpacity(0.5),
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(Icons.check, color: Colors.white, size: 16)
                                            : null,
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isSelected ? quizColor : primaryBar,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            fontFamily: 'PTSerif',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (current > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _previousQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: primaryBar,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (current > 0) SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: answers[current] != null ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: quizColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                      child: Text(
                      current < _mcqs.length - 1 ? 'Next Question' : 'Submit Quiz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String quizTitle;
  final Color quizColor;

  QuizResultScreen({
    required this.score,
    required this.total,
    required this.quizTitle,
    this.quizColor = Colors.blue,
  });

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scoreController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _scoreAnimation = Tween<double>(begin: 0.0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 500), () {
      _scoreController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  String get _performanceText {
    final percentage = (widget.score / widget.total) * 100;
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Great Job!';
    if (percentage >= 70) return 'Good Work!';
    if (percentage >= 60) return 'Not Bad!';
    return 'Keep Trying!';
  }

  Color get _performanceColor {
    final percentage = (widget.score / widget.total) * 100;
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.lightGreen;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.total) * 100;
    
    return Scaffold(
      backgroundColor: primaryWhite,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.quizColor,
                      widget.quizColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PTSerif-Bold',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.quizTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontFamily: 'PTSerif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      
                      // Score Circle
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _performanceColor.withOpacity(0.1),
                                _performanceColor.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: _performanceColor.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _scoreAnimation,
                                  builder: (context, child) {
                                    return Text(
                                      '${_scoreAnimation.value.round()}',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: _performanceColor,
                                        fontFamily: 'PTSerif-Bold',
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  '/ ${widget.total}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: primaryBar.withOpacity(0.6),
                                    fontFamily: 'PTSerif',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _performanceColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${percentage.round()}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _performanceColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Performance Text
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          _performanceText,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _performanceColor,
                            fontFamily: 'PTSerif-Bold',
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      Text(
                        percentage >= 70 
                            ? 'You have a good understanding of the subject!'
                            : 'Review the topics and try again to improve your score.',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryBar.withOpacity(0.7),
                          fontFamily: 'PTSerif',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      Spacer(),
                      
                      // Action Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.quizColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'Back to Quizzes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: widget.quizColor,
                                side: BorderSide(color: widget.quizColor),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Small pre-quiz details form (kept minimal and reusable).
class PreQuizFormScreen extends StatefulWidget {
  @override
  State<PreQuizFormScreen> createState() => _PreQuizFormScreenState();
}

class _PreQuizFormScreenState extends State<PreQuizFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _universityController = TextEditingController();
  final _courseController = TextEditingController();

  @override
  void dispose() {
    _universityController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'), backgroundColor: primaryBar),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: _universityController, decoration: InputDecoration(labelText: 'University')), 
            SizedBox(height:12),
            TextFormField(controller: _courseController, decoration: InputDecoration(labelText: 'Course')),
            Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { if (_formKey.currentState?.validate() ?? true) Navigator.pop(context, {'university': _universityController.text.trim(), 'course': _courseController.text.trim()}); }, child: Text('Continue')))
          ]),
        ),
      ),
    );
  }
}
