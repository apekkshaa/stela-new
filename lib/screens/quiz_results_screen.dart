import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizResultsScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;
  final Map<String, dynamic> subject;
  final List<Map<String, dynamic>> questions;
  final List<int?> userAnswers;
  final int correctAnswers;
  final double percentage;
  final Duration timeTaken;
  final String? submissionDocId;
  const QuizResultsScreen({
    Key? key,
    required this.quiz,
    required this.subject,
    required this.questions,
    required this.userAnswers,
    required this.correctAnswers,
    required this.percentage,
    required this.timeTaken,
    this.submissionDocId,
  }) : super(key: key);

  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {

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
  backgroundColor: widget.subject['color'],
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
              color: widget.subject['color'],
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
                    widget.quiz['title'] ?? 'Quiz Results',
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
                          '${widget.percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.percentage >= 70 ? Colors.green : Colors.orange,
                            fontFamily: 'PTSerif',
                          ),
                        ),
                        Text(
                          '${widget.correctAnswers}/${widget.questions.length}',
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
                    widget.correctAnswers.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Incorrect',
                    (widget.questions.length - widget.correctAnswers).toString(),
                    Colors.red,
                    Icons.cancel,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Time Taken',
                    _formatDuration(widget.timeTaken),
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
                Icon(Icons.analytics, color: widget.subject['color']),
                SizedBox(width: 8),
                Text(
                  'Question Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.subject['color'],
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
              itemCount: widget.questions.length,
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
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context); // Go back to subject detail
                              },
                              icon: Icon(Icons.home, size: 20),
                              label: Text(
                                'Back to Subject',
                                style: TextStyle(fontFamily: 'PTSerif', fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.subject['color'],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Feedback button
                            ElevatedButton.icon(
                              onPressed: () async {
                                final uri = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSe4S0tVb06rrhOYuMaBdAfJaH0UtUslYvfTQcWw67feXAOeLw/viewform?usp=dialog');
                                try {
                                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open feedback form.')));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error opening feedback form.')));
                                }
                              },
                              icon: Icon(Icons.feedback, size: 20),
                              label: Text(
                                'Give Feedback',
                                style: TextStyle(fontFamily: 'PTSerif', fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: widget.subject['color'],
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: widget.subject['color']),
                                ),
                                elevation: 0,
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
    final question = widget.questions[index];
    final userAnswer = widget.userAnswers[index];
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
    final p = widget.percentage;
    if (p >= 90) return '🎉 Excellent! Outstanding performance!';
    if (p >= 80) return '👏 Great job! You\'re doing very well!';
    if (p >= 70) return '👍 Good work! Keep it up!';
    if (p >= 60) return '📚 Not bad! A bit more practice will help!';
    return '💪 Keep practicing! You\'ll improve with time!';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}