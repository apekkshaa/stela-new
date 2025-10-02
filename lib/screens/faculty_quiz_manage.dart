import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
// import 'package:pdf_text/pdf_text.dart'; // Removed: not available
// For docx parsing, you may use: import 'package:docx_parse/docx_parse.dart'; (add to pubspec if needed)
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../firebase_options.dart';

class FacultyQuizManage extends StatefulWidget {
  final Map<String, dynamic> subject;
  const FacultyQuizManage({required this.subject});

  @override
  State<FacultyQuizManage> createState() => _FacultyQuizManageState();
}

class _FacultyQuizManageState extends State<FacultyQuizManage> {
  Future<void> _deleteQuiz(String key) async {
    await _quizRef.child(key).remove();
    await _loadQuizzes();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quiz deleted!')));
  }
  List<Map<String, dynamic>> previousQuizzes = [];
  late DatabaseReference _quizRef;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initFirebaseAndLoad();
  }

  Future<void> _initFirebaseAndLoad() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final subjectKey = widget.subject['label'].toString().replaceAll(' ', '_');
    _quizRef = FirebaseDatabase.instance.ref().child('quizzes').child(subjectKey);
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final snapshot = await _quizRef.get();
    List<Map<String, dynamic>> loaded = [];
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        if (value is Map) {
          loaded.add({
            'key': key,
            'title': value['title']?.toString() ?? '',
            'date': value['date']?.toString() ?? '',
            'questions': value['questions'] ?? [],
          });
        }
      });
    }
    setState(() {
      previousQuizzes = loaded;
      _loading = false;
    });
  }

  Future<void> _addQuiz(dynamic quizData) async {
    final date = DateTime.now().toString().substring(0, 10);
    final newQuiz = {
      'title': quizData is String ? quizData : quizData['title'],
      'date': date,
      'questions': quizData is Map && quizData['questions'] != null ? quizData['questions'] : [],
    };
    final newRef = _quizRef.push();
    await newRef.set(newQuiz);
    setState(() {
      previousQuizzes.add({'key': newRef.key, 'title': newQuiz['title'], 'date': date, 'questions': newQuiz['questions']});
    });
  }

  Future<void> _editQuiz(String key, dynamic quizData) async {
    final updatedQuiz = {
      'title': quizData['title'],
      'date': quizData['date'] ?? DateTime.now().toString().substring(0, 10),
      'questions': quizData['questions'] ?? [],
    };
    await _quizRef.child(key).set(updatedQuiz);
    await _loadQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes - \\${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizCreationForm(subject: subject),
                            ),
                          );
                          if (result != null && result is Map && result['title'] != null && result['title'].toString().isNotEmpty) {
                            await _addQuiz(result);
                          }
                        },
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: Icon(Icons.upload_file),
                        label: Text("Upload Quiz Document"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                          );
                          if (result != null) {
                            String ext = result.files.single.extension ?? '';
                            List<Map<String, dynamic>> questions = [];
                            // Use file name (without extension) as quiz title
                            String quizTitle = result.files.single.name;
                            if (quizTitle.contains('.')) {
                              quizTitle = quizTitle.substring(0, quizTitle.lastIndexOf('.'));
                            }
                            if (ext == 'xlsx') {
                              List<int>? bytes;
                              if (result.files.single.bytes != null) {
                                // Web: use bytes directly
                                bytes = result.files.single.bytes;
                              } else if (result.files.single.path != null) {
                                // Mobile/Desktop: read from file
                                bytes = File(result.files.single.path!).readAsBytesSync();
                              }
                              if (bytes != null) {
                                final excel = Excel.decodeBytes(bytes);
                                // Assumes first sheet, first row is header: Question, OptionA, OptionB, OptionC, OptionD, Answer
                                final sheet = excel.tables.values.first;
                                if (sheet != null && sheet.maxRows > 1) {
                                  for (int i = 1; i < sheet.maxRows; i++) {
                                    final row = sheet.row(i);
                                    if (row.length >= 6) {
                                      final questionText = row[0]?.value?.toString().trim() ?? '';
                                      final optionA = row[1]?.value?.toString().trim() ?? '';
                                      final optionB = row[2]?.value?.toString().trim() ?? '';
                                      final optionC = row[3]?.value?.toString().trim() ?? '';
                                      final optionD = row[4]?.value?.toString().trim() ?? '';
                                      final answer = row[5]?.value?.toString().trim() ?? '';
                                      if (questionText.isNotEmpty && optionA.isNotEmpty && optionB.isNotEmpty && optionC.isNotEmpty && optionD.isNotEmpty && answer.isNotEmpty) {
                                        // Map answer letter to index
                                        int? correctIdx;
                                        switch (answer.toUpperCase()) {
                                          case 'A':
                                            correctIdx = 0;
                                            break;
                                          case 'B':
                                            correctIdx = 1;
                                            break;
                                          case 'C':
                                            correctIdx = 2;
                                            break;
                                          case 'D':
                                            correctIdx = 3;
                                            break;
                                        }
                                        if (correctIdx != null) {
                                          final q = {
                                            'question': questionText,
                                            'options': [optionA, optionB, optionC, optionD],
                                            'correct': correctIdx,
                                          };
                                          questions.add(q);
                                          print('Parsed question: ' + q.toString());
                                        } else {
                                          print('Skipped row at index $i due to invalid answer value: $answer');
                                        }
                                      } else {
                                        print('Skipped row at index $i due to missing data.');
                                      }
                                    }
                                  }
                                } else {
                                  print('Excel sheet is empty or only header present.');
                                }
                                print('Total questions parsed: ' + questions.length.toString());
                              } else {
                                print('No bytes found for Excel file.');
                              }
                            }
                            // If questions found, add quiz
                            if (questions.isNotEmpty) {
                              print('Adding quiz with ${questions.length} questions.');
                              await _addQuiz({'title': quizTitle, 'questions': questions});
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quiz created from Excel file!')));
                            } else {
                              print('No questions parsed from Excel file.');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not parse any questions from the Excel file.')));
                            }
                          }
                        },
                      ),
                    ],
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
                                  subtitle: Text("Date: \\${quiz['date']}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        tooltip: 'Edit Quiz',
                                        onPressed: () async {
                                          // Convert questions to List<Map<String, dynamic>>
                                          List<Map<String, dynamic>> questionsList = [];
                                          if (quiz['questions'] != null) {
                                            if (quiz['questions'] is List) {
                                              questionsList = (quiz['questions'] as List)
                                                  .map((q) => Map<String, dynamic>.from(q as Map))
                                                  .toList();
                                            } else if (quiz['questions'] is Map) {
                                              // In case questions are stored as a map (shouldn't happen, but for safety)
                                              questionsList = (quiz['questions'] as Map).values
                                                  .map((q) => Map<String, dynamic>.from(q as Map))
                                                  .toList();
                                            }
                                          }
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => QuizCreationForm(
                                                subject: subject,
                                                initialTitle: quiz['title'],
                                                initialQuestions: questionsList,
                                              ),
                                            ),
                                          );
                                          if (result != null && result is Map && result['title'] != null && result['title'].toString().isNotEmpty) {
                                            await _editQuiz(quiz['key'], {
                                              'title': result['title'],
                                              'date': quiz['date'],
                                              'questions': result['questions'],
                                            });
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.redAccent),
                                        tooltip: 'Delete Quiz',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Delete Quiz'),
                                              content: Text('Are you sure you want to delete this quiz?'),
                                              actions: [
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () => Navigator.pop(ctx, false),
                                                ),
                                                ElevatedButton(
                                                  child: Text('Delete'),
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                  onPressed: () => Navigator.pop(ctx, true),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await _deleteQuiz(quiz['key']);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
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

class QuizCreationForm extends StatefulWidget {
  final Map<String, dynamic> subject;
  final String? initialTitle;
  final List<Map<String, dynamic>>? initialQuestions;
  const QuizCreationForm({required this.subject, this.initialTitle, this.initialQuestions});

  @override
  _QuizCreationFormState createState() => _QuizCreationFormState();
}

class _QuizCreationFormState extends State<QuizCreationForm> {
  final _formKey = GlobalKey<FormState>();
  String quizTitle = "";
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    quizTitle = widget.initialTitle ?? "";
    questions = widget.initialQuestions != null
        ? widget.initialQuestions!.map((q) => {
              'question': q['question'] ?? '',
              'options': List<String>.from(q['options'] ?? List<String>.filled(4, '')),
              'correct': q['correct'] is int ? q['correct'] : (q['correct'] is String ? int.tryParse(q['correct']) : null),
            }).toList()
        : [];
  }

  void _addQuestion() {
    setState(() {
      questions.add({
        'question': '',
        'options': List<String>.filled(4, ''),
        'correct': null, // No option pre-selected
      });
    });
  }

  bool _validateCorrectAnswers() {
    for (var q in questions) {
      if (q['correct'] == null) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Quiz - \\${subject['label']}"),
        backgroundColor: subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Quiz Title",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: quizTitle,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter quiz title" : null,
                  onSaved: (value) => quizTitle = value ?? "",
                  onChanged: (value) => quizTitle = value,
                ),
                SizedBox(height: 24),
                Text(
                  "Questions:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ...questions.asMap().entries.map((entry) {
                  int qIndex = entry.key;
                  Map<String, dynamic> q = entry.value;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Question \\${qIndex + 1}",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: q['question'],
                            validator: (value) => value == null || value.isEmpty ? "Enter question" : null,
                            onChanged: (value) => questions[qIndex]['question'] = value,
                          ),
                          SizedBox(height: 12),
                          ...List.generate(4, (optIdx) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                      value: optIdx,
                                      groupValue: q['correct'],
                                      onChanged: (val) {
                                        setState(() {
                                          questions[qIndex]['correct'] = val;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "Option \\${optIdx + 1}",
                                          border: OutlineInputBorder(),
                                        ),
                                        initialValue: q['options'][optIdx],
                                        validator: (value) => value == null || value.isEmpty ? "Enter option" : null,
                                        onChanged: (value) => questions[qIndex]['options'][optIdx] = value,
                                      ),
                                    ),
                                    if ((q['correct'] ?? -1) == optIdx)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("Correct", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                      ),
                                  ],
                                ),
                              )),
                          if (q['correct'] == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Select the correct answer.",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text("Add Question"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subject['color'],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _addQuestion,
                    ),
                  ],
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
                      if (questions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Add at least one question.')),
                        );
                        return;
                      }
                      if (!_validateCorrectAnswers()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Select the correct answer for every question.')),
                        );
                        return;
                      }
                      // Return a map with title and questions
                      Navigator.pop(context, {
                        'title': quizTitle,
                        'questions': questions,
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}