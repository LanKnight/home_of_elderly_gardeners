class Course {
  final String id;
  final String title;
  final String description;
  final String instructor; // 讲师
  final double price;
  final double? originalPrice; // 原价（用于显示折扣）
  final String? imageUrl;
  final String category; // 分类：'基础', '进阶', '专题', '直播'
  final int duration; // 课程时长（分钟）
  final int studentCount; // 学习人数
  final double rating; // 评分（0-5）
  final List<String> chapters; // 章节列表
  final bool isLive; // 是否为直播课程

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.category = '基础',
    this.duration = 0,
    this.studentCount = 0,
    this.rating = 0.0,
    this.chapters = const [],
    this.isLive = false,
  });

  // 是否有折扣
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  // 折扣百分比
  int get discountPercent {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).round();
  }

  // 格式化时长
  String get formattedDuration {
    if (duration < 60) {
      return '${duration}分钟';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return '${hours}小时';
    }
    return '${hours}小时${minutes}分钟';
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice'] != null ? (json['originalPrice'] as num).toDouble() : null,
      imageUrl: json['imageUrl'],
      category: json['category'] ?? '基础',
      duration: json['duration'] ?? 0,
      studentCount: json['studentCount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      chapters: json['chapters'] != null ? List<String>.from(json['chapters']) : [],
      isLive: json['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'category': category,
      'duration': duration,
      'studentCount': studentCount,
      'rating': rating,
      'chapters': chapters,
      'isLive': isLive,
    };
  }
}

