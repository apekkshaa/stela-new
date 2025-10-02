import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/subject_detail.dart';
import 'package:stela_app/services/quiz_service.dart';

/// Clean, single-file quizzes implementation.
/// Exposes `QuizzesScreen` as the main entry point for the Quizzes route.
class QuizzesScreen extends StatefulWidget {
  static const String routeName = '/quizzes';

  @override
  _QuizzesScreenState createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = 'All';
  final QuizService _quizService = QuizService();
  Map<String, List<Map<String, dynamic>>> _facultyQuizzes = {};
  bool _loadingFacultyQuizzes = true;

  final List<Map<String, dynamic>> subjects = const [
    {
      'id': 'artificial_intelligence_programming_tools', 
      'title': 'Artificial Intelligence - Programming Tools', 
      'icon': Icons.psychology, 
      'color': Colors.orange, 
      'category': 'AI & Data',
      'description': 'Learn AI programming tools and techniques'
    },
    {
      'id': 'cloud_computing', 
      'title': 'Cloud Computing', 
      'icon': Icons.cloud, 
      'color': Colors.blue, 
      'category': 'Engineering',
      'description': 'Explore cloud computing concepts and practices'
    },
    {
      'id': 'compiler_design', 
      'title': 'Compiler Design', 
      'icon': Icons.build, 
      'color': Colors.redAccent, 
      'category': 'Core Systems',
      'description': 'Learn about compiler construction and design'
    },
    {
      'id': 'computer_networks', 
      'title': 'Computer Networks', 
      'icon': Icons.network_check, 
      'color': Colors.lightBlue, 
      'category': 'Networking',
      'description': 'Study computer networking concepts and protocols'
    },
    {
      'id': 'computer_organization_and_architecture', 
      'title': 'Computer Organization and Architecture', 
      'icon': Icons.computer, 
      'color': Colors.green, 
      'category': 'Core Systems',
      'description': 'Understand computer architecture and organization'
    },
    {
      'id': 'machine_learning', 
      'title': 'Machine Learning', 
      'icon': Icons.memory, 
      'color': Colors.deepPurple, 
      'category': 'AI & Data',
      'description': 'Introduction to machine learning concepts and algorithms'
    },
    {
      'id': 'wireless_networks', 
      'title': 'Wireless Networks', 
      'icon': Icons.wifi, 
      'color': Colors.cyan, 
      'category': 'Networking',
      'description': 'Study wireless communication and networking'
    },
    {
      'id': 'internet_of_things', 
      'title': 'Internet of Things', 
      'icon': Icons.sensors, 
      'color': Colors.deepOrange, 
      'category': 'Engineering',
      'description': 'Learn about connected devices, sensor networks, and IoT applications'
    },
    {
      'id': 'c_programming', 
      'title': 'C Programming', 
      'icon': Icons.code, 
      'color': Colors.blueGrey, 
      'category': 'Programming',
      'description': 'Master the fundamentals of C programming language'
    },
  ];
            {'name': 'Quiz 5', 'title': 'Unit 2 Comprehensive Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Neural Networks', 'Deep Learning', 'TensorFlow'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Neural Network Basics', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Deep Learning Concepts', 'questions': 15, 'duration': '20 min'},
            {'name': 'Quiz 3', 'title': 'TensorFlow Framework', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Neural Networks', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Final Exam', 'questions': 30, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Natural Language Processing', 'Computer Vision', 'AI Applications'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'NLP Fundamentals', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Computer Vision Basics', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 3', 'title': 'AI Applications', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Advanced AI Topics', 'questions': 20, 'duration': '28 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Capstone Assessment', 'questions': 35, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'cloud', 
      'title': 'Cloud Computing', 
      'icon': Icons.cloud, 
      'color': Colors.blue, 
      'category': 'Technology',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['Cloud Fundamentals', 'Service Models', 'Deployment Models'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Cloud Basics', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Service Models Quiz', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Deployment Strategies', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Cloud Architecture', 'questions': 15, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['AWS Services', 'EC2', 'S3 Storage'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'AWS Fundamentals', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'EC2 Instances', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'S3 Storage Management', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'AWS Security', 'questions': 16, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Final Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Azure Platform', 'Google Cloud', 'Multi-cloud Strategy'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Azure Basics', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Google Cloud Platform', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Multi-cloud Concepts', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Cloud Migration', 'questions': 17, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Comprehensive', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Security', 'Monitoring', 'Cost Optimization'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Cloud Security', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 2', 'title': 'Monitoring Tools', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Cost Management', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Performance Optimization', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Final Exam', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'compiler', 
      'title': 'Compiler Design', 
      'icon': Icons.build, 
      'color': Colors.red, 
      'category': 'Programming',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['Lexical Analysis', 'Tokens', 'Regular Expressions'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Lexical Analysis Basics', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Token Recognition', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Regular Expressions', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Finite Automata', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Final Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['Syntax Analysis', 'Parsing', 'Grammar'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Syntax Analysis Concepts', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Parsing Techniques', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Grammar Rules', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Parse Trees', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Comprehensive Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Semantic Analysis', 'Symbol Tables', 'Type Checking'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Semantic Analysis', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Symbol Table Management', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Type Checking Systems', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Error Detection', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Final Exam', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Code Generation', 'Optimization', 'Runtime Environment'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Code Generation Basics', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'Optimization Techniques', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Runtime Environment', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Compilation', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Capstone Test', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'networks', 
      'title': 'Computer Networks', 
      'icon': Icons.network_check, 
      'color': Colors.lightBlue, 
      'category': 'Technology',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['Network Basics', 'OSI Model', 'TCP/IP'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Network Fundamentals', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'OSI Model Layers', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'TCP/IP Protocol Suite', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Network Topologies', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['Data Link Layer', 'Ethernet', 'Switching'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Data Link Layer', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Ethernet Technology', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Switching Concepts', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'MAC Addresses', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Final Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Network Layer', 'Routing', 'IP Addressing'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Network Layer Functions', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Routing Protocols', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'IP Addressing Schemes', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Subnetting', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Comprehensive', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Transport Layer', 'Application Layer', 'Network Security'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Transport Layer Protocols', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'Application Layer Services', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Network Security Basics', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Security', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Final Exam', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'coa', 
      'title': 'Computer Organization and Architecture', 
      'icon': Icons.computer, 
      'color': Colors.green, 
      'category': 'Hardware',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['Basic Computer Organization', 'CPU', 'Memory'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Computer Organization Basics', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'CPU Architecture', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Memory Systems', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'System Components', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Final Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['Instruction Set Architecture', 'RISC vs CISC', 'Assembly Language'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Instruction Set Design', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'RISC vs CISC', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Assembly Programming', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Machine Language', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Comprehensive', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Pipeline Processing', 'Cache Memory', 'Virtual Memory'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Pipeline Concepts', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Cache Design', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Virtual Memory', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Memory Hierarchy', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Final Exam', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['I/O Organization', 'Multiprocessors', 'Performance Evaluation'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'I/O Systems', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'Multiprocessor Systems', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Performance Analysis', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Architecture', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Capstone Test', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'ml', 
      'title': 'Machine Learning', 
      'icon': Icons.memory, 
      'color': Colors.deepPurple, 
      'category': 'AI/ML',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['ML Introduction', 'Types of Learning', 'Data Preprocessing'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'ML Fundamentals', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Learning Types', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Data Preprocessing', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Feature Engineering', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['Supervised Learning', 'Classification', 'Regression'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Supervised Learning Basics', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Classification Algorithms', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Regression Analysis', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Model Selection', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Final Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Unsupervised Learning', 'Clustering', 'Dimensionality Reduction'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Unsupervised Learning', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Clustering Methods', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Dimensionality Reduction', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Clustering', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Comprehensive', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Deep Learning', 'Neural Networks', 'Model Evaluation'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Neural Networks', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'Deep Learning Models', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Model Evaluation', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Advanced ML', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Final Exam', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'wireless', 
      'title': 'Wireless Networks', 
      'icon': Icons.wifi, 
      'color': Colors.cyan, 
      'category': 'Technology',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['Wireless Fundamentals', 'Radio Waves', 'Antennas'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Wireless Basics', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Radio Wave Propagation', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Antenna Design', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Signal Processing', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['WiFi Standards', '802.11', 'Access Points'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'WiFi Standards', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': '802.11 Protocols', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Access Point Configuration', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'WLAN Security', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Final Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Cellular Networks', '4G/5G', 'Mobile Communication'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Cellular Architecture', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': '4G Technology', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': '5G Networks', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Mobile Communication', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Comprehensive', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Bluetooth', 'IoT Protocols', 'Network Security'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Bluetooth Technology', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'IoT Communication', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Wireless Security', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Protocols', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Final Exam', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'iot', 
      'title': 'Internet of Things', 
      'icon': Icons.sensors, 
      'color': Colors.deepOrange, 
      'category': 'Technology',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['IoT Introduction', 'Sensors', 'Actuators'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'IoT Fundamentals', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Sensor Technology', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Actuator Systems', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'IoT Components', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['Communication Protocols', 'MQTT', 'CoAP'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'IoT Protocols', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'MQTT Protocol', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'CoAP Implementation', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Protocol Comparison', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Final Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['IoT Platforms', 'Cloud Integration', 'Data Analytics'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'IoT Platforms', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Cloud Integration', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Data Analytics', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Big Data in IoT', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Comprehensive', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Security', 'Edge Computing', 'IoT Applications'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'IoT Security', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'Edge Computing', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'IoT Applications', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Industry 4.0', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Final Exam', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
    {
      'id': 'c_programming', 
      'title': 'C Programming', 
      'icon': Icons.code, 
      'color': Colors.blueGrey, 
      'category': 'Programming',
      'units': [
        {
          'name': 'Unit 1', 
          'topics': ['C Basics', 'Variables', 'Data Types'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'C Language Basics', 'questions': 8, 'duration': '12 min'},
            {'name': 'Quiz 2', 'title': 'Variables & Constants', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 3', 'title': 'Data Types', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Input/Output', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 5', 'title': 'Unit 1 Assessment', 'questions': 20, 'duration': '30 min'}
          ]
        },
        {
          'name': 'Unit 2', 
          'topics': ['Control Structures', 'Loops', 'Functions'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Control Structures', 'questions': 9, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Loop Constructs', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 3', 'title': 'Function Programming', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 4', 'title': 'Recursion', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 5', 'title': 'Unit 2 Final Test', 'questions': 25, 'duration': '35 min'}
          ]
        },
        {
          'name': 'Unit 3', 
          'topics': ['Arrays', 'Pointers', 'Strings'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Array Fundamentals', 'questions': 10, 'duration': '15 min'},
            {'name': 'Quiz 2', 'title': 'Pointer Concepts', 'questions': 12, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'String Manipulation', 'questions': 14, 'duration': '20 min'},
            {'name': 'Quiz 4', 'title': 'Advanced Pointers', 'questions': 16, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 3 Comprehensive', 'questions': 28, 'duration': '40 min'}
          ]
        },
        {
          'name': 'Unit 4', 
          'topics': ['Structures', 'File Handling', 'Dynamic Memory'],
          'quizzes': [
            {'name': 'Quiz 1', 'title': 'Structures & Unions', 'questions': 11, 'duration': '16 min'},
            {'name': 'Quiz 2', 'title': 'File Operations', 'questions': 13, 'duration': '18 min'},
            {'name': 'Quiz 3', 'title': 'Dynamic Memory', 'questions': 15, 'duration': '22 min'},
            {'name': 'Quiz 4', 'title': 'Advanced C Programming', 'questions': 18, 'duration': '25 min'},
            {'name': 'Quiz 5', 'title': 'Unit 4 Final Exam', 'questions': 30, 'duration': '45 min'}
          ]
        }
      ]
    },
  ];

  final List<String> categories = ['All', 'AI & Data', 'Engineering', 'Core Systems', 'Networking', 'Programming'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadFacultyQuizzes();
  }

  Future<void> _loadFacultyQuizzes() async {
    try {
      final facultyQuizzes = await _quizService.getAllQuizzes();
      setState(() {
        _facultyQuizzes = facultyQuizzes;
        _loadingFacultyQuizzes = false;
      });
    } catch (e) {
      print('Error loading faculty quizzes: $e');
      setState(() {
        _loadingFacultyQuizzes = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredSubjects {
    List<Map<String, dynamic>> updatedSubjects = _mergeWithFacultyQuizzes();
    if (_selectedCategory == 'All') return updatedSubjects;
    return updatedSubjects.where((subject) => subject['category'] == _selectedCategory).toList();
  }

  List<Map<String, dynamic>> _mergeWithFacultyQuizzes() {
    List<Map<String, dynamic>> updatedSubjects = [];
    
    for (var subject in subjects) {
      Map<String, dynamic> updatedSubject = Map<String, dynamic>.from(subject);
      String subjectId = subject['id'];
      
      // Get faculty quizzes for this subject
      List<Map<String, dynamic>> facultyQuizzes = _facultyQuizzes[subjectId] ?? [];
      
      if (facultyQuizzes.isNotEmpty) {
        // Group faculty quizzes by unit
        Map<String, List<Map<String, dynamic>>> quizzesByUnit = {};
        for (var quiz in facultyQuizzes) {
          String unitName = quiz['unit'] ?? 'Unit 1';
          if (!quizzesByUnit.containsKey(unitName)) {
            quizzesByUnit[unitName] = [];
          }
          
          // Convert to expected format
          quizzesByUnit[unitName]!.add({
            'name': quiz['title'],
            'title': quiz['title'],
            'questions': quiz['questions']?.length ?? 0,
            'duration': quiz['duration'] ?? '30 min',
            'id': quiz['id'],
            'isFromFaculty': true,
            'date': quiz['date'],
            'unit': quiz['unit'],
            'facultyQuestions': quiz['questions'], // Store full question data
          });
        }
        
        // Create units based on faculty quizzes only
        List<Map<String, dynamic>> units = [];
        quizzesByUnit.forEach((unitName, quizzes) {
          units.add({
            'name': unitName,
            'topics': ['Faculty Created Content'],
            'quizzes': quizzes,
            'isFacultyUnit': true,
          });
        });
        
        // Sort units by name (Unit 1, Unit 2, etc.)
        units.sort((a, b) {
          String nameA = a['name'];
          String nameB = b['name'];
          
          // Extract unit numbers for proper sorting
          RegExp unitRegex = RegExp(r'Unit (\d+)');
          Match? matchA = unitRegex.firstMatch(nameA);
          Match? matchB = unitRegex.firstMatch(nameB);
          
          if (matchA != null && matchB != null) {
            int unitA = int.parse(matchA.group(1)!);
            int unitB = int.parse(matchB.group(1)!);
            return unitA.compareTo(unitB);
          }
          
          return nameA.compareTo(nameB);
        });
        
        updatedSubject['units'] = units;
        updatedSubjects.add(updatedSubject);
      }
      // Only add subjects that have faculty quizzes
    }
    
    return updatedSubjects;
  }

  bool _hasFacultyQuizzes(Map<String, dynamic> subject) {
    String subjectId = subject['id'];
    return _facultyQuizzes[subjectId]?.isNotEmpty ?? false;
  }

  int _getTotalQuizCount(Map<String, dynamic> subject) {
    if (subject['units'] == null) return 0;
    int total = 0;
    for (var unit in subject['units']) {
      if (unit['quizzes'] != null) {
        total += (unit['quizzes'] as List).length;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > 1200) {
      crossAxisCount = 3;
      childAspectRatio = 2.2;
    } else if (screenWidth > 800) {
      crossAxisCount = 2;
      childAspectRatio = 2.0;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 2.6;
    }

    return Scaffold(
      backgroundColor: primaryWhite,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: primaryBar,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryBar,
                      primaryButton,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quizzes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PTSerif-Bold',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Test your knowledge across various subjects',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontFamily: 'PTSerif',
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.quiz, color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      '${filteredSubjects.length} subjects available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : primaryBar,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: primaryButton,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? primaryButton.withOpacity(0.3)
                                : primaryBar.withOpacity(0.2),
                            width: isSelected ? 1.5 : 1,
                          ),
                          elevation: isSelected ? 6 : 2,
                          shadowColor: isSelected
                              ? primaryButton.withOpacity(0.3)
                              : Colors.black.withOpacity(0.1),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          
          // Subjects Grid with Loading State
          _loadingFacultyQuizzes 
            ? SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryButton),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading faculty quizzes...',
                          style: TextStyle(
                            color: primaryBar.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : filteredSubjects.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.quiz_outlined,
                            size: 64,
                            color: primaryBar.withOpacity(0.3),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Faculty Quizzes Available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryBar.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Faculty haven\'t created any quizzes yet.\nPlease check back later.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryBar.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final subject = filteredSubjects[index];
                      return _buildSubjectCard(context, subject, index);
                    },
                    childCount: filteredSubjects.length,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map<String, dynamic> subject, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      child: Card(
        elevation: 8,
        shadowColor: subject['color'].withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _navigateToQuiz(context, subject);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  subject['color'].withOpacity(0.05),
                ],
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: subject['color'],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: subject['color'].withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    subject['icon'],
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subject['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryBar,
                          fontFamily: 'PTSerif-Bold',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${_getTotalQuizCount(subject)} Faculty Quizzes',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PTSerif',
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: subject['color'].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              subject['category'],
                              style: TextStyle(
                                fontSize: 8,
                                color: subject['color'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: subject['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: subject['color'],
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'View Subject',
                        style: TextStyle(
                          color: subject['color'],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context, Map<String, dynamic> subject) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SubjectDetailScreen(subject: subject),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
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

class _QuizTakingScreenState extends State<QuizTakingScreen> with TickerProviderStateMixin {
  int current = 0;
  Map<int, int> answers = {};
  Duration remaining = Duration(minutes: 5);
  Timer? _timer;
  late AnimationController _progressController;
  late AnimationController _questionController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(seconds: 300), // 5 minutes
      vsync: this,
    );
    _questionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_progressController);
    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _questionController, curve: Curves.easeOut));
    
    _progressController.forward();
    _questionController.forward();
    
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

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuizResultScreen(
          score: score,
          total: mcqs.length,
          quizTitle: widget.quiz['title'] ?? 'Quiz',
          quizColor: widget.quiz['color'] ?? primaryButton,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _nextQuestion() {
    final mcqs = (widget.quiz['sections']?['mcq'] ?? []) as List;
    if (current < mcqs.length - 1) {
      _questionController.reset();
      setState(() => current++);
      _questionController.forward();
    } else {
      _finish();
    }
  }

  void _previousQuestion() {
    if (current > 0) {
      _questionController.reset();
      setState(() => current--);
      _questionController.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  String _fmt(Duration d) => '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final mcqs = (widget.quiz['sections']?['mcq'] ?? []) as List;
    if (mcqs.isEmpty) return Scaffold(body: Center(child: Text('No questions')));
    final q = mcqs[current];
    final quizColor = widget.quiz['color'] ?? primaryButton;

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          widget.quiz['title'] ?? 'Quiz',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: quizColor,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  _fmt(remaining),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: quizColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${current + 1} of ${mcqs.length}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontFamily: 'PTSerif',
                      ),
                    ),
                    Text(
                      '${((current + 1) / mcqs.length * 100).round()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (current + 1) / mcqs.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          
          // Question Section
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: quizColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        q['question'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBar,
                          height: 1.4,
                          fontFamily: 'PTSerif-Bold',
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: (q['options'] as List).length,
                        itemBuilder: (context, optionIndex) {
                          final option = (q['options'] as List)[optionIndex];
                          final isSelected = answers[current] == optionIndex;
                          
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => setState(() => answers[current] = optionIndex),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? quizColor.withOpacity(0.1) : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? quizColor : Colors.grey.withOpacity(0.3),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: quizColor.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ] : [],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? quizColor : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected ? quizColor : Colors.grey.withOpacity(0.5),
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(Icons.check, color: Colors.white, size: 16)
                                            : null,
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isSelected ? quizColor : primaryBar,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            fontFamily: 'PTSerif',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (current > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _previousQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: primaryBar,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (current > 0) SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: answers[current] != null ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: quizColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      current < mcqs.length - 1 ? 'Next Question' : 'Submit Quiz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String quizTitle;
  final Color quizColor;

  QuizResultScreen({
    required this.score,
    required this.total,
    required this.quizTitle,
    this.quizColor = Colors.blue,
  });

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scoreController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _scoreAnimation = Tween<double>(begin: 0.0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 500), () {
      _scoreController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  String get _performanceText {
    final percentage = (widget.score / widget.total) * 100;
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Great Job!';
    if (percentage >= 70) return 'Good Work!';
    if (percentage >= 60) return 'Not Bad!';
    return 'Keep Trying!';
  }

  Color get _performanceColor {
    final percentage = (widget.score / widget.total) * 100;
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.lightGreen;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.total) * 100;
    
    return Scaffold(
      backgroundColor: primaryWhite,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.quizColor,
                      widget.quizColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PTSerif-Bold',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.quizTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontFamily: 'PTSerif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      
                      // Score Circle
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _performanceColor.withOpacity(0.1),
                                _performanceColor.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: _performanceColor.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _scoreAnimation,
                                  builder: (context, child) {
                                    return Text(
                                      '${_scoreAnimation.value.round()}',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: _performanceColor,
                                        fontFamily: 'PTSerif-Bold',
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  '/ ${widget.total}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: primaryBar.withOpacity(0.6),
                                    fontFamily: 'PTSerif',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _performanceColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${percentage.round()}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _performanceColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Performance Text
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          _performanceText,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _performanceColor,
                            fontFamily: 'PTSerif-Bold',
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      Text(
                        percentage >= 70 
                            ? 'You have a good understanding of the subject!'
                            : 'Review the topics and try again to improve your score.',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryBar.withOpacity(0.7),
                          fontFamily: 'PTSerif',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      Spacer(),
                      
                      // Action Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.quizColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'Back to Quizzes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: widget.quizColor,
                                side: BorderSide(color: widget.quizColor),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
