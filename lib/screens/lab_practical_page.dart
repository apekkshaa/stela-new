import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LabPracticalPage extends StatelessWidget {
  const LabPracticalPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sampleExercises = const [
    {
      'title': 'Experiment 1: Digital Logic Simulation',
      'desc': 'Build and simulate basic logic gates using provided tools.'
    },
    {
      'title': 'Experiment 2: Network Packet Capture',
      'desc': 'Capture and analyse packets from a sample pcap file.'
    },
    {
      'title': 'Experiment 3: Sensor Data Acquisition',
      'desc': 'Read and plot sensor output using the lab toolkit.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Practical'),
        backgroundColor: primaryBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Practical Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('lab_practicals').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                  if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    // show sample exercises when none created by faculty yet
                    return ListView.separated(
                      itemCount: _sampleExercises.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final ex = _sampleExercises[index];
                        return Card(
                          child: ListTile(
                            title: Text(ex['title'] ?? ''),
                            subtitle: Text(ex['desc'] ?? ''),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => LabPracticalDetailPage(title: ex['title'] ?? '', desc: ex['desc'] ?? '')),
                                );
                              },
                              child: Text('Start'),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final d = docs[index];
                      final data = d.data() as Map<String, dynamic>? ?? {};
                      final title = data['title'] ?? 'Untitled Practical';
                      final desc = data['description'] ?? '';
                      return Card(
                        child: ListTile(
                          title: Text(title),
                          subtitle: Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LabPracticalDetailPage.fromMap(id: d.id, data: data)),
                              );
                            },
                            child: Text('Start'),
                          ),
                        ),
                      );
                    },
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

class LabPracticalDetailPage extends StatelessWidget {
  final String? id;
  final Map<String, dynamic>? data;
  final String? title;
  final String? desc;

  const LabPracticalDetailPage({Key? key, this.id, this.data, this.title, this.desc}) : super(key: key);

  factory LabPracticalDetailPage.fromMap({required String id, required Map<String, dynamic> data}) {
    return LabPracticalDetailPage(id: id, data: data, title: data['title'] as String?, desc: data['description'] as String?);
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? data?['title'] ?? 'Lab Practical';
    final displayDesc = desc ?? data?['description'] ?? '';
    final createdByName = data?['createdByName'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle),
        backgroundColor: primaryBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayDesc, style: TextStyle(fontSize: 16)),
            SizedBox(height: 18),
            Text('Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Read the problem statement carefully.\n2. Follow the step-by-step procedure provided in the lab resources.\n3. Submit your results or screenshots where required.'),
            SizedBox(height: 18),
            if (createdByName.isNotEmpty) Text('Created by $createdByName', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as started')));
              },
              child: Text('Mark as Started'),
            ),
          ],
        ),
      ),
    );
  }
}
