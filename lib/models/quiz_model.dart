enum QuestionType {
  mcq,
  coding,
  subjective,
}

enum ProgrammingLanguage {
  python,
  java,
  cpp,
  javascript,
  dart,
}

class QuizQuestion {
  final String id;
  final QuestionType type;
  final String question;
  
  // MCQ specific fields
  final List<String>? options;
  final int? correctOptionIndex;
  
  // Coding specific fields
  final ProgrammingLanguage? language;
  final List<TestCase>? testCases;
  final String? expectedOutput;
  final String? solutionCode;

  // Subjective specific fields
  final String? expectedAnswer;
  
  QuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    // MCQ fields
    this.options,
    this.correctOptionIndex,
    // Coding fields
    this.language,
    this.testCases,
    this.expectedOutput,
    this.solutionCode,
    // Subjective fields
    this.expectedAnswer,
  });

  // Factory constructor for MCQ questions
  factory QuizQuestion.mcq({
    required String id,
    required String question,
    required List<String> options,
    required int correctOptionIndex,
  }) {
    return QuizQuestion(
      id: id,
      type: QuestionType.mcq,
      question: question,
      options: options,
      correctOptionIndex: correctOptionIndex,
    );
  }

  // Factory constructor for Coding questions
  factory QuizQuestion.coding({
    required String id,
    required String question,
    required ProgrammingLanguage language,
    List<TestCase>? testCases,
    String? expectedOutput,
    String? solutionCode,
  }) {
    return QuizQuestion(
      id: id,
      type: QuestionType.coding,
      question: question,
      language: language,
      testCases: testCases,
      expectedOutput: expectedOutput,
      solutionCode: solutionCode,
    );
  }

  factory QuizQuestion.subjective({
    required String id,
    required String question,
    String? expectedAnswer,
  }) {
    return QuizQuestion(
      id: id,
      type: QuestionType.subjective,
      question: question,
      expectedAnswer: expectedAnswer,
    );
  }

  // Convert to Map for Firebase storage
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'type': type.name,
      'question': question,
    };

    if (type == QuestionType.mcq) {
      map['options'] = options;
      map['correct'] = correctOptionIndex;
    } else if (type == QuestionType.coding) {
      map['language'] = language?.name;
      map['testCases'] = testCases?.map((tc) => tc.toMap()).toList();
      map['expectedOutput'] = expectedOutput;
      map['solutionCode'] = solutionCode;
    } else if (type == QuestionType.subjective) {
      if (expectedAnswer != null && expectedAnswer!.trim().isNotEmpty) {
        map['expectedAnswer'] = expectedAnswer;
      }
    }

    return map;
  }

  // Create from Map (Firebase data)
  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    final typeStr = map['type'] as String?;
    final type = switch (typeStr) {
      'coding' => QuestionType.coding,
      'subjective' => QuestionType.subjective,
      _ => QuestionType.mcq,
    };

    if (type == QuestionType.mcq) {
      return QuizQuestion.mcq(
        id: map['id'] ?? '',
        question: map['question'] ?? '',
        options: List<String>.from(map['options'] ?? []),
        correctOptionIndex: map['correct'] ?? 0,
      );
    } else if (type == QuestionType.subjective) {
      return QuizQuestion.subjective(
        id: map['id'] ?? '',
        question: map['question'] ?? '',
        expectedAnswer: map['expectedAnswer']?.toString(),
      );
    } else {
      final langStr = map['language'] as String?;
      ProgrammingLanguage lang = ProgrammingLanguage.python;
      if (langStr != null) {
        try {
          lang = ProgrammingLanguage.values.firstWhere(
            (e) => e.name == langStr,
            orElse: () => ProgrammingLanguage.python,
          );
        } catch (e) {
          lang = ProgrammingLanguage.python;
        }
      }

      return QuizQuestion.coding(
        id: map['id'] ?? '',
        question: map['question'] ?? '',
        language: lang,
        testCases: (map['testCases'] as List<dynamic>?)
            ?.map((tc) => TestCase.fromMap(tc as Map<String, dynamic>))
            .toList(),
        expectedOutput: map['expectedOutput'],
        solutionCode: map['solutionCode'],
      );
    }
  }
}

class TestCase {
  final String input;
  final String expectedOutput;
  final bool isHidden; // Hidden test cases not shown to students
  final String? description;

  TestCase({
    required this.input,
    required this.expectedOutput,
    this.isHidden = false,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'input': input,
      'expectedOutput': expectedOutput,
      'isHidden': isHidden,
      'description': description,
    };
  }

  factory TestCase.fromMap(Map<String, dynamic> map) {
    return TestCase(
      input: map['input'] ?? '',
      expectedOutput: map['expectedOutput'] ?? '',
      isHidden: map['isHidden'] ?? false,
      description: map['description'],
    );
  }
}

// Helper function to get language display name
String getLanguageDisplayName(ProgrammingLanguage lang) {
  switch (lang) {
    case ProgrammingLanguage.python:
      return 'Python';
    case ProgrammingLanguage.java:
      return 'Java';
    case ProgrammingLanguage.cpp:
      return 'C++';
    case ProgrammingLanguage.javascript:
      return 'JavaScript';
    case ProgrammingLanguage.dart:
      return 'Dart';
  }
}

// Helper function to get file extension for language
String getLanguageExtension(ProgrammingLanguage lang) {
  switch (lang) {
    case ProgrammingLanguage.python:
      return '.py';
    case ProgrammingLanguage.java:
      return '.java';
    case ProgrammingLanguage.cpp:
      return '.cpp';
    case ProgrammingLanguage.javascript:
      return '.js';
    case ProgrammingLanguage.dart:
      return '.dart';
  }
}
