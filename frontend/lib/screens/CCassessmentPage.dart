import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/ReportGenerationCC.dart';

class CCAssessmentPage extends StatefulWidget {
  const CCAssessmentPage({super.key});

  @override
  State<CCAssessmentPage> createState() => _CCAssessmentPageState();
}

class _CCAssessmentPageState extends State<CCAssessmentPage> {
  final List<List<String>> _questions = [
    [
      'Which cloud service model is most restrictive?',
      'SaaS',
      'IaaS',
      'Both IaaS and SaaS',
      'PaaS',
    ],
    [
      'Which one is NOT a feature of cloud computing?',
      'Scalability',
      'Reliability',
      'Agility',
      'Decentralization',
    ],
    [
      'Which service is provided by Google for online storage?',
      'Drive',
      'SkyDrive',
      'Dropbox',
      'None of these',
    ],
    [
      'AWS best maps to which model?',
      'SaaS',
      'PaaS',
      'IaaS',
      'All of these',
    ],
  ];

  final List<String> _correct = [
    'PaaS',
    'Decentralization',
    'Drive',
    'IaaS',
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
                MaterialPageRoute(builder: (_) => PdfPageCC()),
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
        title: const Text('CC Assessment'),
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
