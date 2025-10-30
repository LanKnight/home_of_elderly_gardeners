import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '输入关键字搜索',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (v) => _doSearch(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _doSearch,
              child: const Text('搜索'),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(child: Text('搜索结果将在这里展示（占位）')),
            ),
          ],
        ),
      ),
    );
  }

  void _doSearch() {
    final q = _controller.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('搜索：$q（占位）')));
  }
}
