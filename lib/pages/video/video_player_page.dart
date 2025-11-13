import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/video_model.dart';
import '../../providers/video_provider.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoItem video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isDesktop = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // 检测是否为桌面平台
    _isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;
    
    // 记录观看历史
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.addToWatchHistory(widget.video);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video.title.isNotEmpty ? widget.video.title : '播放')),
      body: _buildDesktopVideoPlaceholder(),
    );
  }

  Widget _buildDesktopVideoPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 视频占位符
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.video_library,
                  size: 50,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                const Text(
                  '视频播放区域',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.video.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '当前平台不支持视频播放\n请使用移动设备以获得完整功能',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}