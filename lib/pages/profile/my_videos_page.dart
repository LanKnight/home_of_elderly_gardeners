import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../models/video_model.dart';
import '../video/video_player_page.dart';

class MyVideosPage extends StatelessWidget {
  const MyVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    final myVideos = videoProvider.myVideos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的发布'),
        backgroundColor: Colors.green,
        actions: [
          if (myVideos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: '清空',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认清空'),
                    content: const Text('确定要清空所有发布的视频吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          videoProvider.clearMyVideos();
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
      body: myVideos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '暂时没有发布的视频',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '你发布的视频将显示在这里',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: 跳转到发布视频页面
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('发布视频功能开发中...')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('发布视频'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: myVideos.length,
              itemBuilder: (context, index) {
                final video = myVideos[index];
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
                            child: video.thumbnail != null
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
                                    Icon(Icons.visibility, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '0次观看',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // 删除按钮
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('确认删除'),
                                  content: const Text('确定要删除这个视频吗？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('取消'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        videoProvider.removeMyVideo(video.id);
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
                    ),
                  ),
                );
              },
            ),
    );
  }
}

