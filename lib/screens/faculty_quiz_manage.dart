import 'package:flutter/material.dart';

class FacultyQuizManage extends StatelessWidget {
  final Map<String, dynamic> subject;
  const FacultyQuizManage({required this.subject});

  @override
  Widget build(BuildContext context) {
    // Dummy previous quizzes list
    final List<Map<String, String>> previousQuizzes = [
      {"title": "Quiz 1: Basics", "date": "2024-07-01"},
      {"title": "Quiz 2: Advanced", "date": "2024-07-10"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes - ${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Create New Quiz"),
              style: ElevatedButton.styleFrom(
                backgroundColor: subject['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizCreationForm(subject: subject),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            Text(
              "Previous Quizzes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            Expanded(
              child: previousQuizzes.isEmpty
                  ? Text("No quizzes created yet.")
                  : ListView.builder(
                      itemCount: previousQuizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = previousQuizzes[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.quiz, color: subject['color']),
                            title: Text(quiz['title'] ?? ''),
                            subtitle: Text("Date: ${quiz['date']}"),
                            onTap: () {
                              // Optionally, view quiz details or results
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy quiz creation form
class QuizCreationForm extends StatelessWidget {
  final Map<String, dynamic> subject;
  const QuizCreationForm({required this.subject});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String quizTitle = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Quiz - ${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Quiz Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter quiz title" : null,
                onSaved: (value) => quizTitle = value ?? "",
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text("Save Quiz"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subject['color'],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Save quiz logic here
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}