import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://two4oss-group6.onrender.com'; // Flask 서버 URL

  // 푸쉬업 카운트를 계산하기 위해 서버에 이미지 전송
  Future<int> sendFrame(XFile image) async {
    try {
      // 이미지 파일을 읽고 Base64로 인코딩
      Uint8List bytes = await image.readAsBytes();
      String base64Image = base64Encode(bytes);

      final url = Uri.parse('$baseUrl/process_frame');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        // JSON 응답에서 count 값을 추출
        final responseData = jsonDecode(response.body);
        return responseData['count'];
      } else {
        throw Exception(
            'Failed to process frame: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error sending frame: $e');
      rethrow;
    }
  }

  // 푸쉬업 카운터 초기화 요청
  Future<void> resetCounter() async {
    final url = Uri.parse('$baseUrl/reset');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to reset counter: ${response.body}');
    }
  }
}