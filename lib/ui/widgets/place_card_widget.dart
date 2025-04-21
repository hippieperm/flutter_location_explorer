import 'package:flutter/material.dart';

import '../../data/model/place.dart';
import '../../util/url_util.dart';
import '../widgets/info_dialog.dart';

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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
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
              place.cleanTitle,
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

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (place.description.isNotEmpty) ...[
            Text(
              place.description.replaceAll('<b>', '').replaceAll('</b>', ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.grey[600], size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  place.roadAddress.isNotEmpty
                      ? place.roadAddress
                      : place.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
              ),
            ],
          ),

          if (place.telephone.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  place.telephone,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(context, Icons.public, '상세정보', () {
            if (place.link.isEmpty) {
              _showNoDetailsDialog(context);
            } else {
              UrlUtil.openUrl(place.link);
            }
          }),
          _buildActionButton(
            context,
            Icons.map,
            '지도보기',
            () => UrlUtil.openMapWithPlace(place),
          ),
          if (place.telephone.isNotEmpty)
            _buildActionButton(
              context,
              Icons.call,
              '전화걸기',
              () => UrlUtil.callPhone(place.telephone),
            ),
        ],
      ),
    );
  }

  void _openPlaceDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder:
                (_, controller) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    controller: controller,
                    children: [
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        place.cleanTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (place.category.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                place.category,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (place.description.isNotEmpty) ...[
                        Text(
                          place.description
                              .replaceAll('<b>', '')
                              .replaceAll('</b>', ''),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildDetailItem(
                        Icons.location_on,
                        '도로명주소',
                        place.roadAddress,
                      ),
                      _buildDetailItem(Icons.home, '지번주소', place.address),
                      if (place.telephone.isNotEmpty)
                        _buildDetailItem(Icons.phone, '전화번호', place.telephone),
                      const SizedBox(height: 24),
                      _buildFullWidthButton(
                        context,
                        '웹페이지 방문하기',
                        Icons.public,
                        () {
                          if (place.link.isEmpty) {
                            Navigator.pop(context);
                            _showNoDetailsDialog(context);
                          } else {
                            UrlUtil.openUrl(place.link);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFullWidthButton(
                        context,
                        '지도에서 보기',
                        Icons.map,
                        () => UrlUtil.openMap(
                          place.mapy,
                          place.mapx,
                          place.title,
                        ),
                      ),
                      if (place.telephone.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildFullWidthButton(
                          context,
                          '전화 걸기',
                          Icons.call,
                          () => UrlUtil.callPhone(place.telephone),
                        ),
                      ],
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Colors.blue[800], fontSize: 12),
            ),
          ],
        ),
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

  void _showNoDetailsDialog(BuildContext context) {
    InfoDialog.show(
      context,
      title: '상세 정보 없음',
      message: '${place.cleanTitle}의 상세 정보가 제공되지 않습니다.\n다른 방법으로 정보를 확인해보세요.',
      icon: Icons.info_outline,
      iconColor: Colors.orangeAccent,
      customAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () => UrlUtil.openMapWithPlace(place),
              icon: const Icon(Icons.map),
              label: const Text('지도에서 보기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
