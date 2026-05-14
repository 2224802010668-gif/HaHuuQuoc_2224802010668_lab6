import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_appbar.dart';
import 'login_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getCurrentUser();
    if (!mounted) return;
    if (result['success']) {
      setState(() {
        _user = result['data'] as UserModel;
        _isLoading = false;
      });
    } else {
      _logout();
    }
  }

  void _logout() {
    AuthSingleton().clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Trang Cá Nhân',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF00D4A8)),
            onPressed: _logout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00D4A8)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Hero banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF162230), Color(0xFF0D2137)],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00D4A8), Color(0xFF0099CC)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D4A8).withOpacity(0.4),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_rounded,
                              size: 46, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _user?.fullName ?? 'Người dùng',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4A8).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF00D4A8).withOpacity(0.5)),
                          ),
                          child: const Text(
                            'CUSTOMER',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF00D4A8),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info cards
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin tài khoản',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00D4A8),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _InfoCard(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: _user?.email ?? '',
                          color: const Color(0xFF0099CC),
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.badge_outlined,
                          label: 'User ID',
                          value: _user?.id ?? '',
                          color: Colors.purpleAccent,
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.calendar_today_rounded,
                          label: 'Ngày tham gia',
                          value: _user?.createdAt?.split('T').first ?? '',
                          color: Colors.orangeAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A3F52)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF8899AA))),
                const SizedBox(height: 3),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
