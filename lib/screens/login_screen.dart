import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_button.dart';
import '../widgets/shared_text_field.dart';
import 'admin_screen.dart';
import 'customer_screen.dart';
import 'register_screen.dart';
import 'vendor_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    final result = await ApiService.login(
        email: _emailController.text, password: _passwordController.text);
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (result['success']) {
      final auth = AuthSingleton();
      final data = result['data'];
      auth.token = data.token;
      auth.email = data.email;
      auth.role = data.role;
      auth.userId = data.userId;

      Widget screen;
      switch (auth.role?.toLowerCase()) {
        case 'admin':
          screen = const AdminScreen();
          break;
        case 'vendor':
          screen = const VendorScreen();
          break;
        default:
          screen = const CustomerScreen();
      }
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => screen));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1923), Color(0xFF162230), Color(0xFF0D2137)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D4A8), Color(0xFF0099CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4A8).withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shield_rounded,
                        size: 46, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'HỆ THỐNG QUẢN LÝ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'User Management System',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF00D4A8),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Card form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2D3D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2A3F52)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Nhập thông tin tài khoản của bạn',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF8899AA)),
                        ),
                        const SizedBox(height: 24),
                        SharedTextField(
                          controller: _emailController,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        SharedTextField(
                          controller: _passwordController,
                          label: 'Mật khẩu',
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 28),
                        SharedButton(
                          label: 'ĐĂNG NHẬP',
                          onPressed: _login,
                          isLoading: _isLoading,
                          icon: Icons.login_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chưa có tài khoản?',
                          style: TextStyle(color: Color(0xFF8899AA))),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        ),
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            color: Color(0xFF00D4A8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
