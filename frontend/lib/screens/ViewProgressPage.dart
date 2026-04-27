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

  Map<String, _SubjectStats> _subjectStats = {};

  double _overallAverage = 0.0;
  double _overallAverageScore = 0.0;
  double _bestScore = 0.0;
  int _totalAttempts = 0;
  int _averageTimeSeconds = 0;
  DateTime? _lastAttempt;
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
      _subjectStats.clear();
      for (var s in _submissions) {
        final label = s['subjectLabel'] ?? 'Unknown';
        final pct = (s['percentage'] ?? 0.0) as double;

        final stats = _subjectStats.putIfAbsent(label, () => _SubjectStats(subject: label));
        stats.attempts += 1;
        stats.totalScore += pct;
        if (pct > stats.bestScore) {
          stats.bestScore = pct;
        }
        if (stats.lastScore == null) {
          stats.lastScore = pct;
          stats.lastAttempt = _timestampToDate(s['timestamp']);
        } else if (stats.prevScore == null) {
          stats.prevScore = pct;
        }
      }

      for (final stats in _subjectStats.values) {
        stats.averageScore = stats.attempts > 0 ? (stats.totalScore / stats.attempts) : 0.0;
      }

      final attempts = _submissions.length;
      _totalAttempts = attempts;
      if (attempts > 0) {
        final sum = _submissions.map((s) => s['percentage'] as double).reduce((a, b) => a + b);
        _overallAverageScore = sum / attempts;
        _overallAverage = _overallAverageScore / 100.0;
        _bestScore = _submissions.map((s) => s['percentage'] as double).reduce((a, b) => a > b ? a : b);
        _lastAttempt = _timestampToDate(_submissions.first['timestamp']);

        final timeValues = _submissions
            .map((s) => (s['timeTakenSeconds'] ?? 0) as int)
            .where((t) => t > 0)
            .toList();
        if (timeValues.isNotEmpty) {
          _averageTimeSeconds = (timeValues.reduce((a, b) => a + b) / timeValues.length).round();
        } else {
          _averageTimeSeconds = 0;
        }
      } else {
        _overallAverageScore = 0.0;
        _overallAverage = 0.0;
        _bestScore = 0.0;
        _averageTimeSeconds = 0;
        _lastAttempt = null;
      }

      // Compute overall average across all submissions
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
    final size = MediaQuery.of(context).size;
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
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primaryBar.withOpacity(0.08),
                        primaryWhite,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroCard(size),
                          SizedBox(height: 16),
                          _buildMetricsGrid(size),
                          SizedBox(height: 24),
                          _buildSectionHeader(
                            'Subject-wise Progress',
                            'Tap a subject to review trends',
                            Icons.menu_book,
                          ),
                          SizedBox(height: 12),
                          if (_subjectStats.isEmpty)
                            Center(child: Text('No subject progress yet.'))
                          else
                            ...(() {
                              final statsList = _subjectStats.values.toList()
                                ..sort((a, b) => b.averageScore.compareTo(a.averageScore));
                              return statsList.map((stats) => _buildSubjectCard(stats)).toList();
                            })(),
                          SizedBox(height: 18),
                          _buildSectionHeader(
                            'Quiz Attempts',
                            'Most recent first',
                            Icons.quiz,
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
                ),
    );
  }

  Widget _buildSubjectCard(_SubjectStats stats) {
    final progress = (stats.averageScore / 100.0).clamp(0.0, 1.0);
    final trend = stats.trendDelta;
    final trendIcon = trend == null
        ? Icons.remove
        : (trend >= 0 ? Icons.trending_up : Icons.trending_down);
    final trendColor = trend == null
        ? primaryBar.withOpacity(0.5)
        : (trend >= 0 ? Colors.green : Colors.red);

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
                Text(stats.subject, style: TextStyle(fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.w700, color: primaryBar)),
                SizedBox(height: 6),
                LinearProgressIndicator(value: progress, backgroundColor: primaryBar.withOpacity(0.12), color: primaryButton, minHeight: 8),
                SizedBox(height: 6),
                Row(
                  children: [
                    _buildPill('Best ${stats.bestScore.toStringAsFixed(1)}%', primaryButton.withOpacity(0.12), primaryButton),
                    SizedBox(width: 8),
                    _buildPill('Last ${stats.lastScore?.toStringAsFixed(1) ?? 'N/A'}%', primaryBar.withOpacity(0.08), primaryBar),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(trendIcon, size: 16, color: trendColor),
                  SizedBox(width: 4),
                  Text('${stats.averageScore.toStringAsFixed(1)}%', style: TextStyle(color: primaryButton, fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 6),
              Text('${stats.attempts} attempts', style: TextStyle(color: primaryBar.withOpacity(0.7), fontSize: 12)),
              SizedBox(height: 4),
              Text(_formatDate(stats.lastAttempt), style: TextStyle(color: primaryBar.withOpacity(0.6), fontSize: 11)),
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
    final score = (s['percentage'] as double);
    final scoreColor = score >= 85
        ? Colors.green
        : (score >= 70 ? Colors.orange : Colors.red);
    final timeTaken = _formatDuration((s['timeTakenSeconds'] ?? 0) as int);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryButton.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: primaryBar.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: scoreColor.withOpacity(0.12),
            child: Icon(Icons.quiz, color: scoreColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['quizTitle'] ?? 'Quiz', style: TextStyle(fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.w700, color: primaryBar)),
                SizedBox(height: 6),
                Text(s['subjectLabel'] ?? '', style: TextStyle(color: primaryBar.withOpacity(0.7), fontSize: 13)),
                SizedBox(height: 6),
                Text('Time: $timeTaken', style: TextStyle(color: primaryBar.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${score.toStringAsFixed(1)}%', style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(ts != null ? '${ts.year}-${ts.month.toString().padLeft(2,'0')}-${ts.day.toString().padLeft(2,'0')}' : '', style: TextStyle(color: primaryBar.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  DateTime? _timestampToDate(dynamic t) {
    if (t == null) return null;
    try {
      if (t is Timestamp) return t.toDate();
      if (t is DateTime) return t;
      if (t is int) return DateTime.fromMillisecondsSinceEpoch(t);
      final parsed = int.tryParse(t.toString());
      return parsed != null ? DateTime.fromMillisecondsSinceEpoch(parsed) : null;
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return 'N/A';
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    if (minutes <= 0) return '${remaining}s';
    return '${minutes}m ${remaining}s';
  }

  Widget _buildMetricChip(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryButton.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(color: primaryBar.withOpacity(0.04), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryButton, size: 18),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: primaryBar.withOpacity(0.7), fontSize: 11)),
              SizedBox(height: 2),
              Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: primaryBar)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color bg, Color fg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildHeroCard(Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBar.withOpacity(0.95),
            primaryButton.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(color: primaryBar.withOpacity(0.25), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bar_chart, color: Colors.white, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Learning Snapshot',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'PTSerif-Bold',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track how you improve over time',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Text(
            '${_overallAverageScore.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: _overallAverage,
            backgroundColor: Colors.white.withOpacity(0.15),
            color: Colors.white,
            minHeight: 8,
          ),
          SizedBox(height: 8),
          Text(
            'Average score across ${_totalAttempts} attempts',
            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Size size) {
    final isWide = size.width > 720;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildMetricChip('Attempts', _totalAttempts.toString(), Icons.layers),
        _buildMetricChip('Best Score', '${_bestScore.toStringAsFixed(1)}%', Icons.emoji_events),
        _buildMetricChip('Avg Time', _formatDuration(_averageTimeSeconds), Icons.timer),
        _buildMetricChip('Last Attempt', _formatDate(_lastAttempt), Icons.event),
        if (isWide)
          _buildMetricChip('Overall Avg', '${_overallAverageScore.toStringAsFixed(1)}%', Icons.analytics),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryButton.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: primaryBar.withOpacity(0.04), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryButton.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryButton, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontFamily: 'PTSerif-Bold', color: primaryBar),
                ),
                SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: primaryBar.withOpacity(0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectStats {
  final String subject;
  int attempts = 0;
  double totalScore = 0.0;
  double averageScore = 0.0;
  double bestScore = 0.0;
  double? lastScore;
  double? prevScore;
  DateTime? lastAttempt;

  _SubjectStats({required this.subject});

  double? get trendDelta {
    if (lastScore == null || prevScore == null) return null;
    return lastScore! - prevScore!;
  }
}
