import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey = 'AIzaSyAJrgd3GsMHDzAYEvQqIox3z69yuhm80T8';
 static const _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey';


  static Future<String> summarizeText(String inputText) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Summarize this text clearly and briefly:\n$inputText"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data['candidates'][0]['content']['parts'][0]['text'];
        return summary.trim();
      } else {
     
        return 'Error: Unable to summarize. Check API key and request format.';
      }
    } catch (e) {
    
      return 'Error: ${e.toString()}';
    }
  }
}
