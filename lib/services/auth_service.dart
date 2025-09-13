import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream do usuário atual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Fazer login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 AUTH: Tentando fazer login com $email');
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ AUTH: Login realizado com sucesso para ${result.user?.email}');
      return result;
    } on FirebaseAuthException catch (e) {
      print('❌ AUTH: Erro no login: ${e.message}');
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('❌ AUTH: Erro geral: $e (Tipo: ${e.runtimeType})');
      throw 'Erro inesperado. Tente novamente.';
    }
  }

  // Registrar novo usuário
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 AUTH: Tentando criar conta para $email');
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ AUTH: Conta criada com sucesso para ${result.user?.email}');
      return result;
    } on FirebaseAuthException catch (e) {
      print('❌ AUTH: Erro na criação: ${e.message}');
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('❌ AUTH: Erro geral: $e (Tipo: ${e.runtimeType})');
      throw 'Erro inesperado. Tente novamente.';
    }
  }

  // Fazer logout
  Future<void> signOut() async {
    try {
      print('🔐 AUTH: Fazendo logout de ${currentUser?.email}');
      await _auth.signOut();
      print('✅ AUTH: Logout realizado com sucesso');
    } catch (e) {
      print('❌ AUTH: Erro no logout: $e');
      throw 'Erro ao fazer logout. Tente novamente.';
    }
  }

  // Resetar senha
  Future<void> resetPassword(String email) async {
    try {
      print('🔐 AUTH: Enviando email de reset para $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ AUTH: Email de reset enviado com sucesso');
    } on FirebaseAuthException catch (e) {
      print('❌ AUTH: Erro no reset: ${e.message}');
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('❌ AUTH: Erro geral: $e (Tipo: ${e.runtimeType})');
      throw 'Erro inesperado. Tente novamente.';
    }
  }

  // Converter códigos de erro em mensagens amigáveis
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este email.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este email já está sendo usado por outra conta.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      default:
        return 'Erro de autenticação. Tente novamente.';
    }
  }
}
