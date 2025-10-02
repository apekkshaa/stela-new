import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stela_app/screens/TakeQuizPage.dart';

class Quizzes extends StatefulWidget {
  @override
  _QuizzesState createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  // Store quizzes fetched from Firestore
  Map<String, List<Map<String, dynamic>>> firestoreQuizzes = {};

  Future<void> fetchAllQuizzes() async {
    print('\n=== Fetching all quizzes for quizzes page ===');
    final firestore = FirebaseFirestore.instance;
    final quizCollection = await firestore.collection('quizzes').get();
    print('Found ${quizCollection.docs.length} subject documents in quizzes collection');
    
    for (var subjectDoc in quizCollection.docs) {
      final subject = subjectDoc.id;
      print('Processing subject: $subject');
      var snapshot = await firestore.collection('quizzes').doc(subject).collection('items').get();
      print('Found ${snapshot.docs.length} quiz items for $subject');
      
      firestoreQuizzes[subject] = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        print('Quiz data for ${doc.id}: $data');
        return data;
      }).toList();
    }
    
    print('\n=== Final Firestore quizzes summary ===');
    int totalQuizzes = 0;
    firestoreQuizzes.forEach((subject, quizzes) {
      print('Subject: $subject - ${quizzes.length} quizzes');
      totalQuizzes += quizzes.length;
      for (var quiz in quizzes) {
        print('  - ${quiz['title']} (${quiz['questions']?.length ?? 0} questions)');
      }
    });
    print('Total quizzes loaded: $totalQuizzes');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAllQuizzes();
  }
  String selectedSubject = 'All';
  String selectedDifficulty = 'Easy';
  int userStreak = 0;
  int userCoins = 1250;
  double overallProgress = 0.0;

  final List<String> subjects = [
    'All',
    'Computer Organization and Architecture (COA)',
    'Data Structures and Algorithms (DSA)',
    'Python Programming',
    'Artificial Intelligence (AI)',
    'Cloud Computing'
  ];

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  final Map<String, List<Map<String, dynamic>>> quizData = {
    'Computer Organization and Architecture (COA)': [
      {
        'title': 'Decoding CPU Pipelines',
        'difficulty': 'Easy',
        'sections': {
          'mcq': [
            {
              'question': 'What is the primary function of the ALU in a CPU?',
              'options': [
                'Memory management',
                'Arithmetic and logical operations',
                'Input/output control',
                'Cache management'
              ],
              'correct': 1,
              'explanation':
                  'The ALU (Arithmetic Logic Unit) performs arithmetic and logical operations.'
            },
            {
              'question':
                  'Which pipeline stage comes first in a typical 5-stage pipeline?',
              'options': ['Execute', 'Fetch', 'Decode', 'Memory'],
              'correct': 1,
              'explanation': 'Fetch is always the first stage in a pipeline.'
            },
            {
              'question': 'What is cache memory primarily used for?',
              'options': [
                'Long-term storage',
                'Temporary data storage',
                'Fast access to frequently used data',
                'Backup storage'
              ],
              'correct': 2,
              'explanation':
                  'Cache memory provides fast access to frequently used data.'
            },
            {
              'question': 'Which addressing mode uses the operand directly?',
              'options': [
                'Immediate addressing',
                'Direct addressing',
                'Indirect addressing',
                'Register addressing'
              ],
              'correct': 0,
              'explanation':
                  'Immediate addressing uses the operand directly in the instruction.'
            },
            {
              'question':
                  'What does the term "pipelining" refer to in CPU design?',
              'options': [
                'Parallel processing of multiple instructions',
                'Sequential processing',
                'Memory management',
                'Cache optimization'
              ],
              'correct': 0,
              'explanation':
                  'Pipelining allows parallel processing of multiple instructions.'
            }
          ],
          'shortProblems': [
            {
              'question':
                  'Explain the concept of memory hierarchy and why it\'s important in computer architecture.',
              'modelAnswer':
                  'Memory hierarchy organizes memory into different levels based on speed and cost. Faster, smaller memories (cache) are placed closer to CPU, while slower, larger memories (RAM, disk) are further away. This optimizes performance and cost.'
            },
            {
              'question':
                  'Describe the difference between RISC and CISC architectures with examples.',
              'modelAnswer':
                  'RISC (Reduced Instruction Set Computing) uses simple, uniform instructions executed in one cycle. CISC (Complex Instruction Set Computing) uses complex instructions that may take multiple cycles. RISC examples: ARM, MIPS. CISC examples: x86, Intel processors.'
            }
          ],
          'codingChallenge': {
            'title': 'Implement a Simple Cache Simulator',
            'problem':
                'Create a basic cache simulator that can handle direct-mapped cache with configurable block size and cache size.',
            'inputFormat': 'Cache size, block size, memory address',
            'outputFormat': 'Hit/Miss status and cache contents',
            'constraints':
                'Cache size must be power of 2, block size must be power of 2',
            'sampleTestCases': [
              'Input: Cache size=8, Block size=4, Address=12\nOutput: Miss',
              'Input: Cache size=8, Block size=4, Address=16\nOutput: Hit'
            ],
            'stepMarks': [
              'Correct function signature (10 points)',
              'Proper cache initialization (20 points)',
              'Address calculation logic (30 points)',
              'Hit/miss detection (25 points)',
              'Cache update mechanism (15 points)'
            ]
          }
        }
      }
    ],
    'Data Structures and Algorithms (DSA)': [
      {
        'title': 'Tree Traversal Mastery',
        'difficulty': 'Medium',
        'sections': {
          'mcq': [
            {
              'question':
                  'What is the time complexity of searching in a balanced binary search tree?',
              'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
              'correct': 1,
              'explanation':
                  'Balanced BST provides O(log n) search time complexity.'
            },
            {
              'question':
                  'Which traversal visits root, left subtree, then right subtree?',
              'options': ['Inorder', 'Preorder', 'Postorder', 'Level order'],
              'correct': 1,
              'explanation':
                  'Preorder traversal visits root first, then left subtree, then right subtree.'
            },
            {
              'question':
                  'What is the maximum number of nodes in a binary tree of height h?',
              'options': ['2^h', '2^h - 1', '2^(h+1) - 1', 'h^2'],
              'correct': 2,
              'explanation':
                  'Maximum nodes = 2^(h+1) - 1 for a binary tree of height h.'
            },
            {
              'question':
                  'Which data structure is best for implementing a priority queue?',
              'options': ['Array', 'Linked List', 'Heap', 'Stack'],
              'correct': 2,
              'explanation':
                  'Heap is the most efficient data structure for priority queue implementation.'
            },
            {
              'question':
                  'What is the space complexity of recursive DFS traversal?',
              'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
              'correct': 1,
              'explanation':
                  'Recursive DFS uses O(log n) space due to call stack depth.'
            }
          ],
          'shortProblems': [
            {
              'question':
                  'Explain the difference between BFS and DFS with their use cases.',
              'modelAnswer':
                  'BFS explores all neighbors at current depth before moving to next level. DFS explores as far as possible along each branch before backtracking. BFS is used for shortest path, level-order traversal. DFS is used for topological sorting, maze solving.'
            },
            {
              'question': 'Describe how to implement a stack using two queues.',
              'modelAnswer':
                  'Use two queues q1 and q2. For push: enqueue to q1. For pop: dequeue all elements from q1 except last, enqueue them to q2, dequeue and return last element from q1, swap q1 and q2.'
            }
          ],
          'codingChallenge': {
            'title': 'BFS Traversal Implementation',
            'problem':
                'Implement a function to perform level-order traversal of a binary tree and return the nodes at each level as separate lists.',
            'inputFormat': 'Binary tree root node',
            'outputFormat':
                'List of lists, where each inner list contains nodes at that level',
            'constraints': 'Tree can have up to 1000 nodes, handle null values',
            'sampleTestCases': [
              'Input: [3,9,20,null,null,15,7]\nOutput: [[3],[9,20],[15,7]]',
              'Input: [1]\nOutput: [[1]]'
            ],
            'stepMarks': [
              'Correct function signature (10 points)',
              'Queue initialization (15 points)',
              'Level tracking logic (25 points)',
              'Node processing loop (30 points)',
              'Result formatting (20 points)'
            ]
          }
        }
      }
    ],
    'Python Programming': [
      {
        'title': 'Python Data Structures Deep Dive',
        'difficulty': 'Easy',
        'sections': {
          'mcq': [
            {
              'question':
                  'What is the time complexity of appending to a Python list?',
              'options': ['O(1) amortized', 'O(n)', 'O(log n)', 'O(n²)'],
              'correct': 0,
              'explanation':
                  'Python list append is O(1) amortized time complexity.'
            },
            {
              'question':
                  'Which method removes and returns the last element from a list?',
              'options': ['remove()', 'pop()', 'delete()', 'extract()'],
              'correct': 1,
              'explanation':
                  'pop() removes and returns the last element from a list.'
            },
            {
              'question': 'What is the output of: list(range(5))?',
              'options': [
                '[0, 1, 2, 3, 4]',
                '[1, 2, 3, 4, 5]',
                '[0, 1, 2, 3, 4, 5]',
                '[1, 2, 3, 4]'
              ],
              'correct': 0,
              'explanation':
                  'range(5) generates 0, 1, 2, 3, 4, and list() converts it to a list.'
            },
            {
              'question':
                  'Which data structure is best for checking membership?',
              'options': ['List', 'Set', 'Tuple', 'Dictionary'],
              'correct': 1,
              'explanation':
                  'Set provides O(1) average time complexity for membership testing.'
            },
            {
              'question': 'What does the * operator do with lists?',
              'options': [
                'Multiplication',
                'Repetition',
                'Exponentiation',
                'Concatenation'
              ],
              'correct': 1,
              'explanation': 'The * operator repeats the list elements.'
            }
          ],
          'shortProblems': [
            {
              'question':
                  'Explain the difference between shallow copy and deep copy in Python.',
              'modelAnswer':
                  'Shallow copy creates a new object but references the same nested objects. Deep copy creates a new object and recursively copies all nested objects. Use copy() for shallow, deepcopy() for deep copy.'
            },
            {
              'question': 'Describe list comprehension and provide an example.',
              'modelAnswer':
                  'List comprehension is a concise way to create lists. Syntax: [expression for item in iterable if condition]. Example: [x**2 for x in range(5) if x % 2 == 0] creates [0, 4, 16].'
            }
          ],
          'codingChallenge': {
            'title': 'List Operations Implementation',
            'problem':
                'Implement a function that takes a list of integers and returns a new list containing only the elements that appear more than once, maintaining their order of first appearance.',
            'inputFormat': 'List of integers',
            'outputFormat': 'List of integers that appear more than once',
            'constraints': 'List length ≤ 1000, integers ≤ 10000',
            'sampleTestCases': [
              'Input: [1,2,3,1,4,2]\nOutput: [1,2]',
              'Input: [1,2,3,4]\nOutput: []'
            ],
            'stepMarks': [
              'Correct function signature (10 points)',
              'Dictionary for counting (25 points)',
              'Frequency counting logic (30 points)',
              'Result filtering (25 points)',
              'Order maintenance (10 points)'
            ]
          }
        }
      }
    ],
    'Artificial Intelligence (AI)': [
      {
        'title': 'Machine Learning Fundamentals',
        'difficulty': 'Hard',
        'sections': {
          'mcq': [
            {
              'question': 'What is overfitting in machine learning?',
              'options': [
                'Model performs well on training data but poorly on test data',
                'Model performs poorly on both training and test data',
                'Model performs well on both training and test data',
                'Model has too few parameters'
              ],
              'correct': 0,
              'explanation':
                  'Overfitting occurs when model learns training data too well but fails to generalize.'
            },
            {
              'question':
                  'Which algorithm is used for classification problems?',
              'options': [
                'Linear Regression',
                'Logistic Regression',
                'K-means Clustering',
                'Principal Component Analysis'
              ],
              'correct': 1,
              'explanation':
                  'Logistic Regression is used for binary classification problems.'
            },
            {
              'question': 'What is the purpose of cross-validation?',
              'options': [
                'To increase model complexity',
                'To reduce training time',
                'To assess model performance on unseen data',
                'To reduce feature dimensionality'
              ],
              'correct': 2,
              'explanation':
                  'Cross-validation helps assess how well the model generalizes to unseen data.'
            },
            {
              'question':
                  'Which activation function is commonly used in hidden layers?',
              'options': ['Sigmoid', 'ReLU', 'Linear', 'Step function'],
              'correct': 1,
              'explanation':
                  'ReLU (Rectified Linear Unit) is commonly used in hidden layers.'
            },
            {
              'question':
                  'What is the difference between supervised and unsupervised learning?',
              'options': [
                'Supervised uses labeled data, unsupervised uses unlabeled data',
                'Supervised uses unlabeled data, unsupervised uses labeled data',
                'Both use labeled data',
                'Both use unlabeled data'
              ],
              'correct': 0,
              'explanation':
                  'Supervised learning uses labeled training data, unsupervised learning uses unlabeled data.'
            }
          ],
          'shortProblems': [
            {
              'question':
                  'Explain the concept of bias-variance tradeoff in machine learning.',
              'modelAnswer':
                  'Bias-variance tradeoff is the relationship between model complexity and generalization error. High bias (underfitting) means model is too simple. High variance (overfitting) means model is too complex. Optimal model balances both.'
            },
            {
              'question':
                  'Describe the working of the k-nearest neighbors (KNN) algorithm.',
              'modelAnswer':
                  'KNN finds k nearest training examples to a test point and predicts the majority class (classification) or average value (regression). Distance metric (Euclidean, Manhattan) determines "nearest". K value affects model complexity.'
            }
          ],
          'codingChallenge': {
            'title': 'K-Means Clustering Implementation',
            'problem':
                'Implement the K-means clustering algorithm from scratch. The function should take data points and number of clusters k, and return cluster assignments and centroids.',
            'inputFormat': '2D array of data points, number of clusters k',
            'outputFormat': 'Cluster assignments array, centroids array',
            'constraints': 'k ≤ 10, data points ≤ 1000, max iterations = 100',
            'sampleTestCases': [
              'Input: [[1,1], [2,2], [8,8], [9,9]], k=2\nOutput: [0,0,1,1], [[1.5,1.5], [8.5,8.5]]',
              'Input: [[1,1], [1,2], [2,1]], k=1\nOutput: [0,0,0], [[1.33,1.33]]'
            ],
            'stepMarks': [
              'Correct function signature (10 points)',
              'Centroid initialization (20 points)',
              'Distance calculation (25 points)',
              'Assignment logic (25 points)',
              'Centroid update (20 points)'
            ]
          }
        }
      }
    ],
    'Cloud Computing': [
      {
        'title': 'Cloud Architecture & Services',
        'difficulty': 'Medium',
        'sections': {
          'mcq': [
            {
              'question': 'What is the main advantage of cloud computing?',
              'options': [
                'Lower security',
                'Scalability and flexibility',
                'Higher latency',
                'Limited accessibility'
              ],
              'correct': 1,
              'explanation':
                  'Scalability and flexibility are primary advantages of cloud computing.'
            },
            {
              'question':
                  'Which cloud service model provides the most control to users?',
              'options': ['SaaS', 'PaaS', 'IaaS', 'FaaS'],
              'correct': 2,
              'explanation':
                  'IaaS (Infrastructure as a Service) provides the most control to users.'
            },
            {
              'question': 'What is auto-scaling in cloud computing?',
              'options': [
                'Automatic backup',
                'Automatic resource adjustment based on demand',
                'Automatic security updates',
                'Automatic cost optimization'
              ],
              'correct': 1,
              'explanation':
                  'Auto-scaling automatically adjusts resources based on demand.'
            },
            {
              'question': 'Which AWS service is used for object storage?',
              'options': ['EC2', 'S3', 'RDS', 'Lambda'],
              'correct': 1,
              'explanation':
                  'Amazon S3 (Simple Storage Service) is used for object storage.'
            },
            {
              'question': 'What is the purpose of load balancing?',
              'options': [
                'To increase security',
                'To distribute traffic across multiple servers',
                'To reduce storage costs',
                'To improve backup speed'
              ],
              'correct': 1,
              'explanation':
                  'Load balancing distributes incoming traffic across multiple servers.'
            }
          ],
          'shortProblems': [
            {
              'question':
                  'Explain the differences between public, private, and hybrid cloud models.',
              'modelAnswer':
                  'Public cloud: Shared infrastructure, pay-per-use, managed by third party. Private cloud: Dedicated infrastructure, higher security, managed internally. Hybrid cloud: Combination of public and private, offers flexibility and security.'
            },
            {
              'question':
                  'Describe the concept of serverless computing and its benefits.',
              'modelAnswer':
                  'Serverless computing allows running code without managing servers. Benefits include automatic scaling, pay-per-execution, reduced operational overhead, and faster deployment. Examples: AWS Lambda, Azure Functions.'
            }
          ],
          'codingChallenge': {
            'title': 'Cloud Resource Monitoring System',
            'problem':
                'Design a simple cloud resource monitoring system that tracks CPU usage, memory usage, and network traffic. Implement functions to add metrics, calculate averages, and generate alerts.',
            'inputFormat': 'Resource metrics (CPU%, Memory%, Network MB/s)',
            'outputFormat':
                'Average metrics and alerts for thresholds exceeded',
            'constraints':
                'Metrics stored for last 24 hours, alert threshold = 80%',
            'sampleTestCases': [
              'Input: CPU=85%, Memory=70%, Network=50MB/s\nOutput: Alert: High CPU usage',
              'Input: CPU=60%, Memory=65%, Network=30MB/s\nOutput: No alerts'
            ],
            'stepMarks': [
              'Data structure design (20 points)',
              'Metric storage logic (25 points)',
              'Average calculation (25 points)',
              'Alert generation (20 points)',
              'Time window management (10 points)'
            ]
          }
        }
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          'Quizzes',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBar,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stats Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryBar,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('🔥 Streak', '$userStreak days',
                        Icons.local_fire_department),
                    _buildStatCard(
                        '🪙 Coins', '$userCoins', Icons.monetization_on),
                    _buildStatCard(
                        '📊 Progress',
                        '${(overallProgress * 100).toInt()}%',
                        Icons.trending_up),
                  ],
                ),
                SizedBox(height: 20),
                // Filters
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        'Subject',
                        selectedSubject,
                        subjects,
                        (value) => setState(() => selectedSubject = value!),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildFilterDropdown(
                        'Difficulty',
                        selectedDifficulty,
                        difficulties,
                        (value) => setState(() => selectedDifficulty = value!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Quiz List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Firestore quizzes grouped by subject
                ...firestoreQuizzes.entries.expand((entry) {
                  final subject = entry.key;
                  final quizzes = entry.value;
                  if (quizzes.isEmpty) return [];
                  return [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(subject, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    ...quizzes.map((quiz) => Card(
                      child: ListTile(
                        title: Text(quiz['title'] ?? 'Untitled Quiz'),
                        subtitle: Text(quiz['description'] ?? ''),
                        trailing: ElevatedButton(
                          child: Text('Start Quiz'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => TakeQuizPage(
                                subject: subject,
                                quizId: quiz['id'],
                                quizData: quiz,
                              ),
                            ));
                          },
                        ),
                      ),
                    ))
                  ];
                }).toList(),
                // Local quizzes (if you want to show them too)
                ..._getFilteredQuizzes().map((quiz) => _buildQuizCard(quiz)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontFamily: 'PTSerif',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options,
      Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: primaryBar,
          style: TextStyle(color: Colors.white, fontFamily: 'PTSerif'),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: onChanged,
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBar.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: primaryButton.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _startQuiz(quiz),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(quiz['difficulty']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.quiz,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'PTSerif-Bold',
                              fontWeight: FontWeight.bold,
                              color: primaryBar,
                            ),
                          ),
                          Text(
                            quiz['difficulty'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _getDifficultyColor(quiz['difficulty']),
                              fontFamily: 'PTSerif',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: primaryButton, size: 16),
                  ],
                ),
                SizedBox(height: 16),
                _buildQuizStats(quiz),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryButton.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(
                      color: primaryButton,
                      fontFamily: 'PTSerif',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStats(Map<String, dynamic> quiz) {
    final sections = quiz['sections'];
    return Row(
      children: [
        _buildStatItem('MCQ', '${sections['mcq'].length} questions'),
        SizedBox(width: 16),
        _buildStatItem(
            'Problems', '${sections['shortProblems'].length} questions'),
        SizedBox(width: 16),
        _buildStatItem('Coding', '1 challenge'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontFamily: 'PTSerif',
            )),
        Text(value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return primaryButton;
    }
  }

  List<Map<String, dynamic>> _getFilteredQuizzes() {
    List<Map<String, dynamic>> allQuizzes = [];

    quizData.forEach((subject, quizzes) {
      if (selectedSubject == 'All' || selectedSubject == subject) {
        for (var quiz in quizzes) {
          if (selectedDifficulty == 'All' ||
              quiz['difficulty'] == selectedDifficulty) {
            allQuizzes.add(quiz);
          }
        }
      }
    });

    return allQuizzes;
  }

  void _startQuiz(Map<String, dynamic> quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizTakingScreen(quiz: quiz),
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
  Widget _buildSectionContent() {
    if (currentSection == 0) {
      return _buildMCQSection();
    } else if (currentSection == 1) {
      return _buildShortProblemsSection();
    } else {
      return _buildCodingSection();
    }
  }

  Widget _buildMCQSection() {
    final mcqs = widget.quiz['sections']['mcq'];
    if (currentQuestion >= mcqs.length) return Container();
    final mcq = mcqs[currentQuestion];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${currentQuestion + 1} of ${mcqs.length}',
            style: TextStyle(
              color: primaryBar.withOpacity(0.6),
              fontFamily: 'PTSerif',
            ),
          ),
          SizedBox(height: 16),
          Text(
            mcq['question'],
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
          SizedBox(height: 24),
          ...List.generate(mcq['options'].length, (i) {
            bool isSelected = mcqAnswers[currentQuestion] == i;
            return GestureDetector(
              onTap: () {
                setState(() {
                  mcqAnswers[currentQuestion] = i;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryButton.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? primaryButton : primaryBar.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? primaryButton : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? primaryButton : primaryBar.withOpacity(0.5),
                        ),
                      ),
                      child: isSelected ? Icon(Icons.check, color: Colors.white, size: 14) : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        mcq['options'][i],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSerif',
                          color: primaryBar,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 16),
          if (mcqAnswers.containsKey(currentQuestion))
            ExpansionTile(
              title: Text(
                'View Explanation',
                style: TextStyle(
                  color: primaryButton,
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryButton.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mcq['explanation'],
                    style: TextStyle(
                      fontFamily: 'PTSerif',
                      color: primaryBar,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  int currentSection = 0;
  int currentQuestion = 0;
  Map<int, int> mcqAnswers = {};
  Map<int, String> shortProblemAnswers = {};
  String codingAnswer = '';
  int totalScore = 0;
  bool isCompleted = false;

  final List<String> sections = ['MCQ', 'Short Problems', 'Coding Challenge'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          widget.quiz['title'],
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBar,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.timer, color: Colors.white),
            onPressed: () {
              // Timer functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value:
                  (currentSection * 3 + currentQuestion) / _getTotalQuestions(),
              backgroundColor: primaryBar.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(primaryButton),
            ),
          ),
          // Section Tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: sections.asMap().entries.map((entry) {
                int index = entry.key;
                String section = entry.value;
                bool isActive = currentSection == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => currentSection = index),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isActive ? primaryButton : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        section,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isActive ? Colors.white : primaryBar,
                          fontFamily: 'PTSerif',
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Quiz Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _buildSectionContent(),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (currentQuestion > 0 || currentSection > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _previousQuestion,
                      child: Text('Previous'),
                    ),
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(currentSection < 2 ? 'Next' : 'Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortProblemsSection() {
    final problems = widget.quiz['sections']['shortProblems'];
    if (currentQuestion >= problems.length) return Container();

    final problem = problems[currentQuestion];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Problem ${currentQuestion + 1} of ${problems.length}',
            style: TextStyle(
              color: primaryBar.withOpacity(0.6),
              fontFamily: 'PTSerif',
            ),
          ),
          SizedBox(height: 16),
          Text(
            problem['question'],
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryBar.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Write your answer here...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (value) =>
                  shortProblemAnswers[currentQuestion] = value,
            ),
          ),
          SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              'View Model Answer',
              style: TextStyle(
                color: primaryButton,
                fontFamily: 'PTSerif',
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryButton.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  problem['modelAnswer'],
                  style: TextStyle(
                    fontFamily: 'PTSerif',
                    color: primaryBar,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodingSection() {
    final coding = widget.quiz['sections']['codingChallenge'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coding Challenge',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
          SizedBox(height: 16),
          Text(
            coding['problem'],
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
          ),
          SizedBox(height: 16),
          _buildCodingInfo('Input Format', coding['inputFormat']),
          _buildCodingInfo('Output Format', coding['outputFormat']),
          _buildCodingInfo('Constraints', coding['constraints']),
          SizedBox(height: 16),
          Text(
            'Sample Test Cases:',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
          SizedBox(height: 8),
          ...coding['sampleTestCases']
              .map((testCase) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      testCase,
                      style: TextStyle(
                        fontFamily: 'PTSerif',
                        color: primaryBar,
                      ),
                    ),
                  ))
              .toList(),
          SizedBox(height: 16),
          Text(
            'Step-wise Marking:',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
          SizedBox(height: 8),
          ...coding['stepMarks']
              .map((step) => Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: primaryButton, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step,
                            style: TextStyle(
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryBar.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              maxLines: 15,
              decoration: InputDecoration(
                hintText: 'Write your code here...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (value) => codingAnswer = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodingInfo(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + ':',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalQuestions() {
    final sections = widget.quiz['sections'];
    return sections['mcq'].length + sections['shortProblems'].length + 1;
  }

  void _previousQuestion() {
    if (currentQuestion > 0) {
      setState(() => currentQuestion--);
    } else if (currentSection > 0) {
      setState(() {
        currentSection--;
        currentQuestion = _getSectionQuestionCount(currentSection) - 1;
      });
    }
  }

  void _nextQuestion() {
    if (currentSection < 2) {
      if (currentQuestion < _getSectionQuestionCount(currentSection) - 1) {
        setState(() => currentQuestion++);
      } else {
        setState(() {
          currentSection++;
          currentQuestion = 0;
        });
      }
    } else {
      _submitQuiz();
    }
  }

  int _getSectionQuestionCount(int section) {
    switch (section) {
      case 0:
        return widget.quiz['sections']['mcq'].length;
      case 1:
        return widget.quiz['sections']['shortProblems'].length;
      case 2:
        return 1;
      default:
        return 0;
    }
  }

  void _submitQuiz() {
    // Calculate score and show results
    setState(() => isCompleted = true);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Text('Your quiz has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
