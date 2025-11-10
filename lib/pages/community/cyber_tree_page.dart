import 'package:flutter/material.dart';

class CyberTreePage extends StatefulWidget {
  const CyberTreePage({super.key});

  @override
  State<CyberTreePage> createState() => _CyberTreePageState();
}

class _CyberTreePageState extends State<CyberTreePage> {
  int _level = 1;
  int _experience = 0;
  int _waterCount = 0;
  int _fertilizerCount = 0;
  int _nextLevelExp = 100;

  @override
  Widget build(BuildContext context) {
    final progress = _experience / _nextLevelExp;
    final treeSize = 50.0 + (_level * 10.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('赛博种树'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 等级和经验条
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '等级 $_level',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              minHeight: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$_experience / $_nextLevelExp',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 树的可视化
              Container(
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getTreeIcon(),
                      size: treeSize,
                      color: Colors.green[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getTreeName(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // 统计信息
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('浇水次数', '$_waterCount', Icons.water_drop, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('施肥次数', '$_fertilizerCount', Icons.eco, Colors.brown),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 操作按钮
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.water_drop),
                      label: const Text('浇水 (+10经验)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          _waterCount++;
                          _addExperience(10);
                        });
                        _showActionFeedback('浇水成功！');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.eco),
                      label: const Text('施肥 (+20经验)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          _fertilizerCount++;
                          _addExperience(20);
                        });
                        _showActionFeedback('施肥成功！');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_fix_high),
                      label: const Text('修剪 (+15经验)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          _addExperience(15);
                        });
                        _showActionFeedback('修剪成功！');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 说明
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '游戏说明',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• 通过浇水、施肥、修剪来获得经验值\n'
                        '• 经验值达到要求后可以升级\n'
                        '• 等级越高，树的外观会发生变化\n'
                        '• 每天坚持照顾你的树，让它茁壮成长！',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _addExperience(int exp) {
    _experience += exp;
    if (_experience >= _nextLevelExp) {
      _experience -= _nextLevelExp;
      _level++;
      _nextLevelExp = 100 * _level;
      _showLevelUpDialog();
    }
  }

  void _showActionFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 升级了！'),
        content: Text('恭喜！你的树升到了等级 $_level！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('继续'),
          ),
        ],
      ),
    );
  }

  IconData _getTreeIcon() {
    if (_level < 3) return Icons.eco;
    if (_level < 5) return Icons.park;
    if (_level < 10) return Icons.forest;
    return Icons.nature;
  }

  String _getTreeName() {
    if (_level < 3) return '小树苗';
    if (_level < 5) return '小树';
    if (_level < 10) return '大树';
    if (_level < 20) return '参天大树';
    return '神树';
  }
}

