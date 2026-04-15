import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/ReportGenerationCOA.dart';

class COAAssessmentPage extends StatefulWidget {
  const COAAssessmentPage({super.key});

  @override
  State<COAAssessmentPage> createState() => _COAAssessmentPageState();
}

class _COAAssessmentPageState extends State<COAAssessmentPage> {
  final List<List<String>> _questions = [
    [
      'Fetch and execution cycles are interleaved with help of:',
      'Modification in processor architecture',
      'Clock',
      'Special unit',
      'Control unit',
    ],
    [
      'The register that includes memory unit address is:',
      'MAR',
      'PC',
      'IR',
      'None of these',
    ],
    [
      'Step in which instruction is read from memory is:',
      'Decode',
      'Fetch',
      'Execute',
      'None of these',
    ],
    [
      'An instruction is guided by ____ to perform work accordingly.',
      'PC',
      'ALU',
      'Both a and b',
      'CPU',
    ],
  ];

  final List<String> _correct = [
    'Clock',
    'MAR',
    'Fetch',
    'CPU',
  ];

  late final List<String> _selected = List.filled(_questions.length, '');

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selected[i] == _correct[i]) {
        correct++;
      }
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Assessment Result'),
        content: Text('You scored $correct / ${_questions.length}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PdfPageCOA()),
              );
            },
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: const Text('COA Assessment'),
        backgroundColor: primaryBar,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int qIndex = 0; qIndex < _questions.length; qIndex++)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${qIndex + 1}. ${_questions[qIndex][0]}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    for (int optionIndex = 1; optionIndex < _questions[qIndex].length; optionIndex++)
                      RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(_questions[qIndex][optionIndex]),
                        value: _questions[qIndex][optionIndex],
                        groupValue: _selected[qIndex],
                        onChanged: (value) {
                          setState(() {
                            _selected[qIndex] = value ?? '';
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBar, foregroundColor: Colors.white),
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class AssessmentPage extends StatelessWidget {
  const AssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const COAAssessmentPage();
  }
}
