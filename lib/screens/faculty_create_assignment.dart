import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/faculty_subjects_data.dart';

class FacultyCreateAssignment extends StatefulWidget {
  final Map<String, dynamic>? preselectedSubject;
  const FacultyCreateAssignment({Key? key, this.preselectedSubject}) : super(key: key);

  @override
  _FacultyCreateAssignmentState createState() => _FacultyCreateAssignmentState();
}

class _FacultyCreateAssignmentState extends State<FacultyCreateAssignment> with SingleTickerProviderStateMixin {
  late Map<String, dynamic>? _selectedSubject;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime? _dueDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedSubject = widget.preselectedSubject;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(Duration(days: 365)),
      lastDate: now.add(Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a subject')));
      return;
    }

    setState(() => _loading = true);
    // For now this is a local placeholder. You can wire Firestore saving here.
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() => _loading = false);
      showDialog(context: context, builder: (_) => AlertDialog(
        title: Text('Assignment Created'),
        content: Text('"$_title" created for ${_selectedSubject!['label'] ?? 'subject'}.'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedSubject != null ? 'Create Assignment - ${(_selectedSubject!['label'] ?? _selectedSubject!['value'])}' : 'Create Assignment'),
        backgroundColor: _selectedSubject != null ? (_selectedSubject!['color'] ?? primaryBar) : primaryBar,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Subject selector (grid-like compact list)
              Text('Select Subject', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBar)),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: facultySubjects.map((subject) {
                  final bool isSelected = _selectedSubject != null && _selectedSubject!['value'] == subject['value'];
                  return ChoiceChip(
                    label: Text(subject['label']),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedSubject = subject),
                    selectedColor: subject['color'],
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(color: isSelected ? Colors.white : primaryBar),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Assignment Title', prefixIcon: Icon(Icons.title)),
                      onChanged: (v) => _title = v,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter a title' : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Description', prefixIcon: Icon(Icons.description)),
                      maxLines: 4,
                      onChanged: (v) => _description = v,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter a description' : null,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(_dueDate == null ? 'No due date chosen' : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
                        ),
                        TextButton.icon(onPressed: _pickDueDate, icon: Icon(Icons.calendar_today), label: Text('Pick Date')),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(backgroundColor: _selectedSubject != null ? _selectedSubject!['color'] : primaryButton),
                        child: _loading ? CircularProgressIndicator() : Text('Create Assignment', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
