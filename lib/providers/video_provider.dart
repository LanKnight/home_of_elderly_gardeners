import 'package:flutter/material.dart';
import '../models/video_model.dart';

class VideoProvider with ChangeNotifier {
  final List<VideoItem> _watchHistory = [];
  final List<VideoItem> _myVideos = [];

  List<VideoItem> get watchHistory => List.unmodifiable(_watchHistory);
  List<VideoItem> get myVideos => List.unmodifiable(_myVideos);

  // 添加观看历史
  void addToWatchHistory(VideoItem video) {
    // 如果已存在，先移除
    _watchHistory.removeWhere((v) => v.id == video.id);
    // 添加到最前面
    _watchHistory.insert(0, video);
    // 限制最多保存100条
    if (_watchHistory.length > 100) {
      _watchHistory.removeRange(100, _watchHistory.length);
    }
    notifyListeners();
  }

  // 清除观看历史
  void clearWatchHistory() {
    _watchHistory.clear();
    notifyListeners();
  }

  // 添加我的视频
  void addMyVideo(VideoItem video) {
    _myVideos.insert(0, video);
    notifyListeners();
  }

  // 删除我的视频
  void removeMyVideo(String videoId) {
    _myVideos.removeWhere((v) => v.id == videoId);
    notifyListeners();
  }

  // 清除我的视频
  void clearMyVideos() {
    _myVideos.clear();
    notifyListeners();
  }

  // 从观看历史中移除指定视频
  void removeFromWatchHistory(String videoId) {
    _watchHistory.removeWhere((v) => v.id == videoId);
    notifyListeners();
  }
}

