import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final bool loading;
  final String title;
  final VoidCallback onTap;
  const MainButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.indigo, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: loading
                  ? const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    )
                  : Text(
                      title,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ))),
    );
  }
}
