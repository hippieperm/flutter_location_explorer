import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String category;
  final String roadAddress;

  const ListItem({
    super.key,
    required this.title,
    required this.category,
    required this.roadAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 234, 230, 230).withAlpha(110),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(category, style: TextStyle(fontSize: 14)),
                  Text(roadAddress, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
