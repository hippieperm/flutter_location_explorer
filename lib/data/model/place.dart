class Place {
  final String title;
  final String link;
  final String category;
  final String description;
  final String telephone;
  final String address;
  final String roadAddress;
  final double mapx;
  final double mapy;
  final String imageUrl;

  Place({
    required this.title,
    required this.link,
    required this.category,
    required this.description,
    required this.telephone,
    required this.address,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
    this.imageUrl = '',
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      telephone: json['telephone'] ?? '',
      address: json['address'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      mapx: double.tryParse(json['mapx'] ?? '0') ?? 0,
      mapy: double.tryParse(json['mapy'] ?? '0') ?? 0,
    );
  }
}

class PlaceResponse {
  final int total;
  final int start;
  final int display;
  final List<Place> items;

  PlaceResponse({
    required this.total,
    required this.start,
    required this.display,
    required this.items,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    List<Place> items = [];
    if (json['items'] != null) {
      items = List<Place>.from(
        json['items'].map((item) => Place.fromJson(item)),
      );
    }

    return PlaceResponse(
      total: json['total'] ?? 0,
      start: json['start'] ?? 0,
      display: json['display'] ?? 0,
      items: items,
    );
  }
}
