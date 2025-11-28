import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class ViewProgressPage extends StatefulWidget {
  @override
  _ViewProgressPageState createState() => _ViewProgressPageState();
}

class _ViewProgressPageState extends State<ViewProgressPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _submissions = [];

  // Map subjectLabel -> list of percentages
  Map<String, List<double>> _subjectScores = {};

  double _overallAverage = 0.0;
  bool _indexError = false;
  String? _indexUrl;

  @override
  void initState() {
    super.initState();
    _fetchSubmissions();
  }

  Future<void> _fetchSubmissions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      // Fetch matching docs without server-side ordering to avoid requiring a composite index.
      final query = await FirebaseFirestore.instance
          .collection('quiz_submissions')
          .where('studentId', isEqualTo: user.uid)
          .get();

      final docs = query.docs;
      _submissions = docs.map((d) {
        final data = d.data();
        return {
          'id': d.id,
          'quizId': data['quizId'] ?? '',
          'quizTitle': data['quizTitle'] ?? data['quizData']?['title'] ?? '',
          'subjectLabel': data['subjectLabel'] ?? data['subjectId'] ?? 'Unknown',
          'percentage': (data['percentage'] is num) ? (data['percentage'] as num).toDouble() : double.tryParse((data['percentage'] ?? '0').toString()) ?? 0.0,
          'timeTakenSeconds': data['timeTakenSeconds'] ?? 0,
          'timestamp': data['timestamp'],
        };
      }).toList();

      // Perform client-side sort by timestamp descending. This avoids the need
      // for a Firestore composite index (which would be required for a where+orderBy).
      int _timestampToMillis(dynamic t) {
        if (t == null) return 0;
        try {
          if (t is Timestamp) return t.toDate().millisecondsSinceEpoch;
          if (t is DateTime) return t.millisecondsSinceEpoch;
          if (t is int) return t;
          return int.tryParse(t.toString()) ?? 0;
        } catch (_) {
          return 0;
        }
      }

      _submissions.sort((a, b) => _timestampToMillis(b['timestamp']).compareTo(_timestampToMillis(a['timestamp'])));
      _indexError = false;

      // Aggregate per-subject
      _subjectScores.clear();
      for (var s in _submissions) {
        final label = s['subjectLabel'] ?? 'Unknown';
        final pct = (s['percentage'] ?? 0.0) as double;
        _subjectScores.putIfAbsent(label, () => []).add(pct);
      }

      // Compute overall average across all submissions
      if (_submissions.isNotEmpty) {
        double sum = _submissions.map((s) => s['percentage'] as double).reduce((a, b) => a + b);
        _overallAverage = sum / _submissions.length / 100.0; // normalize to 0..1
      } else {
        _overallAverage = 0.0;
      }
    } catch (e) {
      print('Error fetching submissions: $e');
      // Detect Firestore index requirement error and surface a helpful message
      if (e is FirebaseException && e.code == 'failed-precondition') {
        // The console link in the firestore error message points to index creation
        _indexError = true;
        // Use known project console URL from the exception message if present,
        // otherwise fall back to the generic link shown in the earlier error.
        final msg = e.message ?? '';
        final urlMatch = RegExp(r'https:\/\/console\.firebase\.google\.com\/.+?indexes\?create_composite=[^\s]+').firstMatch(msg);
        if (urlMatch != null) {
          _indexUrl = urlMatch.group(0);
        } else {
          _indexUrl = 'https://console.firebase.google.com/project/stela23-f9a52/firestore/indexes';
        }
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Progress', style: TextStyle(fontFamily: 'PTSerif-Bold')),
        backgroundColor: primaryBar,
        elevation: 0,
      ),
      backgroundColor: primaryWhite,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _indexError
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 52, color: Colors.orange),
                        SizedBox(height: 12),
                        Text(
                          'A Firestore index is required to load your progress.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Create the index in Firebase Console or deploy `firestore.indexes.json`.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryBar.withOpacity(0.8)),
                        ),
                        SizedBox(height: 12),
                        SelectableText(_indexUrl ?? ''),
                        SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_indexUrl != null) {
                                  Clipboard.setData(ClipboardData(text: _indexUrl ?? ''));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Index URL copied to clipboard')));
                                }
                              },
                              child: Text('Copy URL'),
                            ),
                            SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {
                                if (_indexUrl != null) {
                                  Clipboard.setData(ClipboardData(text: _indexUrl ?? ''));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Index URL copied to clipboard. Open the Firebase Console to create the index.')));
                                }
                              },
                              child: Text('Open Console'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryButton.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBar.withOpacity(0.07),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.bar_chart, color: primaryButton, size: 36),
                          SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Overall Progress',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'PTSerif-Bold',
                                    color: primaryBar,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: _overallAverage,
                                  backgroundColor: primaryBar.withOpacity(0.12),
                                  color: primaryButton,
                                  minHeight: 8,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '${(_overallAverage * 100).toStringAsFixed(1)}% Complete',
                                  style: TextStyle(
                                    color: primaryButton,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    Text(
                      'Subject-wise Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'PTSerif-Bold',
                        color: primaryBar,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ..._subjectScores.entries.map((entry) {
                      final subject = entry.key;
                      final list = entry.value;
                      final avg = list.reduce((a, b) => a + b) / list.length / 100.0;
                      return _buildSubjectCard(subject, avg, list.length);
                    }).toList(),

                    SizedBox(height: 18),
                    Text(
                      'Quiz Attempts',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'PTSerif-Bold',
                        color: primaryBar,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),

                    if (_submissions.isEmpty)
                      Center(child: Text('No quiz attempts found.'))
                    else
                      ..._submissions.map((s) => _buildAttemptCard(s)).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSubjectCard(String subject, double progress, int attempts) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryButton.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(color: primaryBar.withOpacity(0.04), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book, color: primaryButton),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: TextStyle(fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.w700, color: primaryBar)),
                SizedBox(height: 6),
                LinearProgressIndicator(value: progress, backgroundColor: primaryBar.withOpacity(0.12), color: primaryButton, minHeight: 8),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(progress * 100).toStringAsFixed(0)}%', style: TextStyle(color: primaryButton, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('$attempts attempts', style: TextStyle(color: primaryBar.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptCard(Map<String, dynamic> s) {
    DateTime? ts;
    if (s['timestamp'] is Timestamp) {
      ts = (s['timestamp'] as Timestamp).toDate();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryButton.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(Icons.quiz, color: primaryBar),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['quizTitle'] ?? 'Quiz', style: TextStyle(fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.w700, color: primaryBar)),
                SizedBox(height: 6),
                Text(s['subjectLabel'] ?? '', style: TextStyle(color: primaryBar.withOpacity(0.7), fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(s['percentage'] as double).toStringAsFixed(1)}%', style: TextStyle(color: primaryButton, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(ts != null ? '${ts.year}-${ts.month.toString().padLeft(2,'0')}-${ts.day.toString().padLeft(2,'0')}' : '', style: TextStyle(color: primaryBar.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
