import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../utils/download_helper.dart' as download_helper;

class FacultyQuizSubmissionsList extends StatelessWidget {
  final String subjectKey;
  final String subjectLabel;
  final String? quizId;
  final String? quizTitle;

  const FacultyQuizSubmissionsList({
    Key? key,
    required this.subjectKey,
    required this.subjectLabel,
    this.quizId,
    this.quizTitle,
  }) : super(key: key);

  Stream<QuerySnapshot<Map<String, dynamic>>> _buildStream() {
    final coll = FirebaseFirestore.instance.collection('quiz_submissions');
    // Stream by subjectKey; we'll filter client-side by quizId/quizTitle to
    // include older docs that might be missing quizId but have quizTitle set.
    return coll.where('subjectKey', isEqualTo: subjectKey).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizTitle != null && quizTitle!.isNotEmpty
            ? 'Submissions — ${quizTitle!}'
            : (quizId != null ? 'Submissions — $quizId' : 'All submissions — $subjectLabel')),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _buildStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No submissions'));

          // Filter client-side for the requested quiz. Some older submissions
          // may be missing quizId but have a quizTitle; include those as well.
          final filtered = docs.where((doc) {
            final d = doc.data();
            if (quizId != null && quizId!.isNotEmpty) {
              if ((d['quizId'] ?? '') == quizId) return true;
            }
            if (quizTitle != null && quizTitle!.isNotEmpty) {
              if ((d['quizTitle'] ?? '') == quizTitle) return true;
            }
            return false;
          }).toList();

          if (filtered.isEmpty) return Center(child: Text('No submissions for this quiz'));

          // sort by timestamp desc
          filtered.sort((a, b) {
            final ta = (a.data()['timestamp'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
            final tb = (b.data()['timestamp'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
            return tb.compareTo(ta);
          });

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final d = filtered[index].data();
              final studentName = d['studentName'] ?? 'Unknown';
              final qTitle = d['quizTitle'] ?? d['quizId'] ?? 'Quiz';
              final correctAnswers = d['correctAnswers'] != null ? d['correctAnswers'].toString() : (d['correct'] != null ? d['correct'].toString() : '');
              final timestamp = (d['timestamp'] as Timestamp?)?.toDate()?.toString().split('.')[0] ?? '';

              return Card(
                child: ListTile(
                  title: Text('$studentName — $qTitle'),
                  subtitle: Text('Correct: ${correctAnswers} • $timestamp'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: 'Delete submission',
                    onPressed: () async {
                      final docId = filtered[index].id;
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Delete submission'),
                          content: Text('Are you sure you want to delete this submission by $studentName? This action cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await FirebaseFirestore.instance.collection('quiz_submissions').doc(docId).delete();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submission deleted')));
                        } catch (e) {
                          print('Error deleting submission $docId: $e');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete submission: $e')));
                        }
                      }
                    },
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      final quizData = d['quizData'] as Map<String, dynamic>?;
                      final questions = (quizData != null && quizData['facultyQuestions'] != null)
                          ? List<Map<String, dynamic>>.from(quizData['facultyQuestions'])
                          : (quizData != null && quizData['questions'] != null)
                              ? List<Map<String, dynamic>>.from(quizData['questions'])
                              : <Map<String, dynamic>>[];

                      final answers = List<dynamic>.from(d['answers'] ?? []);

                      return AlertDialog(
                        title: Text('$studentName — $qTitle'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Basic metadata
                                if (d['studentId'] != null) Text('Student ID: ${d['studentId']}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                if (d['unit'] != null) Text('Unit: ${d['unit']}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                // Questions
                                ...List.generate(questions.length, (index) {
                                  final q = questions[index];
                                  final userAnswer = answers.length > index ? answers[index] : null;
                                  final correct = q['correct'];
                                  final options = List<String>.from(q['options'] ?? []);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${index + 1}. ${q['question'] ?? ''}', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 6),
                                        ...List.generate(options.length, (optIdx) {
                                          final opt = options[optIdx];
                                          final isUser = userAnswer == optIdx || userAnswer == opt;
                                          final isCorrect = correct == optIdx || correct == opt;
                                          Color bg = Colors.transparent;
                                          if (isCorrect) bg = Colors.green.withOpacity(0.12);
                                          else if (isUser && !isCorrect) bg = Colors.red.withOpacity(0.08);

                                          return Container(
                                            margin: EdgeInsets.only(bottom: 6),
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                Text('${String.fromCharCode(65 + optIdx)}. ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text(opt)),
                                                if (isCorrect)
                                                  Icon(Icons.check_circle, color: Colors.green, size: 18)
                                                else if (isUser && !isCorrect)
                                                  Icon(Icons.cancel, color: Colors.red, size: 18),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                }),
                                SizedBox(height: 8),
                                // Footer metadata
                                // Show correct answers and total questions when possible
                                Builder(builder: (_) {
                                  final total = questions.length;
                                  final correct = d['correctAnswers'] ?? d['correct'] ?? '';
                                  return Text('Correct answers: ${correct}${total > 0 ? ' / $total' : ''}');
                                }),
                                if (d['timeTakenSeconds'] != null) Text('Time taken: ${d['timeTakenSeconds']} seconds'),
                                if (d['timestamp'] != null) Text('Submitted: ${((d['timestamp'] as Timestamp?)?.toDate()?.toString() ?? '')}'),
                              ],
                            ),
                          ),
                        ),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
