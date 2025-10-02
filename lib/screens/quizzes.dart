import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';

/// Clean, single-file quizzes implementation.
/// Exposes `QuizzesScreen` as the main entry point for the Quizzes route.
class QuizzesScreen extends StatelessWidget {
  static const String routeName = '/quizzes';

  final List<Map<String, dynamic>> subjects = const [
    {'id': 'dsa', 'title': 'DSA', 'icon': Icons.code},
    {'id': 'iot', 'title': 'Internet of Things', 'icon': Icons.wifi_tethering},
    {'id': 'ml', 'title': 'Machine Learning', 'icon': Icons.auto_graph},
    {'id': 'cloud', 'title': 'Cloud Computing', 'icon': Icons.cloud},
  ];

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 2 : 1;

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text('Quizzes', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBar,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
            children: subjects.map((s) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Create a small sample quiz payload for the subject.
                    final quiz = {
                      'title': s['title'],
                      'sections': {
                        'mcq': [
                          {
                            'question': 'What is a key property of algorithms in ${s['title']}?',
                            'options': ['Simplicity', 'Correctness', 'Scalability'],
                            'correct': 1,
                            'explanation': 'Correctness is essential; other properties vary by problem.',
                          }
                        ]
                      }
                    };

                    Navigator.push(context, MaterialPageRoute(builder: (_) => QuizTakingScreen(quiz: quiz)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: primaryBar, borderRadius: BorderRadius.circular(8)),
                        child: Icon(s['icon'], color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Expanded(child: Text(s['title'], style: TextStyle(fontWeight: FontWeight.bold, color: primaryBar, fontSize: 16))),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
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

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  int current = 0;
  Map<int, int> answers = {};
  Duration remaining = Duration(minutes: 5);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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

  void _finish() {
    _timer?.cancel();
    final mcqs = (widget.quiz['sections']?['mcq'] ?? []) as List;
    int score = 0;
    for (int i = 0; i < mcqs.length; i++) if (answers[i] == mcqs[i]['correct']) score++;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizResultScreen(score: score, total: mcqs.length, quizTitle: widget.quiz['title'] ?? 'Quiz')));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) => '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final mcqs = (widget.quiz['sections']?['mcq'] ?? []) as List;
    if (mcqs.isEmpty) return Scaffold(body: Center(child: Text('No questions')));
    final q = mcqs[current];

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz['title'] ?? 'Quiz'), backgroundColor: primaryBar, actions: [Padding(padding: EdgeInsets.all(12), child: Center(child: Text(_fmt(remaining), style: TextStyle(color: Colors.white))))]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Q${current + 1}. ' + (q['question'] ?? ''), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...List<Widget>.from((q['options'] as List).asMap().entries.map((e) {
            final idx = e.key; final opt = e.value;
            return ListTile(leading: Radio<int>(value: idx, groupValue: answers[current], onChanged: (v) => setState(() => answers[current] = v ?? 0)), title: Text(opt));
          })),
          Spacer(),
          Row(children: [
            if (current > 0) ElevatedButton(onPressed: () => setState(() => current--), child: Text('Prev')),
            Spacer(),
            ElevatedButton(onPressed: () { if (current < mcqs.length - 1) setState(() => current++); else _finish(); }, child: Text(current < mcqs.length - 1 ? 'Next' : 'Submit'))
          ])
        ]),
      ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String quizTitle;

  QuizResultScreen({required this.score, required this.total, required this.quizTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result'), backgroundColor: primaryBar),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(quizTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height:8), Text('$score / $total', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), SizedBox(height:12), ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Back'))])),
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
