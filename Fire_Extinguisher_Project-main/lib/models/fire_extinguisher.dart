// lib/models/fire_extinguisher.dart

import 'dart:io'; // Image.file()을 사용하기 위해 필요

class FireExtinguisher {
  final String id; // 서버 MongoDB의 '_id' 필드 값
  String name;
  String? imagePath; // 🚨 서버의 /uploads/파일명 경로
  bool isSoundOn;
  bool isLightOn;

  FireExtinguisher({
    required this.id,
    required this.name,
    this.imagePath,
    this.isSoundOn = false,
    this.isLightOn = false,
  });

  // 객체를 JSON (Map)으로 변환 (서버 전송용)
  Map<String, dynamic> toJson() => {
    'name': name,
    'imagePath': imagePath,
    'isSoundOn': isSoundOn,
    'isLightOn': isLightOn,
  };

  // JSON (Map)에서 객체로 변환 (서버 응답 처리용)
  factory FireExtinguisher.fromJson(Map<String, dynamic> json) {
    return FireExtinguisher(
      // ✅ MongoDB의 '_id'를 'id' 필드에 매핑
      id: json['_id'] as String? ?? '', // _id가 없는 경우 방지
      name: json['name'] as String? ?? '이름 없음',
      imagePath: json['imagePath'] as String?,
      isSoundOn: json['isSoundOn'] as bool? ?? false,
      isLightOn: json['isLightOn'] as bool? ?? false,
    );
  }
}

// 🚨 전역 리스트는 서버 연동 시에는 사용하지 않는 것이 좋음 (list.dart에서 관리)
// List<FireExtinguisher> fireExtinguisherList = [];