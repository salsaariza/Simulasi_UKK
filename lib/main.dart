import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenora_pos/screens/logout_screen.dart';
import 'package:greenora_pos/stock/stock_screen.dart';
import 'package:greenora_pos/users/user_screen.dart';
import 'services/supabase_client.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'products/product_screen.dart';
import 'cashier/cashier_screen.dart';
import 'package:greenora_pos/customers/customer_screen.dart';
import 'package:greenora_pos/receipts/receipt_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenoraPos',
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/product': (context) => ProductScreen(),
        '/kasir': (context) => CashierScreen(),
        '/customer': (context) => CustomerScreen(),
        '/stock': (context) => StokScreen(),       
        '/users': (context) => PetugasScreen(),   
        '/report': (context) => LaporanPenjualanScreen(),
        '/logout': (context) => LogoutScreen                                                                                                                                                                                                                                                                                                                                           (),
      },
    );
  }
}
