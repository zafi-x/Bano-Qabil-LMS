import 'package:flutter/material.dart';

class QueryProvider with ChangeNotifier {
  final TextEditingController queryController = TextEditingController();
  List<Map<String, String>> _queries = [];

  List<Map<String, String>> get queries => _queries;

  void submitQuery() {
    if (queryController.text.isNotEmpty) {
      _queries.insert(0,
          {'query': queryController.text, 'response': 'Pending response...'});
      queryController.clear();
      notifyListeners();
    }
  }
}
