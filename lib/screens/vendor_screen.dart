import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_appbar.dart';
import 'login_screen.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
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
        title: 'Kênh Người Bán',
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
                  // Hero banner - orange theme for vendor
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1E1608), Color(0xFF2A1F08)],
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
                              colors: [Colors.orangeAccent, Color(0xFFFF6B00)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.45),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.store_rounded,
                              size: 46, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _user?.fullName ?? 'Vendor',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?.email ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF8899AA)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.orange.withOpacity(0.5)),
                          ),
                          child: const Text(
                            'VENDOR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.orangeAccent,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats row
                        Row(
                          children: [
                            _StatCard(
                              label: 'Sản phẩm',
                              value: '0',
                              icon: Icons.inventory_2_rounded,
                              color: const Color(0xFF0099CC),
                            ),
                            const SizedBox(width: 14),
                            _StatCard(
                              label: 'Đơn hàng',
                              value: '0',
                              icon: Icons.receipt_long_rounded,
                              color: Colors.greenAccent,
                            ),
                            const SizedBox(width: 14),
                            _StatCard(
                              label: 'Doanh thu',
                              value: '0đ',
                              icon: Icons.trending_up_rounded,
                              color: Colors.orangeAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Quản lý cửa hàng',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 14),

                        _ActionTile(
                          icon: Icons.add_business_rounded,
                          label: 'Quản lý sản phẩm',
                          subtitle: 'Thêm, sửa, xóa sản phẩm',
                          color: const Color(0xFF0099CC),
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          icon: Icons.bar_chart_rounded,
                          label: 'Thống kê bán hàng',
                          subtitle: 'Xem báo cáo doanh thu',
                          color: Colors.greenAccent,
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          icon: Icons.settings_rounded,
                          label: 'Cài đặt cửa hàng',
                          subtitle: 'Thông tin và cài đặt',
                          color: Colors.orangeAccent,
                          onTap: () {},
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A3F52)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8899AA))),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A3F52)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF8899AA))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF2A3F52), size: 22),
          ],
        ),
      ),
    );
  }
}
