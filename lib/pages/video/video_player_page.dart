import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../models/video_model.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoItem video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    // Do not initialize video immediately. Show thumbnail first if available.
  }

  Future<void> _startPlayback() async {
    if (_chewieController != null || _isInitializing) return;
    setState(() {
      _isInitializing = true;
    });

    try {
      _videoController = VideoPlayerController.network(widget.video.source);
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
      );
      setState(() {});
    } catch (e) {
      // failed to initialize; show helpful error for platforms where the
      // video_player plugin is not implemented (e.g. missing desktop backend)
      String message = '播放失败：$e';
      if (e is UnimplementedError) {
        message =
            '当前平台未实现视频播放支持 (UnimplementedError)。\n如果你在 Linux 上运行，请安装 GStreamer 运行时并确保使用支持的目标（Android/iOS 或已启用的桌面插件）。';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video.title.isNotEmpty ? widget.video.title : '播放')),
      body: Center(
        child: _chewieController != null && _videoController != null && _videoController!.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : _buildThumbnailOrStart(),
      ),
    );
  }

  Widget _buildThumbnailOrStart() {
    final thumb = widget.video.thumbnail;
    if (thumb != null && thumb.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              thumb,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (c, e, s) => Container(color: Colors.black12),
            ),
          ),
          if (_isInitializing) const CircularProgressIndicator(),
          if (!_isInitializing)
            GestureDetector(
              onTap: _startPlayback,
              child: Container(
                decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.play_arrow, size: 48, color: Colors.white),
              ),
            ),
        ],
      );
    }

    // No thumbnail: provide a start button or progress indicator
    if (_isInitializing) return const CircularProgressIndicator();

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      onPressed: _startPlayback,
      icon: const Icon(Icons.play_arrow),
      label: const Text('播放视频'),
    );
  }
}
