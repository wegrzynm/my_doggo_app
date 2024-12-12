import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_doggo_app/secure_storage.dart';

class ApiUtils {
  
  static Future<(int, String)> getRequest(String url) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SecureStorage().readToken()}'
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return (response.statusCode, response.body);
      } else {
        return (response.statusCode, response.body);
        
      }
    } catch (e) {
      return (500,[{'error': e.toString()}].toString());
    }
  }

  static Future<(int, String)> postRequest(String url, Map<String, String> body, bool isAuthorized) async {
    final Map<String, String> headers;
    if (isAuthorized) {
      headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await SecureStorage().readToken()}'
      };
    }else {
      headers = {
        'Content-Type': 'application/json'
      };
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return (response.statusCode, response.body);
      } else {
        return (response.statusCode, response.body);
      }
    } catch (e) {
      return (500,[{'error': e.toString()}].toString());
    }
  }
}