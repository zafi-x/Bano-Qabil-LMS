import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminTaskSubmissionScreen extends StatelessWidget {
  const AdminTaskSubmissionScreen({super.key});

  Future<void> _openFile(String fileUrl) async {
    final Uri url = Uri.parse(fileUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open the file';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Submissions')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, taskSnapshot) {
          if (!taskSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var tasks = taskSnapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return ExpansionTile(
                title: Text(task['title'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(task['description']),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .collection('submissions')
                        .snapshots(),
                    builder: (context, submissionSnapshot) {
                      if (!submissionSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var submissions = submissionSnapshot.data!.docs;

                      if (submissions.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('No submissions yet.',
                              style: TextStyle(color: Colors.grey)),
                        );
                      }

                      return Column(
                        children: submissions.map((submission) {
                          var submissionData =
                              submission.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(submissionData['studentName']),
                            subtitle: Text(
                              'Submitted: ${DateFormat.yMMMd().add_jm().format((submissionData['submittedAt'] as Timestamp).toDate())}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.download, color: Colors.blue),
                              onPressed: () =>
                                  _openFile(submissionData['fileUrl']),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
