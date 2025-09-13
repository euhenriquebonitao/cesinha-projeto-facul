import 'package:flutter/material.dart';
import 'package:challenge_vision/services/auth_service.dart';
import 'package:challenge_vision/services/project_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final ProjectStorageService _storageService = ProjectStorageService();
  bool _isLoading = false;
  bool _isRegisterMode = false;

  Future<void> _authenticate() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isRegisterMode) {
        // Registrar novo usuário
        await _authService.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          // Movido para antes da navegação
          _showSnackBar('Conta criada com sucesso!', Colors.green);
        }
      } else {
        // Fazer login
        await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Sincronizar projetos da nuvem após login
        try {
          await _storageService.syncFromCloud();
          if (mounted) {
            // Movido para antes da navegação
            _showSnackBar(
              'Login realizado! Projetos sincronizados.',
              Colors.green,
            );
          }
        } catch (e) {
          if (mounted) {
            // Movido para antes da navegação
            _showSnackBar(
              'Login realizado! (Sem sincronização)',
              Colors.orange,
            );
          }
        }
      }

      // Navegar para a home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        // Adicionado check de mounted
        _showSnackBar(e.toString(), Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return; // Adicionado check de mounted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar('Digite seu email para resetar a senha', Colors.red);
      return;
    }

    try {
      await _authService.resetPassword(_emailController.text.trim());
      _showSnackBar('Email de reset enviado!', Colors.green);
    } catch (e) {
      _showSnackBar(e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título
                Text(
                  _isRegisterMode ? 'CRIAR CONTA' : 'ENTRAR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 60),

                // Campo de Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 24),

                // Campo de Senha
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 40),

                // Botão de Entrar/Criar Conta
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(
                            _isRegisterMode ? 'CRIAR CONTA' : 'ENTRAR',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botão para alternar entre Login e Registro
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isRegisterMode = !_isRegisterMode;
                          });
                        },
                  child: Text(
                    _isRegisterMode
                        ? 'Já tem uma conta? Entrar'
                        : 'Não tem uma conta? Criar conta',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 10),

                // Botão para resetar senha
                if (!_isRegisterMode)
                  TextButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
