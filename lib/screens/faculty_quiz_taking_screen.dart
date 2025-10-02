import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
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

  void _showResults() {
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

    // Navigate to detailed results screen
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