// lib/screens/list.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_extinguisher_app/models/fire_extinguisher.dart';
import 'package:smart_extinguisher_app/screens/detail.dart';
import 'package:smart_extinguisher_app/login_screen.dart'; // 로그아웃 이동
// import 'package:smart_extinguisher_app/screens/register.dart'; // 더 이상 직접 push하지 않음

class FireExtinguisherListScreen extends StatefulWidget {
  final List<FireExtinguisher> extinguishers;
  final VoidCallback? onRegisterTap; // ✅ 콜백 추가 (상위에서 전달)

  const FireExtinguisherListScreen({
    super.key,
    required this.extinguishers,
    this.onRegisterTap,
  });

  @override
  State<FireExtinguisherListScreen> createState() =>
      _FireExtinguisherListScreenState();
}

class _FireExtinguisherListScreenState
    extends State<FireExtinguisherListScreen> {
  late List<FireExtinguisher> _extinguishers;

  @override
  void initState() {
    super.initState();
    _extinguishers = List.from(widget.extinguishers);
  }

  void _refreshList() {
    setState(() {}); // 실제로는 API 호출 후 setState
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('목록이 새로고침되었습니다')),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          '소화기 목록',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _refreshList,
            tooltip: '새로고침',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _logout,
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                '등록된 소화기를 확인하세요',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 24),

              // 리스트
              Expanded(
                child: _extinguishers.isEmpty
                    ? Center(
                        child: Text(
                          '등록된 소화기가 없습니다.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _extinguishers.length,
                        itemBuilder: (context, index) {
                          final extinguisher = _extinguishers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FireExtinguisherDetailScreen(
                                    extinguisher: extinguisher,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    child: extinguisher.imagePath != null
                                        ? Image.file(
                                            File(extinguisher.imagePath!),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[100],
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.fire_extinguisher_outlined,
                                              size: 42,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            extinguisher.name,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.volume_up,
                                                color: extinguisher.isSoundOn
                                                    ? Colors.green
                                                    : Colors.redAccent,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                extinguisher.isSoundOn
                                                    ? '경보음 켜짐'
                                                    : '경보음 꺼짐',
                                                style: TextStyle(
                                                  color:
                                                      extinguisher.isSoundOn
                                                          ? Colors.green
                                                          : Colors.redAccent,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),

              // 등록 버튼: 상위에서 전달된 콜백이 있으면 콜백 호출(탭 전환)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (widget.onRegisterTap != null) {
                      widget.onRegisterTap!();
                    } else {
                      // 안전망: 콜백이 없으면 그냥 push
                      Navigator.pushNamed(context, '/register');
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    '소화기 등록',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
