// lib/screens/detail.dart
import 'package:flutter/material.dart';
import 'package:smart_extinguisher_app/models/fire_extinguisher.dart';
import 'dart:io';

class FireExtinguisherDetailScreen extends StatelessWidget {
  final FireExtinguisher extinguisher;

  const FireExtinguisherDetailScreen({super.key, required this.extinguisher});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '소화기 상세 정보',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔥 이미지 카드
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: extinguisher.imagePath != null
                    ? Image.file(
                        File(extinguisher.imagePath!),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 220,
                        alignment: Alignment.center,
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.fire_extinguisher_outlined,
                          color: Colors.grey[400],
                          size: 70,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // 📋 이름
              Text(
                extinguisher.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // 💡 상태 정보 카드
              Card(
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.volume_up,
                        '경보음 작동',
                        extinguisher.isSoundOn ? '켜짐' : '꺼짐',
                        extinguisher.isSoundOn ? Colors.green : Colors.redAccent,
                      ),
                      const Divider(height: 22),
                      _buildInfoRow(
                        Icons.light_mode_outlined,
                        '경광등 상태',
                        extinguisher.isLightOn ? '켜짐' : '꺼짐',
                        extinguisher.isLightOn ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 🔙 목록으로 돌아가기 버튼
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  '목록으로 돌아가기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              Text(value,
                  style: TextStyle(
                      color: color, fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
