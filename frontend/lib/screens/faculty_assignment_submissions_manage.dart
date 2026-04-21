import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FacultyAssignmentSubmissionsManage extends StatefulWidget {
  final Map<String, dynamic> subject;
  const FacultyAssignmentSubmissionsManage({required this.subject, super.key});

  @override
  State<FacultyAssignmentSubmissionsManage> createState() => _FacultyAssignmentSubmissionsManageState();
}

class _FacultyAssignmentSubmissionsManageState extends State<FacultyAssignmentSubmissionsManage> {
  final _firestore = FirebaseFirestore.instance;

  final Map<String, Map<String, dynamic>> _studentCache = {};
  final Set<String> _studentLoading = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> _ensureStudentsLoaded(Iterable<String> uids) async {
    final missing = uids.where((u) => u.isNotEmpty && !_studentCache.containsKey(u) && !_studentLoading.contains(u)).toList();
    if (missing.isEmpty) return;

    setState(() {
      _studentLoading.addAll(missing);
    });

    for (final uid in missing) {
      try {
        final snap = await _firestore.collection('students').doc(uid).get().timeout(const Duration(seconds: 15));
        if (!mounted) return;
        setState(() {
          _studentCache[uid] = snap.data() ?? const <String, dynamic>{};
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _studentCache[uid] = const <String, dynamic>{};
        });
      } finally {
        if (!mounted) return;
        setState(() {
          _studentLoading.remove(uid);
        });
      }
    }
  }

  String _studentName(String studentUid, Map<String, dynamic> submission) {
    final fromSubmission = (submission['studentName'] ?? '').toString().trim();
    if (fromSubmission.isNotEmpty) return fromSubmission;

    final data = _studentCache[studentUid];
    final name = (data?['name'] ?? data?['fullName'] ?? '').toString().trim();
    return name.isNotEmpty ? name : studentUid;
  }

  String _studentEnrollment(String studentUid, Map<String, dynamic> submission) {
    final fromSubmission = (submission['enrollmentNumber'] ?? submission['enrollmentNo'] ?? '').toString().trim();
    if (fromSubmission.isNotEmpty) return fromSubmission;

    final data = _studentCache[studentUid];
    final v = (data?['enrollmentNumber'] ?? data?['enrollmentNo'] ?? data?['rollNumber'] ?? data?['rollNo'] ?? '').toString().trim();
    return v;
  }

  String _studentBatch(String studentUid, Map<String, dynamic> submission) {
    final fromSubmission = (submission['batch'] ?? submission['year'] ?? submission['section'] ?? '').toString().trim();
    if (fromSubmission.isNotEmpty) return fromSubmission;

    final data = _studentCache[studentUid];
    final v = (data?['batch'] ?? data?['year'] ?? data?['section'] ?? data?['department'] ?? '').toString().trim();
    return v;
  }

  Future<void> _openFileUrl(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return;

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open file URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectLabel = (widget.subject['label'] ?? widget.subject['id'] ?? '').toString();
    final subjectId = (widget.subject['id'] ?? widget.subject['value'] ?? '').toString();

    final baseQuery = subjectId.isNotEmpty
        ? _firestore.collection('assignmentSubmissions').where('subjectId', isEqualTo: subjectId)
        : _firestore.collection('assignmentSubmissions').where('subjectLabel', isEqualTo: subjectLabel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Submissions - $subjectLabel'),
        backgroundColor: widget.subject['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: baseQuery.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading submissions: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? const [];
            if (docs.isEmpty) {
              return const Center(child: Text('No assignment submissions yet.'));
            }

            final items = docs.map((d) => {'id': d.id, ...d.data()}).toList();
            items.sort((a, b) {
              final at = a['submittedAt'];
              final bt = b['submittedAt'];
              final aMs = at is Timestamp ? at.millisecondsSinceEpoch : 0;
              final bMs = bt is Timestamp ? bt.millisecondsSinceEpoch : 0;
              return bMs.compareTo(aMs);
            });

            // Load student profiles (name/enrollment/batch) for display.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final uids = items
                  .map((e) => (e['studentUID'] ?? '').toString())
                  .where((u) => u.isNotEmpty)
                  .toSet();
              _ensureStudentsLoaded(uids);
            });

            // Group by assignment.
            final Map<String, List<Map<String, dynamic>>> groups = {};
            for (final s in items) {
              final key = (s['assignmentTitle'] ?? s['assignmentId'] ?? 'Unknown Assignment').toString();
              groups.putIfAbsent(key, () => []).add(s);
            }

            final entries = groups.entries.toList();

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final assignmentTitle = entry.key;
                final submissions = entry.value;

                return Card(
                  child: ExpansionTile(
                    title: Text(
                      assignmentTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${submissions.length} submissions'),
                    children: submissions.map((s) {
                      final studentUid = (s['studentUID'] ?? '').toString();
                      final name = _studentName(studentUid, s);
                      final enrollment = _studentEnrollment(studentUid, s);
                      final batch = _studentBatch(studentUid, s);
                      final fileName = (s['fileName'] ?? '').toString();
                      final fileUrl = (s['fileUrl'] ?? '').toString();
                      final submittedAt = s['submittedAt'];
                      final submittedText = submittedAt is Timestamp
                          ? submittedAt.toDate().toLocal().toString()
                          : '';

                      final subtitleBits = <String>[];
                      if (enrollment.isNotEmpty) subtitleBits.add('Roll: $enrollment');
                      if (batch.isNotEmpty) subtitleBits.add('Batch: $batch');
                      if (fileName.trim().isNotEmpty) subtitleBits.add('File: $fileName');
                      if (submittedText.isNotEmpty) subtitleBits.add('Submitted: $submittedText');

                      return ListTile(
                        title: Text(name),
                        subtitle: Text(subtitleBits.join(' • ')),
                        trailing: TextButton(
                          onPressed: fileUrl.trim().isEmpty ? null : () => _openFileUrl(fileUrl),
                          child: const Text('Open file'),
                        ),
                        onTap: fileUrl.trim().isEmpty ? null : () => _openFileUrl(fileUrl),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
