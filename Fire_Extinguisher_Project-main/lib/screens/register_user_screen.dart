// lib/screens/register_user_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_extinguisher_app/utils/http_helper.dart';
import 'dart:convert';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final data = {'username': _email, 'password': _password};
      final response = await httpPost('/register', data, context: context);
      final responseBody = jsonDecode(response.body);

      if (!mounted) return;
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해주세요.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${responseBody['message'] ?? '알 수 없는 오류'}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 상단 로고
                Center(
                  child: Image.asset(
                    'assets/images/fire_icon.png',
                    height: 100,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 20),

                // 제목
                Text(
                  '회원가입',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '아이디와 비밀번호를 입력해주세요.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // 입력 폼
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '아이디 (이메일)',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (v) => _email = v.trim(),
                          validator: (v) {
                            if (v == null || v.isEmpty) return '아이디를 입력해주세요.';
                            if (!v.contains('@')) return '올바른 이메일 형식을 입력해주세요.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[600],
                              ),
                              onPressed: () =>
                                  setState(() => _isPasswordObscured = !_isPasswordObscured),
                            ),
                          ),
                          obscureText: _isPasswordObscured,
                          onChanged: (v) => _password = v,
                          validator: (v) =>
                              (v == null || v.length < 6) ? '비밀번호는 6자 이상이어야 합니다.' : null,
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: '비밀번호 확인',
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[600],
                              ),
                              onPressed: () =>
                                  setState(() => _isConfirmObscured = !_isConfirmObscured),
                            ),
                          ),
                          obscureText: _isConfirmObscured,
                          onChanged: (v) => _confirmPassword = v,
                          validator: (v) =>
                              (v != _password) ? '비밀번호가 일치하지 않습니다.' : null,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // 하단 버튼
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('이미 계정이 있으신가요? 로그인'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
