import 'package:flutter/material.dart';
import '../../services/ai_chat_service.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final DeepSeekService _aiService = DeepSeekService();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  /// 测试与 AI 服务的连接
  Future<void> _testConnection() async {
    setState(() {
      _isConnected = false;
      _messages.add(ChatMessage(
        text: '正在连接到 AI 园艺助手...',
        isUser: false,
        time: DateTime.now(),
      ));
    });

    final result = await _aiService.testConnection();
    setState(() {
      _isConnected = result['success'];
      if (result['success']) {
        _messages.add(ChatMessage(
          text: '您好！我是您的 AI 园艺助手，有什么我可以帮您的吗？',
          isUser: false,
          time: DateTime.now(),
        ));
      } else {
        _messages.add(ChatMessage(
          text: '连接失败：${result['message']}',
          isUser: false,
          time: DateTime.now(),
        ));
      }
    });
    
    // 滚动到底部
    _scrollToBottom();
  }

  /// 发送消息
  void _sendMessage() async {
    if (_textController.text.trim().isEmpty || _isLoading || !_isConnected) return;

    final message = _textController.text;
    final time = DateTime.now();
    
    // 添加用户消息到列表
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true, time: time));
      _isLoading = true;
      _textController.clear();
    });

    try {
      // 滚动到底部
      _scrollToBottom();
      
      // 调用 AI 服务获取回复
      final response = await _aiService.askQuestion(message);
      
      // 添加 AI 回复到列表
      setState(() {
        _messages.add(ChatMessage(
          text: response, 
          isUser: false, 
          time: DateTime.now()
        ));
        _isLoading = false;
      });
      
      // 滚动到底部
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: '发生未知错误，请稍后再试。错误信息：$e',
          isUser: false,
          time: DateTime.now(),
        ));
        _isLoading = false;
      });
      
      // 滚动到底部
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 园艺助手'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testConnection,
            tooltip: '重新连接',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return _messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '请输入您的园艺问题...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: _isConnected,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isConnected ? _sendMessage : null,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser 
                ? Theme.of(context).primaryColor 
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: isUser ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
