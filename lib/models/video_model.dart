class VideoItem {
  final String id;
  final String title;
  final String source;
  final String? thumbnail;
  final bool isLive;

  VideoItem({
    required this.id,
    required this.title,
    required this.source,
    this.thumbnail,
    this.isLive = false,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'] ?? json['source'] ?? '',
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      thumbnail: json['thumbnail'],
      isLive: json['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'source': source,
      'thumbnail': thumbnail,
      'isLive': isLive,
    };
  }
}
