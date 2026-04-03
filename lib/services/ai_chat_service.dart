import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

/// DeepSeek AI 服务 - 专门用于园艺咨询答疑
class DeepSeekService {
  static final DeepSeekService _instance = DeepSeekService._internal();
  factory DeepSeekService() => _instance;
  DeepSeekService._internal();

  // DeepSeek API 配置
  static const String _apiKey = 'sk-609b0e84b41849b58d8bded03b04f891';
  static const String _baseUrl = 'https://api.deepseek.com';
  
  /// 检查是否已设置 API Key
  bool get hasApiKey => true; // API Key 已内置，始终可用

  /// 发送问题到 DeepSeek AI 获取答案
  Future<String> askQuestion(String question) async {
    try {
      // 构建系统提示词，让 AI 专注于园艺领域
      final systemPrompt = '''你是一位专业的园艺顾问，专门为老年园艺爱好者提供耐心、详细、易懂的园艺知识解答。
你的回答应该：
1. 简洁明了，避免过于专业的术语
2. 分步骤说明，便于操作
3. 关注安全性和实用性
4. 体现对老年人的关怀和耐心

请回答以下园艺相关问题：''';

      final requestBody = {
        'model': 'deepseek-chat',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': question},
        ],
        'temperature': 0.7,
        'max_tokens': 1000,
      };

      print('[DeepSeek] 开始请求 API...');
      print('[DeepSeek] 请求URL: $_baseUrl/v1/chat/completions');
      print('[DeepSeek] 请求体：${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print('[DeepSeek] 请求超时 (30 秒)');
          throw TimeoutException('AI 响应超时，请检查网络连接后重试');
        },
      );

      print('[DeepSeek] 响应状态码：${response.statusCode}');
      print('[DeepSeek] 响应头：${response.headers}');
      
      // 显式使用 UTF-8 解码响应体（遵循编码规范）
      String responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      print('[DeepSeek] 响应体：$responseBody');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final choices = data['choices'] as List?;
        
        if (choices != null && choices.isNotEmpty) {
          final message = choices[0]['message'];
          if (message != null && message['content'] != null) {
            final content = message['content'] as String;
            print('[DeepSeek] AI 回答成功：$content');
            return content;
          }
        }
        
        print('[DeepSeek] 响应格式异常，无有效内容');
        return '抱歉，我没有理解您的问题。';
      } else if (response.statusCode == 401) {
        print('[DeepSeek] 认证失败 (401)');
        return 'API 认证失败，请检查 API Key 是否正确。';
      } else if (response.statusCode == 429) {
        print('[DeepSeek] 请求过于频繁 (429)');
        return '请求过于频繁，请稍后再试。';
      } else if (response.statusCode >= 500) {
        print('[DeepSeek] 服务器错误 (${response.statusCode})');
        return 'AI 服务暂时不可用，请稍后再试。';
      } else {
        print('[DeepSeek] 未知错误 (${response.statusCode})');
        return '抱歉，我现在无法回答您的问题，请稍后再试。状态码：${response.statusCode}';
      }
    } on SocketException catch (e) {
      print('[DeepSeek] 网络连接失败：$e');
      return '网络连接失败，请检查您的网络设置。';
    } on TimeoutException catch (e) {
      print('[DeepSeek] 请求超时：$e');
      return '请求超时，请检查网络连接后重试。';
    } on FormatException catch (e) {
      print('[DeepSeek] 数据格式错误：$e');
      return '响应数据格式错误，请稍后再试。';
    } catch (e, stackTrace) {
      print('[DeepSeek] 未知异常：$e');
      print('[DeepSeek] 堆栈跟踪：$stackTrace');
      return '网络连接出现问题，请检查您的网络设置。错误详情：$e';
    }
  }

  /// 测试 DeepSeek API 连接
  Future<Map<String, dynamic>> testConnection() async {
    try {
      print('[DeepSeek Test] 开始测试连接...');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
          HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'user', 'content': '你好'},
          ],
          'max_tokens': 10,
        }),
      ).timeout(Duration(seconds: 10));

      print('[DeepSeek Test] 响应状态码：${response.statusCode}');
      String responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      print('[DeepSeek Test] 响应体：$responseBody');

      if (response.statusCode == 200) {
        print('[DeepSeek Test] 连接成功');
        return {'success': true, 'message': '连接成功'};
      } else if (response.statusCode == 401) {
        print('[DeepSeek Test] API Key 无效');
        return {'success': false, 'message': 'API Key 无效'};
      } else {
        print('[DeepSeek Test] 连接失败，状态码：${response.statusCode}');
        return {'success': false, 'message': '连接失败，状态码：${response.statusCode}'};
      }
    } on SocketException catch (e) {
      print('[DeepSeek Test] 网络连接失败：$e');
      return {'success': false, 'message': '网络连接失败'};
    } on TimeoutException catch (e) {
      print('[DeepSeek Test] 请求超时：$e');
      return {'success': false, 'message': '请求超时'};
    } catch (e) {
      print('[DeepSeek Test] 测试异常：$e');
      return {'success': false, 'message': '测试失败：$e'};
    }
  }
}