import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stela_app/constants/colors.dart';

class SubmitAssignmentPage extends StatefulWidget {
  @override
  _SubmitAssignmentPageState createState() => _SubmitAssignmentPageState();
}

class _SubmitAssignmentPageState extends State<SubmitAssignmentPage> {
  String? _fileName;
  PlatformFile? _pickedFile;
  bool _isSubmitting = false;
  bool _submitted = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
        _fileName = _pickedFile!.name;
        _submitted = false;
      });
    }
  }

  Future<void> _submitAssignment() async {
    if (_pickedFile == null) return;
    setState(() {
      _isSubmitting = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Simulate upload
    setState(() {
      _isSubmitting = false;
      _submitted = true;
      _pickedFile = null;
      _fileName = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assignment submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Assignments", style: TextStyle(fontFamily: 'PTSerif-Bold')),
        backgroundColor: primaryBar,
        elevation: 0,
      ),
      backgroundColor: primaryWhite,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: primaryBar.withOpacity(0.08),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, size: 48, color: primaryButton),
              SizedBox(height: 18),
              Text(
                'Attach your assignment file',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'PTSerif-Bold',
                  color: primaryBar,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              OutlinedButton.icon(
                icon: Icon(Icons.attach_file, color: primaryButton),
                label: Text('Choose File', style: TextStyle(color: primaryButton)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryButton),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _isSubmitting ? null : _pickFile,
              ),
              if (_fileName != null) ...[
                SizedBox(height: 12),
                Text(
                  'Selected: $_fileName',
                  style: TextStyle(fontSize: 14, color: primaryBar.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_pickedFile != null && !_isSubmitting) ? _submitAssignment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryButton,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Submit', style: TextStyle(fontFamily: 'PTSerif-Bold', fontSize: 16)),
                ),
              ),
              if (_submitted)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Submitted!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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