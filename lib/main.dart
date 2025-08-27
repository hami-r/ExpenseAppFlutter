import 'package:expense_app/firebase_options.dart';
import 'package:expense_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/biometric_lock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ProviderScope(  // ✅ Riverpod wrapper - no create or builder needed
      child: MaterialApp(
        title: 'Expense App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
          useMaterial3: true,
        ),
        home: const BiometricLock(child: HomePage()),
      ),
    );
  }
}