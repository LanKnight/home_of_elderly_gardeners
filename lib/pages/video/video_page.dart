// lib/pages/video_page.dart
import 'package:flutter/material.dart';
import '../common/search_page.dart';
import '../../services/api_service.dart';
import '../../models/video_model.dart';
import 'video_player_page.dart';

// Use AppConstants.scraperBaseUrl by default. For Android emulator change to
// http://10.0.2.2:8000 when creating ApiService.
final ApiService _apiService = ApiService();

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('园艺视频'),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: '短视频'),
              Tab(text: '直播教学'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VideoListPage(),
            LiveTeachingPage(),
          ],
        ),
      ),
    );
  }
}

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  late Future<List<VideoItem>> _videosFuture;

  @override
  void initState() {
    super.initState();
    // Load featured videos (no scraper). Use local/mock list so app doesn't rely on external scraper.
  _videosFuture = _apiService.fetchFeaturedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
        setState(() {
          _videosFuture = _apiService.fetchFeaturedVideos();
        });
        await _videosFuture;
      },
      child: FutureBuilder<List<VideoItem>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return ListView(
              children: [Center(child: Text('加载失败: ${snapshot.error}'))],
            );
          }
          final videos = snapshot.data ?? [];
          if (videos.isEmpty) {
            return ListView(
              children: const [Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('未找到视频')))],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final v = videos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VideoPlayerPage(video: v)),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Thumbnail with play overlay
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          v.thumbnail != null
                              ? Image.network(
                                  v.thumbnail!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 180,
                                  color: Colors.green[100],
                                  child: const Icon(Icons.play_arrow, size: 60, color: Colors.white70),
                                ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.title.isNotEmpty ? v.title : '无标题视频',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 6),
                                  // show a small placeholder subtitle (e.g., source shortened) removed per request
                                  const Text('', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            if (v.isLive) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                                child: const Text('直播', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LiveTeachingPage extends StatelessWidget {
  const LiveTeachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildLiveCard('张老师的一对一园艺教学', '在线', Colors.red),
        _buildLiveCard('李园丁的盆栽技巧', '离线', Colors.grey),
        _buildLiveCard('王师傅的花卉养护', '离线', Colors.grey),
      ],
    );
  }

  Widget _buildLiveCard(String title, String status, Color color) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person),
        ),
        title: Text(title),
        subtitle: Text(status),
        trailing: Chip(
          label: Text(
            status,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: color,
        ),
        onTap: () {
          // 进入直播
        },
      ),
    );
  }
}