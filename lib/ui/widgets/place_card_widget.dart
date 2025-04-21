import 'package:flutter/material.dart';
import '../../data/model/place.dart';

class PlaceCardWidget extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;

  const PlaceCardWidget({super.key, required this.place, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _openPlaceDetail(context),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildBody(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              place.title.replaceAll('<b>', '').replaceAll('</b>', ''),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (place.category.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                place.category,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 0),
      ),
    );
  }
}
