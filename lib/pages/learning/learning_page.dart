import 'package:flutter/material.dart';
import '../common/search_page.dart';
import '../../models/course_model.dart';
import 'course_list_page.dart';
import 'course_detail_page.dart';
import 'consultation_page.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习中心'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 快捷入口
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.school),
                    label: const Text('全部课程'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CourseListPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('咨询'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ConsultationPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // 推荐课程
          Expanded(
            child: CourseListPage(showRecommendedOnly: true),
          ),
        ],
      ),
    );
  }
}

