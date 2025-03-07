import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RamadanTimetableScreen extends StatelessWidget {
  final List<Map<String, String>> timetable = [
    {
      "Campus": "Bano Qabil Incubation Center",
      "Course": "Class Timings will remain the same",
      "Section": "",
      "Timings": ""
    },
    {
      "Campus": "Institute of Management Sciences (Pesh)",
      "Course": "App Development",
      "Section": "Section A",
      "Timings": "10:00 AM To 11:30 AM"
    },
    {
      "Campus": "Institute of Management Sciences (Pesh)",
      "Course": "Video Editing",
      "Section": "Section B",
      "Timings": "12:00 PM To 01:30 PM"
    },
    {
      "Campus": "Qurtuba University of Science & IT",
      "Course": "Graphic Designing",
      "Section": "Section A",
      "Timings": "12:00 PM To 01:30 PM"
    },
    {
      "Campus": "Qurtuba University of Science & IT",
      "Course": "Graphic Designing",
      "Section": "Section B",
      "Timings": "01:30 PM To 03:00 PM"
    },
    {
      "Campus": "PAC Pesh",
      "Course": "Web Development",
      "Section": "Section A & B",
      "Timings": "01:30 PM To 03:00 PM"
    },
    {
      "Campus": "VERTEX, Mardan",
      "Course": "Graphic Designing",
      "Section": "Section A",
      "Timings": "09:00 AM To 10:30 AM"
    },
    {
      "Campus": "VERTEX, Mardan",
      "Course": "Graphic Designing",
      "Section": "Section B",
      "Timings": "10:30 AM To 12:00 PM"
    },
    {
      "Campus": "VERTEX, Mardan",
      "Course": "E-Commerce",
      "Section": "Section A",
      "Timings": "12:00 PM To 01:00 PM"
    },
    {
      "Campus": "VERTEX, Mardan",
      "Course": "E-Commerce",
      "Section": "Section B",
      "Timings": "01:20 PM To 02:20 PM"
    },
    {
      "Campus": "Hope College, Dir Upper",
      "Course": "Digital Marketing",
      "Section": "Section A",
      "Timings": "10:00 AM To 11:30 AM"
    },
    {
      "Campus": "Hope College, Dir Upper",
      "Course": "Graphic Designing",
      "Section": "Section B",
      "Timings": "11:30 AM To 01:00 PM"
    },
    {
      "Campus": "Riphah International University",
      "Course": "E-Commerce",
      "Section": "Section A",
      "Timings": "11:30 AM To 01:00 PM"
    },
    {
      "Campus": "Riphah International University",
      "Course": "Graphic Designing",
      "Section": "Section B",
      "Timings": "01:30 PM To 03:00 PM"
    },
    {
      "Campus": "Abdul Wali Khan University Mardan",
      "Course": "DM/GD",
      "Section": "Section A",
      "Timings": "10:00 AM To 11:30 AM"
    },
    {
      "Campus": "Abdul Wali Khan University Mardan",
      "Course": "DM/GD",
      "Section": "Section B",
      "Timings": "11:30 AM To 01:00 PM"
    },
    {
      "Campus": "Abdul Wali Khan University Mardan",
      "Course": "Digital Marketing",
      "Section": "Section C",
      "Timings": "01:30 PM To 03:00 PM"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timings in Ramadan",
          style:
              GoogleFonts.poppins(fontSize: 23.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 29.0,
          columns: const [
            DataColumn(
                label: Text("Campus",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal))),
            DataColumn(
                label: Text("Course",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal))),
            DataColumn(
                label: Text("Section",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal))),
            DataColumn(
                label: Text("Class Timings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal))),
          ],
          rows: timetable
              .map((row) => DataRow(cells: [
                    DataCell(Text(row["Campus"] ?? "")),
                    DataCell(Text(row["Course"] ?? "")),
                    DataCell(Text(row["Section"] ?? "")),
                    DataCell(Text(row["Timings"] ?? "")),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
