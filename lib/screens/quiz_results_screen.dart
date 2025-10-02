import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'faculty_quiz_taking_screen.dart';

class QuizResultsScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;
  final Map<String, dynamic> subject;
  final List<Map<String, dynamic>> questions;
  final List<int?> userAnswers;
  final int correctAnswers;
  final double percentage;
  final Duration timeTaken;

  const QuizResultsScreen({
    Key? key,
    required this.quiz,
    required this.subject,
    required this.questions,
    required this.userAnswers,
    required this.correctAnswers,
    required this.percentage,
    required this.timeTaken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Quiz Results',
          style: TextStyle(
            fontFamily: 'PTSerif',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: subject['color'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to subject detail
          },
        ),
      ),
      body: Column(
        children: [
          // Header with overall results
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: subject['color'],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  // Quiz title
                  Text(
                    quiz['title'] ?? 'Quiz Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'PTSerif',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  
                  // Score circle
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: percentage >= 70 ? Colors.green : Colors.orange,
                            fontFamily: 'PTSerif',
                          ),
                        ),
                        Text(
                          '$correctAnswers/${questions.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'PTSerif',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Performance message
                  Text(
                    _getPerformanceMessage(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'PTSerif',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          // Statistics cards
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Correct',
                    correctAnswers.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Incorrect',
                    (questions.length - correctAnswers).toString(),
                    Colors.red,
                    Icons.cancel,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Time Taken',
                    _formatDuration(timeTaken),
                    Colors.blue,
                    Icons.timer,
                  ),
                ),
              ],
            ),
          ),
          
          // Question-wise analysis header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.analytics, color: subject['color']),
                SizedBox(width: 8),
                Text(
                  'Question Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: subject['color'],
                    fontFamily: 'PTSerif',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          
          // Question-wise results
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionCard(index);
              },
            ),
          ),
          
          // Action buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Retake quiz - go back to quiz taking screen
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FacultyQuizTakingScreen(
                            quiz: quiz,
                            subject: subject,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.refresh),
                    label: Text(
                      'Retake Quiz',
                      style: TextStyle(fontFamily: 'PTSerif'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Go back to subject detail
                    },
                    icon: Icon(Icons.home),
                    label: Text(
                      'Back to Subject',
                      style: TextStyle(fontFamily: 'PTSerif'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subject['color'],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'PTSerif',
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontFamily: 'PTSerif',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = questions[index];
    final userAnswer = userAnswers[index];
    final correctAnswer = question['correct'];
    final isCorrect = userAnswer == correctAnswer;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PTSerif',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        isCorrect ? 'Correct' : 'Incorrect',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green : Colors.red,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            
            // Question text
            Text(
              question['question'] ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'PTSerif',
              ),
            ),
            SizedBox(height: 12),
            
            // Options
            ...List.generate(question['options']?.length ?? 0, (optionIndex) {
              final option = question['options'][optionIndex];
              final isUserAnswer = userAnswer == optionIndex;
              final isCorrectAnswer = correctAnswer == optionIndex;
              
              Color optionColor = Colors.grey[200]!;
              Color textColor = Colors.black;
              IconData? optionIcon;
              
              if (isCorrectAnswer) {
                optionColor = Colors.green.withOpacity(0.2);
                textColor = Colors.green[800]!;
                optionIcon = Icons.check_circle;
              } else if (isUserAnswer && !isCorrect) {
                optionColor = Colors.red.withOpacity(0.2);
                textColor = Colors.red[800]!;
                optionIcon = Icons.cancel;
              }
              
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: optionColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrectAnswer ? Colors.green : 
                           (isUserAnswer && !isCorrect) ? Colors.red : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${String.fromCharCode(65 + optionIndex)}. ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'PTSerif',
                      ),
                    ),
                    Expanded(
                      child: Text(
                        option ?? '',
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ),
                    if (optionIcon != null)
                      Icon(
                        optionIcon,
                        color: isCorrectAnswer ? Colors.green : Colors.red,
                        size: 20,
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getPerformanceMessage() {
    if (percentage >= 90) return '🎉 Excellent! Outstanding performance!';
    if (percentage >= 80) return '👏 Great job! You\'re doing very well!';
    if (percentage >= 70) return '👍 Good work! Keep it up!';
    if (percentage >= 60) return '📚 Not bad! A bit more practice will help!';
    return '💪 Keep practicing! You\'ll improve with time!';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}