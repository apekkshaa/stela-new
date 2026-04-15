import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  String selectedView = 'Weekly';
  int userXP = 1250;
  int userStreak = 7;
  double weeklyProgress = 0.75;

  final List<String> views = ['Weekly', 'Daily', 'Tasks', 'Notes'];
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<Map<String, dynamic>> events = [
    {
      'id': '1',
      'title': 'COA Lecture',
      'day': 'Mon',
      'startTime': '9:00 AM',
      'endTime': '10:00 AM',
      'type': 'Lecture',
      'location': 'Room 101',
      'color': Colors.blue,
      'description': 'Computer Organization and Architecture',
      'notes': 'Bring laptop for practical session',
    },
    {
      'id': '2',
      'title': 'Python Lab',
      'day': 'Thu',
      'startTime': '12:00 PM',
      'endTime': '2:00 PM',
      'type': 'Lab',
      'location': 'Lab 205',
      'color': Colors.green,
      'description': 'Python Programming Lab',
      'notes': 'Complete assignment 3 before lab',
    },
    {
      'id': '3',
      'title': 'AI Assignment',
      'day': 'Sun',
      'startTime': '5:00 PM',
      'endTime': '6:00 PM',
      'type': 'Assignment',
      'location': 'Online',
      'color': Colors.orange,
      'description': 'Machine Learning Project Due',
      'notes': 'Submit final report and code',
    },
  ];

  List<Map<String, dynamic>> tasks = [
    {
      'id': '1',
      'title': 'Complete DSA Assignment',
      'description': 'Implement binary search tree operations',
      'dueDate': '2024-01-15',
      'priority': 'High',
      'status': 'Pending',
      'category': 'Assignment',
    },
    {
      'id': '2',
      'title': 'Prepare for AI Quiz',
      'description': 'Study machine learning fundamentals',
      'dueDate': '2024-01-12',
      'priority': 'Medium',
      'status': 'In Progress',
      'category': 'Study',
    },
  ];

  List<Map<String, dynamic>> notes = [
    {
      'id': '1',
      'title': 'COA Pipeline Notes',
      'content': 'CPU pipeline stages: Fetch → Decode → Execute → Memory → Write Back',
      'tags': ['Important', 'To Review'],
      'subject': 'COA',
    },
    {
      'id': '2',
      'title': 'Python List Comprehension',
      'content': 'Syntax: [expression for item in iterable if condition]',
      'tags': ['Summary'],
      'subject': 'Python',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: Text(
          'Smart Timetable',
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
            icon: Icon(Icons.settings),
            onPressed: () => _showSettings(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsDashboard(),
          _buildViewSelector(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        backgroundColor: primaryButton,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsDashboard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
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
              _buildStatCard('🔥 Streak', '$userStreak days', Icons.local_fire_department),
              _buildStatCard('⭐ XP', '$userXP', Icons.star),
              _buildStatCard('📊 Progress', '${(weeklyProgress * 100).toInt()}%', Icons.trending_up),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: weeklyProgress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
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
    );
  }

  Widget _buildViewSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: views.map((view) {
            bool isSelected = selectedView == view;
            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => selectedView = view),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryButton : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primaryButton : primaryBar.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    view,
                    style: TextStyle(
                      color: isSelected ? Colors.white : primaryBar,
                      fontFamily: 'PTSerif',
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (selectedView) {
      case 'Weekly':
        return _buildWeeklyView();
      case 'Daily':
        return _buildDailyView();
      case 'Tasks':
        return _buildTasksView();
      case 'Notes':
        return _buildNotesView();
      default:
        return _buildWeeklyView();
    }
  }

  Widget _buildWeeklyView() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Weekly Schedule',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: primaryBar,
          ),
        ),
        SizedBox(height: 16),
        ...events.map((event) => _buildEventCard(event)).toList(),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: event['color'].withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getEventIcon(event['type']),
            color: event['color'],
          ),
        ),
        title: Text(
          event['title'],
          style: TextStyle(
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: primaryBar,
          ),
        ),
        subtitle: Text(
          '${event['startTime']} - ${event['endTime']} • ${event['location']}',
          style: TextStyle(
            fontFamily: 'PTSerif',
            color: primaryBar.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyView() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Today\'s Schedule',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: primaryBar,
          ),
        ),
        SizedBox(height: 16),
        ...events.map((event) => _buildEventCard(event)).toList(),
      ],
    );
  }

  Widget _buildTasksView() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Tasks & Reminders',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: primaryBar,
          ),
        ),
        SizedBox(height: 16),
        ...tasks.map((task) => _buildTaskCard(task)).toList(),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    Color priorityColor = _getPriorityColor(task['priority']);
    bool isCompleted = task['status'] == 'Completed';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTaskIcon(task['category']),
            color: priorityColor,
          ),
        ),
        title: Text(
          task['title'],
          style: TextStyle(
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.grey : primaryBar,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task['description'],
          style: TextStyle(
            fontFamily: 'PTSerif',
            color: primaryBar.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesView() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Notes & Resources',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: primaryBar,
          ),
        ),
        SizedBox(height: 16),
        ...notes.map((note) => _buildNoteCard(note)).toList(),
      ],
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryButton.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.note,
            color: primaryButton,
          ),
        ),
        title: Text(
          note['title'],
          style: TextStyle(
            fontFamily: 'PTSerif-Bold',
            fontWeight: FontWeight.bold,
            color: primaryBar,
          ),
        ),
        subtitle: Text(
          note['content'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'PTSerif',
            color: primaryBar.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lecture':
        return Icons.school;
      case 'lab':
        return Icons.science;
      case 'assignment':
        return Icons.assignment;
      case 'study':
        return Icons.book;
      default:
        return Icons.event;
    }
  }

  IconData _getTaskIcon(String category) {
    switch (category.toLowerCase()) {
      case 'assignment':
        return Icons.assignment;
      case 'study':
        return Icons.book;
      case 'meeting':
        return Icons.meeting_room;
      default:
        return Icons.task;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return primaryButton;
    }
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event'),
        content: Text('Event creation dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Settings'),
        content: Text('Settings dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

