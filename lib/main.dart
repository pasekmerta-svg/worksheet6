import 'package:flutter/material.dart';

const String studentName = 'Made Pasek Merta Sujati';
const String studentId = '2415051096';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worksheet 6 - State Management',
      home: Scaffold(
        appBar: AppBar(
          title: Text('$studentId - $studentName'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: LocalStateExample(),
        ),
      ),
    );
  }
}

class LocalStateExample extends StatefulWidget {
  const LocalStateExample({super.key});

  @override
  State<LocalStateExample> createState() => _LocalStateExampleState();
}

class _LocalStateExampleState extends State<LocalStateExample> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 60,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        const SizedBox(height: 10),
        Text(
          isFavorite ? 'Disukai (Local State Active)' : 'Belum Disukai',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}