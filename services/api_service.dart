import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://172.16.45.152:8000"; // FastAPI backend

  /// Upload study material file to backend
  /// Sends file as multipart/form-data
  Future<Map<String, dynamic>> uploadMaterial({
    required String title,
    required String description,
    required String fileType,
    required String chapterId,
    required String uploadedBy,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/upload-material");
      
      // Create multipart request
      var request = http.MultipartRequest('POST', uri);
      
      // Add form fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['fileType'] = fileType;
      request.fields['chapterId'] = chapterId;
      request.fields['uploadedBy'] = uploadedBy;
      
      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );
      
      // Send request
      final response = await request.send().timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw Exception('Upload timeout after 5 minutes'),
      );
      
      // Read and parse response
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': decodedResponse,
        };
      } else {
        return {
          'success': false,
          'error': decodedResponse['message'] ?? 'Upload failed',
          'statusCode': response.statusCode,
        };
      }
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.message}',
      };
    } on Exception catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get upload status/history
  Future<Map<String, dynamic>> getUploadHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/uploads"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch upload history');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
