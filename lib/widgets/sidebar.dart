import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: const BoxDecoration(
              color: Color(0xFF558B2F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Greenora",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Admin",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ================= MENU ITEMS =================
          _MenuItem(
            icon: Icons.person_add_alt,
            title: "Petugas Baru",
            onTap: ()  => Navigator.pushNamed(context, '/users'),
          ),
          _MenuItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          _MenuItem(
            icon: Icons.inventory_2,
            title: "Manajemen Produk",
            onTap: () => Navigator.pushNamed(context, '/product'),
          ),
          _MenuItem(
            icon: Icons.people,
            title: "Manajemen Pelanggan",
            onTap: () => Navigator.pushNamed(context, '/customer'),
          ),
          _MenuItem(
            icon: Icons.point_of_sale,
            title: "Kasir",
            onTap: () => Navigator.pushNamed(context, '/kasir'),
          ),
          _MenuItem(
            icon: Icons.store,
            title: "Manajemen Stok",
            onTap: () => Navigator.pushNamed(context, '/stock'),
          ),
          _MenuItem(
            icon: Icons.receipt_long,
            title: "Laporan & Cetak",
            onTap: () => Navigator.pushNamed(context, '/report'),
          ),
          _MenuItem(
            icon: Icons.logout,
            title: "Logout",
            onTap: () => Navigator.pushNamed(context, '/logout'), 
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
    );
  }
}
