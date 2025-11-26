import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class AiChatService {
  static final AiChatService _instance = AiChatService._internal();
  factory AiChatService() => _instance;
  AiChatService._internal();

  // Coze API配置
  static const String _cozeApiUrl = 'https://api.coze.cn';
  static const String _apiKey = 'pat_c661cb6aee7103834d85648e1efd22192aae91c72e04155512bfcbd129d4040e';
  static const String _botId = '7576856621687504896'; // 您提供的Bot ID
  static const String _userId = 'user_123456'; // 用户标识

  /// 获取Bot ID
  String get botId => _botId;

  /// 与Coze智能体进行对话
  Future<String> chatWithBot(String message, {String? conversationId}) async {
    if (_botId.isEmpty) {
      return 'Bot ID未设置，请先在Coze平台创建Bot并设置其ID。';
    }

    try {
      final requestBody = {
        'bot_id': _botId,
        'user_id': _userId,
        'query': message,
        'conversation_id': conversationId ?? '',
        'stream': false,
      };

      final response = await http.post(
        Uri.parse('$_cozeApiUrl/v3/chat'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      );

      // 输出调试信息
      print('请求URL: $_cozeApiUrl/v3/chat');
      print('请求头: {Content-Type: application/json, Authorization: Bearer *****}');
      print('请求体: $requestBody');
      print('响应状态码: ${response.statusCode}');
      print('响应体: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 0 && data['msg'] == 'Success') {
          // 获取AI回复消息
          final messages = data['data']?['messages'] as List?;
          if (messages != null && messages.isNotEmpty) {
            // 查找assistant角色的消息
            for (var msg in messages.reversed) {
              if (msg['role'] == 'assistant' && msg['content_type'] == 'text') {
                return msg['content'];
              }
            }
          }
          return '抱歉，我没有理解您的问题。';
        } else if (data['code'] == 4011 || data['code'] == 4101) {
          return 'API认证失败，请检查API密钥是否正确。';
        } else if (data['code'] == 4001) {
          return 'Bot ID无效，请检查Bot ID是否正确。';
        }
        return '抱歉，我现在无法回答您的问题，请稍后再试。错误信息: ${data['msg']} (错误代码: ${data['code']})';
      } else if (response.statusCode == 401) {
        return 'API认证失败，请检查API密钥是否正确。';
      } else if (response.statusCode == 404) {
        return '请求的资源未找到，请检查Bot ID是否正确。';
      } else {
        return '抱歉，我现在无法回答您的问题，请稍后再试。状态码: ${response.statusCode}';
      }
    } catch (e, stackTrace) {
      print('发生异常: $e');
      print('堆栈跟踪: $stackTrace');
      if (e is SocketException) {
        return '网络连接失败，请检查您的网络设置。';
      } else if (e is FormatException) {
        return '响应数据格式错误，请稍后再试。';
      }
      return '网络连接出现问题，请检查您的网络设置。错误详情: $e';
    }
  }

  /// 测试API连接
  Future<Map<String, dynamic>> testConnection() async {
    try {
      // 使用一个简单的API端点进行测试
      final response = await http.post(
        Uri.parse('$_cozeApiUrl/v3/chat'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'bot_id': _botId,
          'user_id': _userId,
          'query': 'Hello',
          'stream': false,
        }),
      );
      
      print('测试连接状态码: ${response.statusCode}');
      print('测试连接响应体: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 0) {
          return {'success': true, 'message': '连接成功'};
        } else if (data['code'] == 4011 || data['code'] == 4101) {
          return {'success': false, 'message': 'API认证失败，请检查API密钥是否正确。'};
        } else if (data['code'] == 4001) {
          return {'success': false, 'message': 'Bot ID无效，请检查Bot ID是否正确。'};
        } else {
          return {'success': true, 'message': '连接成功'};
        }
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'API认证失败，请检查API密钥是否正确。'};
      } else {
        // 即使返回400错误，只要能连接上API就说明网络是通的
        if (response.statusCode >= 400 && response.statusCode < 500) {
          return {'success': true, 'message': '连接成功'};
        }
        return {'success': false, 'message': '连接失败，状态码: ${response.statusCode}'};
      }
    } catch (e, stackTrace) {
      print('测试连接异常: $e');
      print('测试连接堆栈跟踪: $stackTrace');
      if (e is SocketException) {
        return {'success': false, 'message': '网络连接失败，请检查您的网络设置。'};
      }
      return {'success': false, 'message': '网络连接出现问题，请检查您的网络设置。'};
    }
  }
}