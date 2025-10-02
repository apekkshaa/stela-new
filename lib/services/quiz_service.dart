import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;
  QuizService._internal();

  static bool _initialized = false;
  late DatabaseReference _quizzesRef;

  Future<void> initialize() async {
    if (!_initialized) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      _quizzesRef = FirebaseDatabase.instance.ref().child('quizzes');
      _initialized = true;
    }
  }

  /// Get all quizzes for a specific subject
  Future<List<Map<String, dynamic>>> getQuizzesForSubject(String subjectId) async {
    await initialize();
    
    // Map student subject IDs to faculty subject labels
    final String subjectKey = _mapSubjectIdToFacultyKey(subjectId);
    print('QuizService: Mapping subject ID "$subjectId" to Firebase key "$subjectKey"');
    
    try {
      final snapshot = await _quizzesRef.child(subjectKey).get();
      List<Map<String, dynamic>> quizzes = [];
      
      print('QuizService: Firebase snapshot exists: ${snapshot.exists}');
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        print('QuizService: Firebase data keys: ${data.keys.toList()}');
        
        data.forEach((unitKey, unitValue) {
          print('QuizService: Processing unit "$unitKey"');
          if (unitValue is Map) {
            // Check if this is a unit containing quizzes
            unitValue.forEach((quizKey, quizValue) {
              if (quizValue is Map && quizValue.containsKey('title')) {
                print('QuizService: Found quiz "${quizValue['title']}" in unit "$unitKey"');
                quizzes.add({
                  'id': quizKey,
                  'title': quizValue['title']?.toString() ?? '',
                  'date': quizValue['date']?.toString() ?? '',
                  'unit': quizValue['unit']?.toString() ?? unitKey.toString().replaceAll('_', ' '),
                  'questions': _parseQuestions(quizValue['facultyQuestions'] ?? quizValue['questions']),
                  'duration': quizValue['duration']?.toString() ?? _calculateDuration(quizValue['questions']),
                  'totalMarks': quizValue['totalMarks']?.toString() ?? '0',
                  'pin': quizValue['pin']?.toString() ?? '',
                  'isFromFaculty': true,
                });
              }
            });
            
            // Also handle backward compatibility for direct quizzes (not in units)
            if (unitValue.containsKey('title') && unitValue.containsKey('questions')) {
              // This is a direct quiz, not a unit (old format)
              print('QuizService: Found direct quiz "${unitValue['title']}"');
              quizzes.add({
                'id': unitKey,
                'title': unitValue['title']?.toString() ?? '',
                'date': unitValue['date']?.toString() ?? '',
                'unit': unitValue['unit']?.toString() ?? 'Unit 1',
                'questions': _parseQuestions(unitValue['facultyQuestions'] ?? unitValue['questions']),
                'duration': unitValue['duration']?.toString() ?? _calculateDuration(unitValue['questions']),
                'totalMarks': unitValue['totalMarks']?.toString() ?? '0',
                'pin': unitValue['pin']?.toString() ?? '',
                'isFromFaculty': true,
              });
            }
          }
        });
      } else {
        print('QuizService: No data found in Firebase for key "$subjectKey"');
      }
      
      print('QuizService: Returning ${quizzes.length} quizzes');
      return quizzes;
    } catch (e) {
      print('Error fetching quizzes for subject $subjectId: $e');
      return [];
    }
  }

  /// Get all quizzes for all subjects
  Future<Map<String, List<Map<String, dynamic>>>> getAllQuizzes() async {
    await initialize();
    
    Map<String, List<Map<String, dynamic>>> allQuizzes = {};
    
    // Define subject mappings using the actual subject IDs from the student portal
    final Map<String, String> subjectMappings = {
      'artificial_intelligence_programming_tools': 'Artificial_Intelligence_-_Programming_Tools',
      'cloud_computing': 'Cloud_Computing',
      'compiler_design': 'Compiler_Design',
      'computer_networks': 'Computer_Networks',
      'computer_organization_and_architecture': 'Computer_Organization_and_Architecture',
      'machine_learning': 'Machine_Learning',
      'wireless_networks': 'Wireless_Networks',
      'internet_of_things': 'Internet_of_Things',
      'c_programming': 'C_Programming',
    };
    
    for (String subjectId in subjectMappings.keys) {
      allQuizzes[subjectId] = await getQuizzesForSubject(subjectId);
    }
    
    return allQuizzes;
  }

  /// Map student subject ID to faculty subject key
  String _mapSubjectIdToFacultyKey(String subjectId) {
    final Map<String, String> mappings = {
      'aipt': 'Artificial_Intelligence_-_Programming_Tools',
      'artificial_intelligence_programming_tools': 'Artificial_Intelligence_-_Programming_Tools',
      'cloud': 'Cloud_Computing',
      'cloud_computing': 'Cloud_Computing',
      'compiler': 'Compiler_Design',
      'compiler_design': 'Compiler_Design',
      'networks': 'Computer_Networks',
      'computer_networks': 'Computer_Networks',
      'coa': 'Computer_Organization_and_Architecture',
      'computer_organization_and_architecture': 'Computer_Organization_and_Architecture',
      'ml': 'Machine_Learning',
      'machine_learning': 'Machine_Learning',
      'wireless': 'Wireless_Networks',
      'wireless_networks': 'Wireless_Networks',
      'iot': 'Internet_of_Things',
      'internet_of_things': 'Internet_of_Things',
      'c_programming': 'C_Programming',
    };
    
    return mappings[subjectId] ?? subjectId.replaceAll('_', '_');
  }

  /// Parse questions from Firebase data
  List<Map<String, dynamic>> _parseQuestions(dynamic questionsData) {
    List<Map<String, dynamic>> questions = [];
    
    if (questionsData is List) {
      for (var question in questionsData) {
        if (question is Map) {
          questions.add({
            'question': question['question']?.toString() ?? '',
            'options': question['options'] is List 
                ? List<String>.from(question['options']) 
                : [],
            'correct': question['correct'] ?? 0,
          });
        }
      }
    }
    
    return questions;
  }

  /// Calculate estimated duration based on number of questions
  String _calculateDuration(dynamic questionsData) {
    int questionCount = 0;
    
    if (questionsData is List) {
      questionCount = questionsData.length;
    }
    
    // Estimate 1.5 minutes per question
    int estimatedMinutes = (questionCount * 1.5).ceil();
    return '${estimatedMinutes} min';
  }

  /// Get quizzes for a specific unit within a subject
  Future<List<Map<String, dynamic>>> getQuizzesForUnit(String subjectId, String unitName) async {
    await initialize();
    
    // Map student subject IDs to faculty subject labels
    final String subjectKey = _mapSubjectIdToFacultyKey(subjectId);
    final String unitKey = unitName.replaceAll(' ', '_');
    
    try {
      final snapshot = await _quizzesRef.child(subjectKey).child(unitKey).get();
      List<Map<String, dynamic>> quizzes = [];
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((quizKey, quizValue) {
          if (quizValue is Map && quizValue.containsKey('title')) {
            quizzes.add({
              'id': quizKey,
              'title': quizValue['title']?.toString() ?? '',
              'date': quizValue['date']?.toString() ?? '',
              'unit': quizValue['unit']?.toString() ?? unitName,
              'questions': _parseQuestions(quizValue['facultyQuestions'] ?? quizValue['questions']),
              'duration': quizValue['duration']?.toString() ?? _calculateDuration(quizValue['questions']),
              'totalMarks': quizValue['totalMarks']?.toString() ?? '0',
              'isFromFaculty': true,
            });
          }
        });
      }
      
      return quizzes;
    } catch (e) {
      print('Error fetching quizzes for unit $unitName in subject $subjectId: $e');
      return [];
    }
  }

  /// Listen to real-time updates for a subject's quizzes
  Stream<List<Map<String, dynamic>>> getQuizzesStream(String subjectId) {
    final String subjectKey = _mapSubjectIdToFacultyKey(subjectId);
    
    return _quizzesRef.child(subjectKey).onValue.map((event) {
      List<Map<String, dynamic>> quizzes = [];
      
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value is Map) {
            quizzes.add({
              'id': key,
              'title': value['title']?.toString() ?? '',
              'date': value['date']?.toString() ?? '',
              'questions': _parseQuestions(value['questions']),
              'duration': _calculateDuration(value['questions']),
            });
          }
        });
      }
      
      return quizzes;
    });
  }
}
