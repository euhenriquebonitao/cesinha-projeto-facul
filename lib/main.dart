import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'models/project.dart';
import 'services/project_storage_service.dart';
import 'services/auth_service.dart';
import 'test_firebase.dart';

void main() async {
  // Garante que o Flutter esteja inicializado antes de usar plugins.
  await WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await testFirebaseConnection();
  } catch (e) {
    print('❌ FIREBASE: Erro na inicialização do Firebase: $e');
    // Continuar mesmo com erro para não quebrar o app
  }

  // Inicializa o Hive
  await Hive.initFlutter();
  print('🚀 HIVE: Hive inicializado com sucesso!');

  // Registra o adapter do Project
  Hive.registerAdapter(ProjectAdapter());
  print('📦 HIVE: ProjectAdapter registrado!');

  // Inicializa o serviço de armazenamento
  await ProjectStorageService.init();
  print('💾 STORAGE: ProjectStorageService inicializado!');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge Vision',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('🔍 APP: StreamBuilder está no estado: WAITING');
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          if (snapshot.hasData) {
            print(
              '✅ APP: StreamBuilder tem dados! Usuário logado: ${AuthService().currentUser?.email}',
            );
            // Usuário logado - ir para Home
            return const HomeScreen();
          } else {
            print('❌ APP: StreamBuilder NÃO tem dados. Usuário não logado.');
            // Usuário não logado - ir para Login
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// ... existing  code ...
