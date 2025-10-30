// lib/pages/user_type_page.dart
import 'package:flutter/material.dart';

class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '老园丁之家',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            Text(
              'Home of Elderly Gardeners',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 60),
            _buildUserTypeCard(
              context,
              '用户',
              '我是来学习园艺的',
              Icons.person,
              Colors.blue,
            ),
            const SizedBox(height: 30),
            _buildUserTypeCard(
              context,
              '商家',
              '我是来提供服务的',
              Icons.business,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register', arguments: title);
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}