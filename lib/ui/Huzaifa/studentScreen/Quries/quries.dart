import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qabilacademy/providers/query_provider.dart';

class QueriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final queryProvider = Provider.of<QueryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Queries',
          style:
              GoogleFonts.poppins(fontSize: 23.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryProvider.queryController,
                    decoration: InputDecoration(
                      focusColor: Colors.teal,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.teal)),
                      hintText: 'Enter your query...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal.shade400),
                  ),
                  onPressed: queryProvider.submitQuery,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<QueryProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.queries.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(provider.queries[index]['query']!),
                        subtitle: Text(provider.queries[index]['response']!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
