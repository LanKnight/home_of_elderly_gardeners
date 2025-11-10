import 'package:flutter/material.dart';

class QuestionAnswerPage extends StatefulWidget {
  const QuestionAnswerPage({super.key});

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<QuestionItem> _questions = [
    QuestionItem(
      id: 'q1',
      author: '张大爷',
      question: '我的番茄叶子发黄，是什么原因？',
      answers: [
        Answer(
          author: '李专家',
          content: '叶子发黄可能是缺氮肥，建议施一些氮肥，同时检查是否有病虫害。',
          date: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Answer(
          author: '王老师',
          content: '也可能是浇水过多导致根部缺氧，建议减少浇水频率，保持土壤适度湿润即可。',
          date: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
      date: DateTime.now().subtract(const Duration(days: 1)),
      isResolved: true,
    ),
    QuestionItem(
      id: 'q2',
      author: '李奶奶',
      question: '多肉植物多久浇一次水比较合适？',
      answers: [
        Answer(
          author: '园艺专家',
          content: '多肉植物一般7-10天浇一次水即可，遵循"干透浇透"的原则，避免积水。',
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
      date: DateTime.now().subtract(const Duration(hours: 6)),
      isResolved: false,
    ),
    QuestionItem(
      id: 'q3',
      author: '王师傅',
      question: '如何预防植物病虫害？',
      answers: [
        Answer(
          author: '张专家',
          content: '预防病虫害可以从以下几个方面入手：1.保持通风 2.定期检查 3.使用有机农药 4.及时清理病叶',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      date: DateTime.now().subtract(const Duration(days: 2)),
      isResolved: true,
    ),
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('提问与答疑'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // 提问区域
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '我要提问',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _questionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '请输入您的问题...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_questionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('请输入问题')),
                      );
                      return;
                    }
                    setState(() {
                      _questions.insert(
                        0,
                        QuestionItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          author: '我',
                          question: _questionController.text.trim(),
                          answers: [],
                          date: DateTime.now(),
                          isResolved: false,
                        ),
                      );
                      _questionController.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('问题已提交，等待回答')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('提交问题'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 问题列表
          Expanded(
            child: _questions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_outline, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          '还没有问题',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[200],
                            child: Text(
                              question.author[0],
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          title: Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    question.author,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(question.date),
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  if (question.isResolved) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '已解决',
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (question.answers.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${question.answers.length}个回答',
                                  style: TextStyle(fontSize: 12, color: Colors.blue),
                                ),
                              ],
                            ],
                          ),
                          children: [
                            if (question.answers.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 20, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '等待回答中...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...question.answers.map((answer) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.blue[200],
                                            child: Text(
                                              answer.author[0],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            answer.author,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            _formatDate(answer.date),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 32),
                                        child: Text(
                                          answer.content,
                                          style: const TextStyle(fontSize: 14, height: 1.5),
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                );
                              }),
                            // 回答输入框
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: '写下你的回答...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.send, color: Colors.green),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('回答功能开发中...')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}

class QuestionItem {
  final String id;
  final String author;
  final String question;
  final List<Answer> answers;
  final DateTime date;
  final bool isResolved;

  QuestionItem({
    required this.id,
    required this.author,
    required this.question,
    required this.answers,
    required this.date,
    required this.isResolved,
  });
}

class Answer {
  final String author;
  final String content;
  final DateTime date;

  Answer({
    required this.author,
    required this.content,
    required this.date,
  });
}

