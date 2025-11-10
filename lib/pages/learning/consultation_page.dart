import 'package:flutter/material.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<ConsultationItem> _consultations = [
    ConsultationItem(
      question: '如何给多肉植物浇水？',
      answer: '多肉植物浇水要遵循"干透浇透"的原则，一般7-10天浇一次水，避免积水。',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ConsultationItem(
      question: '盆栽植物叶子发黄怎么办？',
      answer: '叶子发黄可能是浇水过多、缺少养分或光照不足。建议检查土壤湿度，适当施肥，增加光照。',
      date: DateTime.now().subtract(const Duration(days: 5)),
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
        title: const Text('咨询'),
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
                      _consultations.insert(
                        0,
                        ConsultationItem(
                          question: _questionController.text.trim(),
                          answer: null, // 待回答
                          date: DateTime.now(),
                        ),
                      );
                      _questionController.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('问题已提交，等待专家回答')),
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
          // 常见问题
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '常见问题',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildCommonQuestion('如何选择适合的土壤？'),
                _buildCommonQuestion('植物多久施肥一次？'),
                _buildCommonQuestion('如何预防病虫害？'),
                _buildCommonQuestion('室内植物需要多少光照？'),
              ],
            ),
          ),
          const Divider(height: 1),
          // 咨询记录
          Expanded(
            child: _consultations.isEmpty
                ? const Center(
                    child: Text('暂无咨询记录'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _consultations.length,
                    itemBuilder: (context, index) {
                      final item = _consultations[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.help_outline, size: 20, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.question,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (item.answer != null) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 20, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.answer!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 20, color: Colors.orange),
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
                              ],
                              const SizedBox(height: 8),
                              Text(
                                _formatDate(item.date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonQuestion(String question) {
    return InkWell(
      onTap: () {
        _questionController.text = question;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
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

class ConsultationItem {
  final String question;
  final String? answer;
  final DateTime date;

  ConsultationItem({
    required this.question,
    this.answer,
    required this.date,
  });
}

