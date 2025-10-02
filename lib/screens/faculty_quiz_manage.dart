import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as xl;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  Future<void> _deleteQuiz(String key, String? unitName) async {
    if (unitName != null) {
      // Delete from specific unit
      final unitRef = _quizRef.child(unitName.replaceAll(' ', '_'));
      await unitRef.child(key).remove();
    } else {
      // Fallback: try to find and delete from any unit
      final snapshot = await _quizRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        for (var unitKey in data.keys) {
          if (data[unitKey] is Map) {
            final unitData = data[unitKey] as Map<dynamic, dynamic>;
            if (unitData.containsKey(key)) {
              await _quizRef.child(unitKey).child(key).remove();
              break;
            }
          }
        }
      }
    }
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
      
      // Handle both old structure (direct quizzes) and new structure (unit-based)
      data.forEach((key, value) {
        if (value is Map) {
          // Check if this is a unit (contains nested quizzes) or a direct quiz
          bool isUnit = false;
          value.forEach((subKey, subValue) {
            if (subValue is Map && subValue.containsKey('title') && subValue.containsKey('questions')) {
              isUnit = true;
              loaded.add({
                'key': subKey,
                'title': subValue['title']?.toString() ?? '',
                'date': subValue['date']?.toString() ?? '',
                'unit': subValue['unit']?.toString() ?? key.toString().replaceAll('_', ' '),
                'originalUnit': key.toString().replaceAll('_', ' '), // Track original unit for editing
                'questions': subValue['questions'] ?? [],
                'duration': subValue['duration']?.toString() ?? '30 min',
                'pin': subValue['pin']?.toString() ?? '',
              });
            }
          });
          
          // If not a unit, treat as direct quiz (backward compatibility)
          if (!isUnit && value.containsKey('title')) {
            loaded.add({
              'key': key,
              'title': value['title']?.toString() ?? '',
              'date': value['date']?.toString() ?? '',
              'unit': value['unit']?.toString() ?? 'Unit 1',
              'questions': value['questions'] ?? [],
              'duration': value['duration']?.toString() ?? '30 min',
              'pin': value['pin']?.toString() ?? '',
            });
          }
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
    final unitName = quizData is Map && quizData['unit'] != null ? quizData['unit'] : 'Unit 1';
    final duration = quizData is Map && quizData['duration'] != null ? '${quizData['duration']} min' : '30 min';
    final pin = quizData is Map && quizData['pin'] != null ? quizData['pin'] : '';
    final newQuiz = {
      'title': quizData is String ? quizData : quizData['title'],
      'date': date,
      'unit': unitName,
      'questions': quizData is Map && quizData['questions'] != null ? quizData['questions'] : [],
      'facultyQuestions': quizData is Map && quizData['questions'] != null ? quizData['questions'] : [],
      'duration': duration,
      'pin': pin,
      'totalMarks': quizData is Map && quizData['questions'] != null ? (quizData['questions'] as List).length * 1 : 0,
    };
    
    // Store quiz under the specific unit
    final unitRef = _quizRef.child(unitName.replaceAll(' ', '_'));
    final newRef = unitRef.push();
    await newRef.set(newQuiz);
    setState(() {
      previousQuizzes.add({'key': newRef.key, 'title': newQuiz['title'], 'date': date, 'unit': unitName, 'questions': newQuiz['questions'], 'pin': pin});
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quiz added to $unitName!')));
  }

  Future<void> _editQuiz(String key, String originalUnit, dynamic quizData) async {
    final newUnitName = quizData['unit'] ?? 'Unit 1';
    final originalUnitName = originalUnit;
    final duration = quizData['duration'] != null ? '${quizData['duration']} min' : '30 min';
    final pin = quizData['pin'] ?? '';
    
    final updatedQuiz = {
      'title': quizData['title'],
      'date': quizData['date'] ?? DateTime.now().toString().substring(0, 10),
      'unit': newUnitName,
      'questions': quizData['questions'] ?? [],
      'facultyQuestions': quizData['questions'] ?? [],
      'duration': duration,
      'pin': pin,
      'totalMarks': quizData['questions'] != null ? (quizData['questions'] as List).length * 1 : 0,
    };
    
    // If unit has changed, we need to move the quiz
    if (originalUnitName != newUnitName) {
      // Delete from original unit
      final originalUnitRef = _quizRef.child(originalUnitName.replaceAll(' ', '_'));
      await originalUnitRef.child(key).remove();
      
      // Add to new unit with new key
      final newUnitRef = _quizRef.child(newUnitName.replaceAll(' ', '_'));
      final newRef = newUnitRef.push();
      await newRef.set(updatedQuiz);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz moved from $originalUnitName to $newUnitName!'))
      );
    } else {
      // Update in the same unit
      final unitRef = _quizRef.child(newUnitName.replaceAll(' ', '_'));
      await unitRef.child(key).set(updatedQuiz);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz updated in $newUnitName!'))
      );
    }
    
    await _loadQuizzes();
  }

  Future<void> _processExcelFile(FilePickerResult result) async {
    try {
      print('Starting Excel file processing...');
      
      // Step 1: Read file bytes
      Uint8List bytes;
      if (kIsWeb) {
        // On web, use the bytes directly from file picker
        bytes = result.files.single.bytes!;
        print('Web: File read successfully, bytes: ${bytes.length}');
      } else {
        // On mobile/desktop, read from file path
        final file = File(result.files.single.path!);
        bytes = await file.readAsBytes();
        print('Mobile: File read successfully, bytes: ${bytes.length}');
      }
      
      // Step 2: Parse Excel - try the original approach for all platforms
      List<Map<String, dynamic>> questions = [];
      try {
        print('Attempting to decode Excel file...');
        final excel = xl.Excel.decodeBytes(bytes);
        print('Excel decoded successfully, tables: ${excel.tables.keys.length}');
        
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table]!;
          bool isHeaderRow = true;
          print('Processing sheet: $table with ${sheet.rows.length} rows');
          
          for (var row in sheet.rows) {
            if (isHeaderRow) {
              isHeaderRow = false;
              continue;
            }
            
            if (row.length >= 6 && row[0]?.value != null) {
              String question = row[0]?.value?.toString() ?? '';
              List<String> options = [
                row[1]?.value?.toString() ?? '',
                row[2]?.value?.toString() ?? '',
                row[3]?.value?.toString() ?? '',
                row[4]?.value?.toString() ?? '',
              ];
              
              // Handle both letter (A, B, C, D) and number (1, 2, 3, 4) formats
              String answerValue = row[5]?.value?.toString().trim().toUpperCase() ?? '';
              int correct = 0; // Default to first option
              
              if (answerValue == 'A' || answerValue == '1') {
                correct = 0;
              } else if (answerValue == 'B' || answerValue == '2') {
                correct = 1;
              } else if (answerValue == 'C' || answerValue == '3') {
                correct = 2;
              } else if (answerValue == 'D' || answerValue == '4') {
                correct = 3;
              } else {
                // Try to parse as number and convert to 0-based index
                int? numAnswer = int.tryParse(answerValue);
                if (numAnswer != null && numAnswer >= 1 && numAnswer <= 4) {
                  correct = numAnswer - 1;
                }
              }
              
              print('Question: $question');
              print('Options: $options');
              print('Answer value: "$answerValue" -> Index: $correct');
              
              if (question.isNotEmpty && options.any((opt) => opt.isNotEmpty)) {
                questions.add({
                  'question': question,
                  'options': options,
                  'correct': correct,
                });
              }
            }
          }
        }
      } catch (e) {
        print('Excel parsing error: $e');
        print('Error type: ${e.runtimeType}');
        
        // If it's the namespace error, provide a more specific message
        if (e.toString().contains('_Namespace') || e.toString().contains('Unsupported operation')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Excel processing failed on web. Please try using the mobile app or create quiz manually.'),
                duration: Duration(seconds: 5),
              ),
            );
          }
          return;
        } else {
          throw Exception('Failed to parse Excel file: $e');
        }
      }
      
      print('Parsed ${questions.length} questions from Excel');
      
      // Step 3: Process results
      if (questions.isNotEmpty) {
        // Use file name (without extension) as quiz title
        String quizTitle = result.files.single.name;
        if (quizTitle.contains('.')) {
          quizTitle = quizTitle.substring(0, quizTitle.lastIndexOf('.'));
        }
        
        print('Attempting to add quiz: $quizTitle');
        
        // Step 4: Save to Firebase
        try {
          await _addQuiz({'title': quizTitle, 'questions': questions});
          print('Quiz added successfully to Firebase');
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Quiz uploaded successfully with ${questions.length} questions!')),
            );
          }
        } catch (e) {
          print('Firebase save error: $e');
          throw Exception('Failed to save quiz to database: $e');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No valid questions found in the uploaded file.')),
          );
        }
      }
    } catch (e) {
      print('Overall processing error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing file: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes - ${subject['label']}"),
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
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['xlsx', 'xls'],
                            );

                            if (result != null) {
                              await _processExcelFile(result);
                            }
                          } catch (e) {
                            print('File picker error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error selecting file: ${e.toString()}')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Previous Quizzes:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: previousQuizzes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.quiz, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text("No quizzes created yet", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: previousQuizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = previousQuizzes[index];
                              return Card(
                                child: ListTile(
                                  leading: Icon(Icons.quiz, color: subject['color']),
                                  title: Text(quiz['title'] ?? ''),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Unit: ${quiz['unit'] ?? 'Unit 1'}"),
                                      Text("Date: ${quiz['date']}"),
                                      Text("Duration: ${quiz['duration'] ?? '30 min'}", style: TextStyle(color: subject['color'], fontWeight: FontWeight.w500)),
                                    ],
                                  ),
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
                                              questionsList = [Map<String, dynamic>.from(quiz['questions'] as Map)];
                                            }
                                          }

                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => QuizCreationForm(
                                                subject: subject,
                                                initialTitle: quiz['title'],
                                                initialQuestions: questionsList,
                                                initialDuration: quiz['duration'] is int ? quiz['duration'] : (quiz['duration'] is String ? int.tryParse(quiz['duration']) : null),
                                                initialPin: quiz['pin']?.toString() ?? '',
                                              ),
                                            ),
                                          );
                                          if (result != null) {
                                            await _editQuiz(quiz['key'], quiz['originalUnit'] ?? quiz['unit'], result);
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
                                              content: Text('Are you sure you want to delete "${quiz['title']}"?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await _deleteQuiz(quiz['key'], quiz['unit']);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
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
  final int? initialDuration;
  final String? initialPin;
  const QuizCreationForm({required this.subject, this.initialTitle, this.initialQuestions, this.initialDuration, this.initialPin});

  @override
  _QuizCreationFormState createState() => _QuizCreationFormState();
}

class _QuizCreationFormState extends State<QuizCreationForm> {
  final _formKey = GlobalKey<FormState>();
  String quizTitle = "";
  String? selectedUnit;
  int duration = 30; // Default 30 minutes
  String pin = ""; // 6-digit PIN
  List<String> availableUnits = [];
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    quizTitle = widget.initialTitle ?? "";
    duration = widget.initialDuration ?? 30;
    pin = widget.initialPin ?? "";
    
    // Initialize available units from subject data
    if (widget.subject['units'] != null) {
      availableUnits = (widget.subject['units'] as List<dynamic>)
          .map((unit) => unit['name'] as String)
          .toList();
    } else {
      // Default units if no units are defined
      availableUnits = ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4'];
    }
    
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

  String _generateRandomPin() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return (random % 900000 + 100000).toString(); // Ensures 6 digits
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
        title: Text("Create Quiz - ${subject['label']}"),
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
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Unit",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  value: selectedUnit,
                  items: availableUnits.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUnit = newValue;
                    });
                  },
                  validator: (value) => value == null ? "Please select a unit" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Quiz Duration (minutes)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                    suffixText: "min",
                  ),
                  initialValue: duration.toString(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter quiz duration";
                    }
                    final minutes = int.tryParse(value);
                    if (minutes == null || minutes <= 0) {
                      return "Enter a valid duration in minutes";
                    }
                    if (minutes > 300) {
                      return "Duration cannot exceed 300 minutes";
                    }
                    return null;
                  },
                  onSaved: (value) => duration = int.tryParse(value ?? "30") ?? 30,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed > 0) {
                      duration = parsed;
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Quiz Access PIN (6 digits, optional)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.refresh),
                      tooltip: "Generate Random PIN",
                      onPressed: () {
                        setState(() {
                          pin = _generateRandomPin();
                        });
                      },
                    ),
                    helperText: "Optional: Students need this PIN to start the quiz (leave empty for no PIN)",
                  ),
                  initialValue: pin,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length != 6) {
                        return "PIN must be exactly 6 digits";
                      }
                      if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                        return "PIN must contain only numbers";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => pin = value ?? "",
                  onChanged: (value) => pin = value,
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
                              labelText: "Question ${qIndex + 1}",
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
                                          labelText: "Option ${optIdx + 1}",
                                          border: OutlineInputBorder(),
                                        ),
                                        initialValue: q['options'][optIdx],
                                        validator: (value) => value == null || value.isEmpty ? "Enter option" : null,
                                        onChanged: (value) => questions[qIndex]['options'][optIdx] = value,
                                      ),
                                    ),
                                    if (q['correct'] == optIdx)
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text("Correct", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                  ],
                                ),
                              )),
                          if (q['correct'] == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Please select the correct answer",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    questions.removeAt(qIndex);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
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
                      if (selectedUnit == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a unit for this quiz.')),
                        );
                        return;
                      }
                      // Return a map with title, questions, unit, duration, and pin
                      Navigator.pop(context, {
                        'title': quizTitle,
                        'questions': questions,
                        'unit': selectedUnit,
                        'duration': duration,
                        'pin': pin,
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