import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true; // Treat as expired if decoding fails
    }
  }

  static Map<String, dynamic> decodeToken(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return {};
    }
  }

  static void validateToken(String token) async {
    if(!isTokenExpired(token)) {
      return;
    }
    String login = await SecureStorage().readSecureData('login');
    String password = await SecureStorage().readSecureData('password');

    const String url = '${Environment.apiUrl}login';
    final Map<String, String> body = {
      'email': login,
      'password': password,
    };

    var response = await ApiUtils.postRequest(url,body, false);
    var (statusCode, apiResponse) = response;

    if (statusCode == 200) {
      final Map<String, dynamic> data = json.decode(apiResponse);
        final String token = data['token'];
        SecureStorage().deleteSecureData('token');
        SecureStorage().writeSecureData('token', token);
    }
  }
}