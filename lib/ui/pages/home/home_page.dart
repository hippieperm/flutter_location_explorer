import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue[700]),
      body: SafeArea(
        bottom: false,
        child: Stack(children: [_buildBackground()]),
      ),
    );
  }
}

Widget _buildBackground() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[700]!, Colors.blue[500]!, Colors.blue[300]!],
      ),
    ),
  );
}
