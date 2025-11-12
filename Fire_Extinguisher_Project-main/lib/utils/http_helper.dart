// lib/utils/http_helper.dart

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_extinguisher_app/login_screen.dart'; 

// 🚨 Vercel 서버의 공용 HTTPS 주소 사용
const String baseUrl = 'https://fire-extinguisher-server.vercel.app/api/v1'; 
const String imageRootUrl = 'https://fire-extinguisher-server.vercel.app'; 

// ✅ 재시도 관련 상수
const int maxRetries = 3; 
const Duration retryDelay = Duration(seconds: 5);

// 저장된 인증 토큰을 가져오는 함수
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

// 401 오류 처리 및 로그아웃 함수
Future<void> _handleUnauthorized(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  if (context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('세션이 만료되었습니다. 다시 로그인해주세요.'))
    );
  }
}

// GET 요청 헬퍼 (재시도 로직 포함)
Future<http.Response> httpGet(String endpoint, {BuildContext? context}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    print('📦 HTTP GET 요청 시작: $url (시도 $attempt/$maxRetries)');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 60)); 

      if (response.statusCode == 401 && context != null && context.mounted) {
        await _handleUnauthorized(context);
        throw Exception('401 인증 오류'); 
      }
      
      if (response.statusCode < 500) {
        return response; 
      } else {
        print('⚠️ 서버 응답 오류: ${response.statusCode}. 5초 후 재시도...');
      }

    } catch (e) {
      if (attempt == maxRetries) {
        print('❌ 최종 네트워크 오류: $e');
        throw Exception('네트워크 요청 실패 (GET): $e'); 
      }
      print('네트워크 오류 발생. 5초 후 재시도...');
      await Future.delayed(retryDelay); 
    }
  }
  throw Exception('알 수 없는 오류');
}

// POST 요청 헬퍼 (재시도 로직 포함)
Future<http.Response> httpPost(String endpoint, Map<String, dynamic> body, {BuildContext? context}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    print('📦 HTTP POST 요청 시작: $url (시도 $attempt/$maxRetries)');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 401 && context != null && context.mounted) {
        await _handleUnauthorized(context);
        throw Exception('401 인증 오류');
      }
      
      if (response.statusCode < 500) {
        return response; 
      } else {
        print('⚠️ 서버 응답 오류: ${response.statusCode}. 5초 후 재시도...');
      }
    } catch (e) {
      if (attempt == maxRetries) {
        print('❌ 최종 네트워크 오류: $e');
        throw Exception('네트워크 요청 실패 (POST): $e');
      }
      print('네트워크 오류 발생. 5초 후 재시도...');
      await Future.delayed(retryDelay); 
    }
  }
  throw Exception('알 수 없는 오류');
}

// DELETE 요청 헬퍼 (재시도 로직 포함)
Future<http.Response> httpDelete(String endpoint, {BuildContext? context}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    print('📦 HTTP DELETE 요청 시작: $url (시도 $attempt/$maxRetries)');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(url, headers: headers).timeout(const Duration(seconds: 60));

      if (response.statusCode == 401 && context != null && context.mounted) {
        await _handleUnauthorized(context);
        throw Exception('401 인증 오류');
      }
      if (response.statusCode < 500) {
        return response; 
      } else {
        print('⚠️ 서버 응답 오류: ${response.statusCode}. 5초 후 재시도...');
      }

    } catch (e) {
      if (attempt == maxRetries) {
        print('❌ 최종 네트워크 오류: $e');
        throw Exception('네트워크 요청 실패 (DELETE): $e');
      }
      print('네트워크 오류 발생. 5초 후 재시도...');
      await Future.delayed(retryDelay); 
    }
  }
  throw Exception('알 수 없는 오류');
}

// PUT 요청 헬퍼 (재시도 로직 포함)
Future<http.Response> httpPut(String endpoint, Map<String, dynamic> body, {BuildContext? context}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    print('📦 HTTP PUT 요청 시작: $url (시도 $attempt/$maxRetries)');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 401 && context != null && context.mounted) {
        await _handleUnauthorized(context);
        throw Exception('401 인증 오류');
      }
      if (response.statusCode < 500) {
        return response; 
      } else {
        print('⚠️ 서버 응답 오류: ${response.statusCode}. 5초 후 재시도...');
      }

    } catch (e) {
      if (attempt == maxRetries) {
        print('❌ 최종 네트워크 오류: $e');
        throw Exception('네트워크 요청 실패 (PUT): $e');
      }
      print('네트워크 오류 발생. 5초 후 재시도...');
      await Future.delayed(retryDelay); 
    }
  }
  throw Exception('알 수 없는 오류');
}