import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final String apiKey = 'pat_c661cb6aee7103834d85648e1efd22192aae91c72e04155512bfcbd129d4040e';
  final String apiUrl = 'https://api.coze.cn/v1/workflow';
  
  print('Testing connection to Coze API...');
  
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Connection successful!');
    } else {
      print('❌ Connection failed!');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }
}