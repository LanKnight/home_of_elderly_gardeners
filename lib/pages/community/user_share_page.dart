import 'package:flutter/material.dart';

class UserSharePage extends StatefulWidget {
  const UserSharePage({super.key});

  @override
  State<UserSharePage> createState() => _UserSharePageState();
}

class _UserSharePageState extends State<UserSharePage> {
  final List<SharePost> _posts = [
    SharePost(
      id: '1',
      author: '张大爷',
      avatar: null,
      content: '今天种的番茄终于结果了！分享一下我的种植经验：每天早晚各浇一次水，每周施一次有机肥。',
      images: [],
      likes: 25,
      comments: 8,
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SharePost(
      id: '2',
      author: '李奶奶',
      avatar: null,
      content: '我的多肉植物园，养了快一年了，状态都很好！',
      images: [],
      likes: 42,
      comments: 15,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SharePost(
      id: '3',
      author: '王师傅',
      avatar: null,
      content: '分享一个浇水小技巧：用喷壶从上方喷洒，模拟自然降雨，植物会更健康。',
      images: [],
      likes: 38,
      comments: 12,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户分享'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showShareDialog(context);
            },
          ),
        ],
      ),
      body: _posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '还没有分享内容',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _showShareDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('发布分享'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 用户信息
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green[200],
                              child: post.avatar != null
                                  ? ClipOval(
                                      child: Image.network(
                                        post.avatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Text(
                                            post.author[0],
                                            style: const TextStyle(color: Colors.green),
                                          );
                                        },
                                      ),
                                    )
                                  : Text(
                                      post.author[0],
                                      style: const TextStyle(color: Colors.green),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.author,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(post.date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // 内容
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                        // 图片（如果有）
                        if (post.images.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: post.images.length,
                              itemBuilder: (context, imgIndex) {
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      post.images[imgIndex],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.image, size: 50, color: Colors.grey);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(),
                        // 操作栏
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(
                              icon: Icons.thumb_up_outlined,
                              label: '${post.likes}',
                              onTap: () {
                                setState(() {
                                  post.likes++;
                                });
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.comment_outlined,
                              label: '${post.comments}',
                              onTap: () {
                                _showCommentsDialog(context, post);
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.share_outlined,
                              label: '分享',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('分享功能开发中...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发布分享'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '分享你的园艺心得...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _posts.insert(
                    0,
                    SharePost(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      author: '我',
                      avatar: null,
                      content: controller.text.trim(),
                      images: [],
                      likes: 0,
                      comments: 0,
                      date: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('发布成功！')),
                );
              }
            },
            child: const Text('发布'),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(BuildContext context, SharePost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('评论'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('用户A'),
                subtitle: Text('这个方法很实用！'),
              ),
              const ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('用户B'),
                subtitle: Text('学到了，谢谢分享！'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
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

class SharePost {
  final String id;
  final String author;
  final String? avatar;
  final String content;
  final List<String> images;
  int likes;
  int comments;
  final DateTime date;

  SharePost({
    required this.id,
    required this.author,
    this.avatar,
    required this.content,
    required this.images,
    required this.likes,
    required this.comments,
    required this.date,
  });
}

