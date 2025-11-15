import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'quiz_results_screen.dart';

class FacultyQuizTakingScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;
  final Map<String, dynamic> subject;

  const FacultyQuizTakingScreen({
    Key? key,
    required this.quiz,
    required this.subject,
  }) : super(key: key);

  @override
  _FacultyQuizTakingScreenState createState() => _FacultyQuizTakingScreenState();
}

class _FacultyQuizTakingScreenState extends State<FacultyQuizTakingScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> selectedAnswers = {};
  List<Map<String, dynamic>> questions = [];
  Timer? _timer;
  int timeRemaining = 0; // in seconds
  int totalTimeAllocated = 0; // in seconds
  bool quizCompleted = false;
  DateTime? quizStartTime;
  bool _alreadySubmitted = false;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    questions = List<Map<String, dynamic>>.from(widget.quiz['facultyQuestions'] ?? []);
    
    // Parse duration and set timer
    String duration = widget.quiz['duration'] ?? '15 min';
    int minutes = int.tryParse(duration.split(' ')[0]) ?? 15;
    timeRemaining = minutes * 60;
    totalTimeAllocated = minutes * 60;
    
    // Record start time
    quizStartTime = DateTime.now();
    
    _startTimer();
    // Check if the current user has already submitted this quiz
    _checkExistingSubmission();
  }

  Future<void> _checkExistingSubmission() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final studentId = user?.uid;
      if (studentId == null || studentId.isEmpty) return;
      final quizId = (widget.quiz['id'] ?? widget.quiz['key'] ?? '').toString();
      if (quizId.isEmpty) return;
      final snap = await FirebaseFirestore.instance
          .collection('quiz_submissions')
          .where('quizId', isEqualTo: quizId)
          .where('studentId', isEqualTo: studentId)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        setState(() {
          _alreadySubmitted = true;
        });
      }
    } catch (e) {
      print('Error checking existing submission: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        _completeQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _completeQuiz();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _completeQuiz() {
    _timer?.cancel();
    setState(() {
      quizCompleted = true;
    });
    _showResults();
  }

  Future<void> _showResults() async {
    int correctAnswers = 0;
    List<int?> userAnswers = [];
    
    // Calculate results and prepare user answers array
    for (int i = 0; i < questions.length; i++) {
      int? selectedAnswer = selectedAnswers[i];
      userAnswers.add(selectedAnswer);
      
      int correctAnswer = questions[i]['correct'] ?? 0;
      if (selectedAnswer == correctAnswer) {
        correctAnswers++;
      }
    }

    double percentage = (correctAnswers / questions.length) * 100;
    
    // Calculate time taken
    Duration timeTaken = quizStartTime != null 
        ? DateTime.now().difference(quizStartTime!)
        : Duration(seconds: totalTimeAllocated - timeRemaining);

  // Persist submission to Firestore so faculty can view it
  String? submissionDocId;
    // Double-check to prevent multiple submissions (race condition)
    try {
      final user = FirebaseAuth.instance.currentUser;
      final studentId = user?.uid ?? '';
      final quizIdCheck = (widget.quiz['id'] ?? widget.quiz['key'] ?? '').toString();
      if (studentId.isNotEmpty && quizIdCheck.isNotEmpty) {
        final existing = await FirebaseFirestore.instance
            .collection('quiz_submissions')
            .where('quizId', isEqualTo: quizIdCheck)
            .where('studentId', isEqualTo: studentId)
            .limit(1)
            .get();
        if (existing.docs.isNotEmpty) {
          // Already submitted
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have already submitted this quiz. Multiple attempts are not allowed.')));
          }
          return;
        }
      }
    } catch (e) {
      print('Error checking existing submission before save: $e');
    }
  try {
      final user = FirebaseAuth.instance.currentUser;
      final studentId = user?.uid ?? '';
      String studentName = '';
      if (studentId.isNotEmpty) {
        final studentDoc = await FirebaseFirestore.instance.collection('students').doc(studentId).get();
        if (studentDoc.exists) {
          final data = studentDoc.data();
          studentName = data?['name'] ?? '';
        }
      }

      // Resolve faculty info: prefer widget.quiz fields but try to lookup in Realtime DB when missing.
      String facultyId = widget.quiz['createdBy'] ?? '';
      String facultyName = widget.quiz['createdByName'] ?? '';

      // Compute a subjectKey that matches the Realtime DB structure used by QuizService.
      String _mapSubjectIdToFacultyKey(String subjectId) {
        final Map<String, String> mappings = {
          'aipt': 'Artificial_Intelligence_-_Programming_Tools',
          'artificial_intelligence_programming_tools': 'Artificial_Intelligence_-_Programming_Tools',
          'cloud': 'Cloud_Computing',
          'cloud_computing': 'Cloud_Computing',
          'compiler': 'Compiler_Design',
          'compiler_design': 'Compiler_Design',
          'networks': 'Computer_Networks',
          'computer_networks': 'Computer_Networks',
          'coa': 'Computer_Organization_and_Architecture',
          'computer_organization_and_architecture': 'Computer_Organization_and_Architecture',
          'ml': 'Machine_Learning',
          'machine_learning': 'Machine_Learning',
          'wireless': 'Wireless_Networks',
          'wireless_networks': 'Wireless_Networks',
          'iot': 'Internet_of_Things',
          'internet_of_things': 'Internet_of_Things',
          'c_programming': 'C_Programming',
        };
        return mappings[subjectId] ?? subjectId.replaceAll('_', '_');
      }

      final rawSubjectId = (widget.subject['id'] ?? widget.subject['label'] ?? '').toString();
      final subjectKey = _mapSubjectIdToFacultyKey(rawSubjectId);

      if (facultyId.isEmpty || facultyName.isEmpty) {
        try {
          // Attempt to find the quiz in Realtime Database under the subjectKey and extract creator metadata.
          print('Debug: attempting RTDB lookup for subjectKey="$subjectKey" (raw="$rawSubjectId")');
          if (subjectKey.isNotEmpty) {
            final dbRef = FirebaseDatabase.instance.ref().child('quizzes').child(subjectKey);
            final snap = await dbRef.get();
            print('Debug: RTDB snap.exists=${snap.exists}');
            if (snap.exists) {
              final data = snap.value as Map<dynamic, dynamic>;
              print('Debug: RTDB entries=${data.keys.length}');

              // Helper to compare candidate quiz map with widget.quiz
              bool matchesQuiz(Map<dynamic, dynamic> candidate) {
                try {
                  // Fallback: match by title and duration and number of questions
                  final t1 = (candidate['title'] ?? '').toString();
                  final t2 = (widget.quiz['title'] ?? '').toString();
                  final d1 = (candidate['duration'] ?? '').toString();
                  final d2 = (widget.quiz['duration'] ?? '').toString();
                  final q1 = (candidate['questions'] is List) ? (candidate['questions'] as List).length : 0;
                  final q2 = (widget.quiz['questions'] is List) ? (widget.quiz['questions'] as List).length : 0;
                  return t1 == t2 && d1 == d2 && q1 == q2;
                } catch (e) {
                  return false;
                }
              }

              // Search top-level entries for either unit -> quiz or direct quiz
              bool found = false;
              for (var entry in data.entries) {
                final key = entry.key;
                final value = entry.value;
                if (value is Map) {
                  // If this looks like a unit (contains nested quizzes)
                  bool isUnit = false;
                  value.forEach((subKey, subValue) {
                    if (subValue is Map && subValue.containsKey('title') && subValue.containsKey('questions')) {
                      isUnit = true;
                    }
                  });

                  if (isUnit) {
                    // iterate nested quizzes
                    value.forEach((subKey, subValue) {
                      if (!found && subValue is Map) {
                        // If widget.quiz has a key, try to match by it
                        if (widget.quiz.containsKey('key') && widget.quiz['key'] != null && widget.quiz['key'].toString().isNotEmpty) {
                          if (widget.quiz['key'].toString() == subKey.toString()) {
                            facultyId = subValue['createdBy']?.toString() ?? facultyId;
                            facultyName = subValue['createdByName']?.toString() ?? facultyName;
                            found = true;
                          }
                        } else if (matchesQuiz(subValue)) {
                          facultyId = subValue['createdBy']?.toString() ?? facultyId;
                          facultyName = subValue['createdByName']?.toString() ?? facultyName;
                          found = true;
                        }
                      }
                    });
                  } else {
                    // direct quiz
                    if (!found && value.containsKey('title') && value.containsKey('questions')) {
                      if (widget.quiz.containsKey('key') && widget.quiz['key'] != null && widget.quiz['key'].toString().isNotEmpty) {
                        if (widget.quiz['key'].toString() == key.toString()) {
                          facultyId = value['createdBy']?.toString() ?? facultyId;
                          facultyName = value['createdByName']?.toString() ?? facultyName;
                          found = true;
                        }
                      } else if (matchesQuiz(value)) {
                        facultyId = value['createdBy']?.toString() ?? facultyId;
                        facultyName = value['createdByName']?.toString() ?? facultyName;
                        found = true;
                      }
                    }
                  }
                }
                if (found) break;
              }
              print('Debug: RTDB lookup finished, found=$found facultyId="$facultyId" facultyName="$facultyName"');
            }
          }
        } catch (e) {
          print('Error resolving quiz creator from Realtime DB: $e');
        }
      }

      final submission = {
        'quizId': widget.quiz['id'] ?? widget.quiz['key'] ?? '',
        'quizTitle': widget.quiz['title'] ?? '',
        'subjectLabel': (widget.subject['label'] ?? widget.subject['id'] ?? '').toString(),
        'subjectKey': subjectKey,
        'subjectId': rawSubjectId,
        'unit': widget.quiz['unit'] ?? '',
        'facultyId': facultyId,
        'facultyName': facultyName,
        'studentId': studentId,
        'studentName': studentName,
        'answers': userAnswers,
        'correctAnswers': correctAnswers,
        'percentage': percentage,
        'timeTakenSeconds': timeTaken.inSeconds,
        'timestamp': FieldValue.serverTimestamp(),
        // mark as sent to faculty immediately when student submits
        'sentToFaculty': FieldValue.serverTimestamp(),
        // store the quiz data so faculty can review questions with answers
        'quizData': widget.quiz,
      };

    final docRef = await FirebaseFirestore.instance.collection('quiz_submissions').add(submission);
    submissionDocId = docRef.id;
      print('Submission saved with id: ${docRef.id} and facultyId: ${submission['facultyId']} subjectLabel: ${submission['subjectLabel']}');
      // Read back the saved document to confirm what was written
      try {
        final saved = await docRef.get();
        if (saved.exists) {
          final savedData = saved.data();
          print('Saved doc data: $savedData');
        } else {
          print('Saved doc not found after write (unexpected)');
        }
      } catch (e) {
        print('Error reading back saved submission: $e');
      }
      // Show brief confirmation to student (non-blocking)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quiz submitted successfully — results sent to faculty')),
        );
      }
    } catch (e) {
      print('Error saving quiz submission: $e');
    }

    // Navigate to detailed results screen, pass submission doc id so results can be sent/updated
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          quiz: widget.quiz,
          subject: widget.subject,
          questions: questions,
          userAnswers: userAnswers,
          correctAnswers: correctAnswers,
          percentage: percentage,
          timeTaken: timeTaken,
          submissionDocId: submissionDocId,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_alreadySubmitted) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz['title'] ?? 'Quiz'),
          backgroundColor: widget.subject['color'],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You have already attempted this quiz. Multiple attempts are not allowed.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                SizedBox(height: 12),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Back')),
              ],
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: widget.subject['color'],
        ),
        body: Center(
          child: Text('No questions available for this quiz.'),
        ),
      );
    }

    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];
    List<String> options = List<String>.from(currentQuestion['options'] ?? []);

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(widget.quiz['title']),
        backgroundColor: widget.subject['color'],
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, size: 16),
                SizedBox(width: 4),
                Text(
                  _formatTime(timeRemaining),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} of ${questions.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryBar,
                      ),
                    ),
                    Text(
                      '${((currentQuestionIndex + 1) / questions.length * 100).toStringAsFixed(0)}% Complete',
                      style: TextStyle(
                        color: primaryBar.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(widget.subject['color']),
                ),
              ],
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion['question'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryBar,
                        height: 1.4,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Options
                  ...options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;
                    bool isSelected = selectedAnswers[currentQuestionIndex] == index;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? widget.subject['color'].withOpacity(0.1)
                              : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                ? widget.subject['color']
                                : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected 
                                    ? widget.subject['color']
                                    : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected 
                                      ? widget.subject['color']
                                      : Colors.grey[400]!,
                                  ),
                                ),
                                child: isSelected 
                                  ? Icon(Icons.check, color: Colors.white, size: 16)
                                  : null,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryBar,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: widget.subject['color']),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(color: widget.subject['color']),
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: selectedAnswers[currentQuestionIndex] != null
                      ? (currentQuestionIndex == questions.length - 1 
                          ? _completeQuiz 
                          : _nextQuestion)
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.subject['color'],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentQuestionIndex == questions.length - 1 
                        ? 'Complete Quiz' 
                        : 'Next Question',
                      style: TextStyle(fontWeight: FontWeight.w600),
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