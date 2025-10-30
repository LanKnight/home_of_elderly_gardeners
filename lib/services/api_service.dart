import 'package:dio/dio.dart';
import '../models/video_model.dart';
import '../utils/constants.dart';

class ApiService {
	final Dio _dio;
	final String baseUrl;

	/// Create ApiService with optional baseUrl (scraper backend). If not provided,
	/// uses `AppConstants.scraperBaseUrl`.
	ApiService({String? baseUrl, Dio? dio})
			: baseUrl = baseUrl ?? AppConstants.scraperBaseUrl,
				_dio = dio ?? Dio();

	/// Fetch videos from the scraper backend.
	/// The scraper endpoint is expected to be: GET {baseUrl}/videos?url=...
	Future<List<VideoItem>> fetchVideosFromScraper(String pageUrl) async {
		try {
			final uri = Uri.parse(baseUrl + '/videos').replace(queryParameters: {'url': pageUrl});
			final response = await _dio.getUri(uri);
			if (response.statusCode == 200) {
				final data = response.data;
				final list = (data['videos'] as List<dynamic>?) ?? [];
				return list.map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e))).toList();
			}
			return _mockVideos();
		} catch (e) {
			// On any error, return a small mock list so UI still works offline
			return _mockVideos();
		}
	}

	/// Return a list of featured / recommended videos.
	/// For now this uses a local mock list so the app doesn't rely on the scraper.
	Future<List<VideoItem>> fetchFeaturedVideos() async {
		// In future this could call a real backend endpoint like GET {baseUrl}/featured
		// For now return the same mock list used on errors.
		await Future.delayed(const Duration(milliseconds: 300));
		return _mockVideos();
	}

	List<VideoItem> _mockVideos() {
		return List.generate(
			5,
			(i) => VideoItem(
				id: 'mock_$i',
				title: '示例视频 ${i + 1}',
				source: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
				thumbnail: null,
			),
		);
	}
}

