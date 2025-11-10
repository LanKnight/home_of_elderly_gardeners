import 'package:flutter/material.dart';
import '../../models/video_model.dart';
import '../../models/product_model.dart';
import '../../models/course_model.dart';
import '../video/video_player_page.dart';
import '../shopping/product_detail_page.dart';
import '../learning/course_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  List<SearchResult> _results = [];
  bool _isSearching = false;

  // 示例数据
  final List<VideoItem> _allVideos = [
    VideoItem(id: 'v1', title: '园艺入门', source: ''),
    VideoItem(id: 'v2', title: '多肉植物养护', source: ''),
    VideoItem(id: 'v3', title: '番茄种植技巧', source: ''),
  ];

  final List<Product> _allProducts = [
    Product(id: 'p1', title: '园艺剪刀', description: '专业园艺工具', price: 45.0),
    Product(id: 'p2', title: '番茄种子', description: '优质种子', price: 12.5),
    Product(id: 'p3', title: '有机肥料', description: '天然肥料', price: 28.0),
  ];

  final List<Course> _allCourses = [
    Course(
      id: 'c1',
      title: '园艺入门基础',
      description: '适合零基础学员',
      instructor: '张老师',
      price: 99.0,
    ),
    Course(
      id: 'c2',
      title: '盆栽植物养护',
      description: '深入讲解盆栽技巧',
      instructor: '李园丁',
      price: 199.0,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _doSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入搜索关键词')),
      );
      return;
    }

    setState(() {
      _searchQuery = query;
      _isSearching = true;
      _results = [];
    });

    // 模拟搜索延迟
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = <SearchResult>[];

      // 搜索视频
      for (var video in _allVideos) {
        if (video.title.contains(query)) {
          results.add(SearchResult(
            type: SearchResultType.video,
            title: video.title,
            subtitle: '视频',
            data: video,
          ));
        }
      }

      // 搜索商品
      for (var product in _allProducts) {
        if (product.title.contains(query) || product.description.contains(query)) {
          results.add(SearchResult(
            type: SearchResultType.product,
            title: product.title,
            subtitle: '商品 - ¥${product.price}',
            data: product,
          ));
        }
      }

      // 搜索课程
      for (var course in _allCourses) {
        if (course.title.contains(query) || course.description.contains(query)) {
          results.add(SearchResult(
            type: SearchResultType.course,
            title: course.title,
            subtitle: '课程 - ${course.instructor}',
            data: course,
          ));
        }
      }

      setState(() {
        _results = results;
        _isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '搜索视频、商品、课程...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: (v) => _doSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: _doSearch,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          // 热门搜索
          if (_searchQuery.isEmpty && _results.isEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '热门搜索',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        '园艺入门',
                        '多肉植物',
                        '番茄种植',
                        '盆栽养护',
                        '有机肥料',
                      ].map((keyword) {
                        return ActionChip(
                          label: Text(keyword),
                          onPressed: () {
                            _controller.text = keyword;
                            _doSearch();
                          },
                          backgroundColor: Colors.green[100],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          // 搜索结果
          else if (_isSearching)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_results.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      '没有找到相关结果',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '试试其他关键词吧',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  IconData icon;
                  Color iconColor;

                  switch (result.type) {
                    case SearchResultType.video:
                      icon = Icons.video_library;
                      iconColor = Colors.red;
                      break;
                    case SearchResultType.product:
                      icon = Icons.shopping_bag;
                      iconColor = Colors.blue;
                      break;
                    case SearchResultType.course:
                      icon = Icons.school;
                      iconColor = Colors.green;
                      break;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: Icon(icon, color: iconColor),
                      title: Text(result.title),
                      subtitle: Text(result.subtitle),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        switch (result.type) {
                          case SearchResultType.video:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerPage(video: result.data as VideoItem),
                              ),
                            );
                            break;
                          case SearchResultType.product:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(product: result.data as Product),
                              ),
                            );
                            break;
                          case SearchResultType.course:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(course: result.data as Course),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

enum SearchResultType { video, product, course }

class SearchResult {
  final SearchResultType type;
  final String title;
  final String subtitle;
  final dynamic data;

  SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.data,
  });
}

