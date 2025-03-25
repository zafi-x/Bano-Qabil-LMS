import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class TaskSubmissionScreen extends StatefulWidget {
  final String? studentId;
  final String studentName;

  TaskSubmissionScreen({this.studentId, required this.studentName});

  @override
  _TaskSubmissionScreenState createState() => _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends State<TaskSubmissionScreen> {
  bool _isLoading = false;
  Map<String, bool> _submissionStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchSubmissionStatus();
  }

  Future<void> _fetchSubmissionStatus() async {
    var snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    Map<String, bool> status = {};

    for (var doc in snapshot.docs) {
      var submission = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(doc.id)
          .collection('submissions')
          .doc(widget.studentId)
          .get();

      status[doc.id] = submission.exists;
    }

    setState(() {
      _submissionStatus = status;
    });
  }

  Future<void> _submitOrEditTask(String taskId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() => _isLoading = true);
      String fileName = result.files.single.name;

      try {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskId)
            .collection('submissions')
            .doc(widget.studentId)
            .set({
          'studentName': widget.studentName,
          'fileName': fileName,
          'submittedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isLoading = false;
          _submissionStatus[taskId] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task submitted/updated successfully!')),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit task: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected!')),
      );
    }
  }

  Future<void> _removeTaskFromStudentView(String taskId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Task?'),
        content:
            Text('Are you sure you want to remove this task from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskId)
            .collection('submissions')
            .doc(widget.studentId)
            .delete();

        setState(() {
          _submissionStatus.remove(taskId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task removed from your list!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove task: $e')),
        );
      }
    }
  }

  bool _isDeadlinePassed(DateTime? deadline) {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Tasks')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              DateTime? deadline =
                  (task.data() as Map<String, dynamic>).containsKey('deadline')
                      ? (task['deadline'] as Timestamp).toDate()
                      : null;

              bool isExpired = _isDeadlinePassed(deadline);
              bool isSubmitted = _submissionStatus[task.id] ?? false;

              return isSubmitted
                  ? Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) =>
                          _removeTaskFromStudentView(task.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: _buildTaskTile(task, isExpired, isSubmitted),
                    )
                  : _buildTaskTile(task, isExpired, isSubmitted);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskTile(
      DocumentSnapshot task, bool isExpired, bool isSubmitted) {
    DateTime? deadline =
        (task.data() as Map<String, dynamic>).containsKey('deadline')
            ? (task['deadline'] as Timestamp).toDate()
            : null;

    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title:
            Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['description']),
            if (deadline != null)
              Text(
                'Deadline: ${DateFormat.yMMMd().add_jm().format(deadline)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: isExpired
            ? Text('Expired', style: TextStyle(color: Colors.red))
            : isSubmitted
                ? ElevatedButton.icon(
                    onPressed: () => _submitOrEditTask(task.id),
                    icon: Icon(Icons.edit, size: 18),
                    label: Text('Edit'),
                  )
                : ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _submitOrEditTask(task.id),
                    child: Text('Submit'),
                  ),
      ),
    );
  }
}
