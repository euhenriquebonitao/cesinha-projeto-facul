import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> testFirebaseConnection() async {
  try {
    print('🔥 TESTE: Inicializando Firebase...');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('✅ TESTE: Firebase inicializado com sucesso!');

    print('🔥 TESTE: Testando autenticação...');
    final auth = FirebaseAuth.instance;
    print('✅ TESTE: FirebaseAuth instanciado');

    print('🔥 TESTE: Testando Firestore...');
    final firestore = FirebaseFirestore.instance;
    print('✅ TESTE: Firestore instanciado');

    // Teste de conexão com Firestore
    print('🔥 TESTE: Testando conexão com Firestore...');
    await firestore.collection('test').limit(1).get();
    print('✅ TESTE: Conexão com Firestore funcionando!');

    print('🎉 TESTE: Todos os testes passaram! Firebase está funcionando corretamente.');
  } catch (e) {
    print('❌ TESTE: Erro no teste do Firebase: $e');
    print('❌ TESTE: Tipo do erro: ${e.runtimeType}');
    rethrow;
  }
}
