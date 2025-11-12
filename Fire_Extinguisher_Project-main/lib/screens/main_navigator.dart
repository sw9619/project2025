// lib/screens/main_navigator.dart
import 'package:flutter/material.dart';
import 'package:smart_extinguisher_app/screens/register.dart';
import 'package:smart_extinguisher_app/screens/list.dart';
import 'package:smart_extinguisher_app/models/fire_extinguisher.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  // 더미 혹은 실제 데이터를 여기서 관리하거나 API로 가져오면 됩니다.
  final List<FireExtinguisher> dummyExtinguishers = [];

  @override
  Widget build(BuildContext context) {
    // 콜백: 리스트 화면에서 이 콜백을 호출하면 탭을 0(등록)으로 전환
    void goToRegisterTab() {
      setState(() => _selectedIndex = 0);
    }

    final screens = [
      // 탭 0: 등록 화면
      const RegisterScreen(),
      // 탭 1: 리스트 화면 — 콜백 전달
      FireExtinguisherListScreen(
        extinguishers: dummyExtinguishers,
        onRegisterTap: goToRegisterTab,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration_rounded),
            label: '소화기 등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: '소화기 목록',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
