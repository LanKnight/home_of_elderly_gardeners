import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../models/video_model.dart';
import '../video/video_player_page.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    final watchHistory = videoProvider.watchHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('观看历史'),
        backgroundColor: Colors.green,
        actions: [
          if (watchHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: '清空历史',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认清空'),
                    content: const Text('确定要清空所有观看历史吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          videoProvider.clearWatchHistory();
                          Navigator.pop(context);
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: watchHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '暂无观看历史',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '你观看的视频记录会出现在这里',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: watchHistory.length,
              itemBuilder: (context, index) {
                final video = watchHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerPage(video: video),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // 视频缩略图
                          Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                video.thumbnail != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          video.thumbnail!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.play_circle_outline,
                                                size: 40, color: Colors.grey);
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.play_circle_outline, size: 40, color: Colors.grey),
                                // 播放图标
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    size: 40,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 视频信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video.title.isNotEmpty ? video.title : '无标题视频',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (video.isLive)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          '直播',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    if (video.isLive) const SizedBox(width: 8),
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatTime(index),
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // 删除按钮
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              videoProvider.removeFromWatchHistory(video.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(int index) {
    if (index == 0) return '刚刚';
    if (index == 1) return '1小时前';
    if (index < 5) return '${index}小时前';
    if (index < 10) return '昨天';
    return '${index}天前';
  }
}

