import 'package:flutter/material.dart';
import '../../models/course_model.dart';
import 'course_detail_page.dart';

class CourseListPage extends StatefulWidget {
  final bool showRecommendedOnly;

  const CourseListPage({super.key, this.showRecommendedOnly = false});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  String _selectedCategory = '全部';

  final List<String> _categories = ['全部', '基础', '进阶', '专题', '直播'];

  // 示例课程数据
  final List<Course> _allCourses = [
    Course(
      id: 'c1',
      title: '园艺入门基础',
      description: '适合零基础学员，从土壤、浇水、施肥等基础知识开始学习',
      instructor: '张老师',
      price: 99.00,
      originalPrice: 149.00,
      category: '基础',
      duration: 180,
      studentCount: 1250,
      rating: 4.8,
      chapters: ['第一章：园艺基础知识', '第二章：土壤与肥料', '第三章：浇水技巧', '第四章：常见问题'],
    ),
    Course(
      id: 'c2',
      title: '盆栽植物养护技巧',
      description: '深入讲解盆栽植物的日常养护、修剪、换盆等高级技巧',
      instructor: '李园丁',
      price: 199.00,
      category: '进阶',
      duration: 240,
      studentCount: 856,
      rating: 4.9,
      chapters: ['第一章：盆栽选择', '第二章：日常养护', '第三章：修剪技巧', '第四章：换盆方法'],
    ),
    Course(
      id: 'c3',
      title: '多肉植物专题',
      description: '专门针对多肉植物的种植、繁殖、养护进行详细讲解',
      instructor: '王师傅',
      price: 149.00,
      category: '专题',
      duration: 120,
      studentCount: 2100,
      rating: 4.7,
      chapters: ['第一章：多肉植物介绍', '第二章：种植方法', '第三章：繁殖技巧', '第四章：常见问题'],
    ),
    Course(
      id: 'c4',
      title: '花卉种植直播课',
      description: '每周一次的直播课程，实时解答学员问题，互动学习',
      instructor: '赵老师',
      price: 299.00,
      category: '直播',
      duration: 60,
      studentCount: 500,
      rating: 4.9,
      isLive: true,
      chapters: ['每周直播课程'],
    ),
    Course(
      id: 'c5',
      title: '有机蔬菜种植',
      description: '学习如何在家中种植有机蔬菜，健康又环保',
      instructor: '张老师',
      price: 179.00,
      category: '专题',
      duration: 200,
      studentCount: 980,
      rating: 4.6,
      chapters: ['第一章：蔬菜选择', '第二章：种植方法', '第三章：有机肥料', '第四章：收获技巧'],
    ),
    Course(
      id: 'c6',
      title: '园艺工具使用指南',
      description: '详细介绍各种园艺工具的使用方法和保养技巧',
      instructor: '李园丁',
      price: 79.00,
      category: '基础',
      duration: 90,
      studentCount: 1500,
      rating: 4.5,
      chapters: ['第一章：工具介绍', '第二章：使用方法', '第三章：保养技巧'],
    ),
  ];

  List<Course> get _filteredCourses {
    var filtered = _allCourses;

    // 推荐课程筛选
    if (widget.showRecommendedOnly) {
      filtered = filtered.where((c) => c.rating >= 4.7).toList();
    }

    // 分类筛选
    if (_selectedCategory != '全部') {
      filtered = filtered.where((c) => c.category == _selectedCategory).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _filteredCourses;

    return Column(
      children: [
        // 分类筛选（仅在非推荐模式下显示）
        if (!widget.showRecommendedOnly)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: Colors.green[300],
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        // 课程列表
        Expanded(
          child: filteredCourses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        widget.showRecommendedOnly ? '暂无推荐课程' : '没有找到课程',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailPage(course: course),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 课程图片
                              Container(
                                width: 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: course.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          course.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.school, color: Colors.grey);
                                          },
                                        ))
                                    : const Icon(Icons.school, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              // 课程信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            course.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (course.isLive)
                                          Container(
                                            margin: const EdgeInsets.only(left: 4),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              '直播',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      course.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.person, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          course.instructor,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          course.formattedDuration,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 14, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          course.rating.toStringAsFixed(1),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.people, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${course.studentCount}人学习',
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '¥${course.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700],
                                              ),
                                            ),
                                            if (course.hasDiscount) ...[
                                              const SizedBox(width: 8),
                                              Text(
                                                '¥${course.originalPrice!.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Chip(
                                          label: Text(course.category),
                                          backgroundColor: Colors.green[100],
                                          labelStyle: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

