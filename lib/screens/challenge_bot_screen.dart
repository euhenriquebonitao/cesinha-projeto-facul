import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:challenge_vision/models/project.dart'; // Importar o modelo Project
import 'package:challenge_vision/project_customization_screen.dart';
import 'package:challenge_vision/add_project_screen.dart';
import 'package:challenge_vision/services/ai_knowledge_service.dart';
import 'package:challenge_vision/services/conversation_history_service.dart';
import 'package:challenge_vision/services/ai_prompt_service.dart';

class ChallengeMindScreen extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback? onNavigateBack;
  final int? fromTabIndex; // Para saber de qual aba veio
  const ChallengeMindScreen({super.key, required this.projects, this.onNavigateBack, this.fromTabIndex});

  @override
  State<ChallengeMindScreen> createState() => _ChallengeMindScreenState();
}

class _ChallengeMindScreenState extends State<ChallengeMindScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;
  int _selectedIndex = 1; // ChallengeMind tab
  bool _sessionInitialized = false;

  // TODO: Securely manage this API key (e.g., environment variables)
  // For now, it's a placeholder
  final String _geminiApiKey = "AIzaSyB9utH-MH3Smsdrs6tj3R3tUUiyqHXai30";

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  @override
  void dispose() {
    // Finalizar sessão quando sair da tela
    ConversationHistoryService.endCurrentSession();
    super.dispose();
  }

  Future<void> _initializeSession() async {
    if (!_sessionInitialized) {
      await ConversationHistoryService.init();
      await ConversationHistoryService.startNewSession(
        title: 'Conversa com ChallengeMind - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        projects: widget.projects,
      );
      _sessionInitialized = true;
    }
  } 

  Future<void> _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "msg": userMessage});
      _controller.clear();
      _loading = true;
    });

    // Salvar mensagem do usuário no histórico
    await ConversationHistoryService.addMessage(
      role: 'user',
      content: userMessage,
    );

    final apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_geminiApiKey";

    // Gerar prompt contextualizado usando o novo serviço
    final conversationContext = ConversationHistoryService.generateConversationContext();
    final fullContext = AIPromptService.generateContextualPrompt(
      userQuestion: userMessage,
      projects: widget.projects,
      conversationHistory: conversationContext,
      additionalContext: {
        'sessionId': 'current_session',
        'userEmail': 'user@eurofarma.com', // TODO: Obter do AuthService
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "model",
            "parts": [
              {"text": fullContext}
            ]
          },
          {
            "role": "user",
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String botResponse = "";
      try {
        botResponse = data["candidates"][0]["content"]["parts"][0]["text"];
      } catch (e) {
        botResponse = data.toString();
      }

      setState(() {
        _messages.add({"role": "bot", "msg": botResponse});
      });

      // Salvar resposta do bot no histórico
      await ConversationHistoryService.addMessage(
        role: 'bot',
        content: botResponse,
        metadata: {
          'responseTime': DateTime.now().toIso8601String(),
          'model': 'gemini-1.5-flash-latest',
          'projectCount': widget.projects.length,
        },
      );
    } else {
      final errorMessage = "Erro: ${response.statusCode} - ${response.body}";
      setState(() {
        _messages.add({
          "role": "bot",
          "msg": errorMessage
        });
      });

      // Salvar erro no histórico
      await ConversationHistoryService.addMessage(
        role: 'bot',
        content: errorMessage,
        metadata: {
          'error': true,
          'statusCode': response.statusCode,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }

    setState(() {
      _loading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegação direta para cada tela
    if (index == 0) {
      // Home - voltar para Home
      Navigator.of(context).pop();
      widget.onNavigateBack?.call();
    } else if (index == 1) {
      // ChallengeMind - já estamos aqui, não precisa navegar
      return;
    } else if (index == 2) {
      // Projetos - ir direto para Projetos
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProjectCustomizationScreen(
            onProjectUpdated: (project) {
              // Callback para atualizar projeto
            },
            onProjectDeleted: (project) {
              // Callback para deletar projeto
            },
            onProjectAdded: (project) {
              // Callback para adicionar projeto
            },
            projects: widget.projects,
            fromTabIndex: widget.fromTabIndex, // Passar índice de origem
            onNavigateBack: () {
              setState(() {
                _selectedIndex = widget.fromTabIndex ?? 1; // Voltar para aba de origem
              });
            },
          ),
        ),
      );
    } else if (index == 3) {
      // Add Projeto - ir direto para Add Projeto
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddProjectScreen(
            onProjectCreated: (newProject) {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "ChallengeMind",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header com informações do bot
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Assistente de Projetos",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Aqui para ajudar com seus ${widget.projects.length} projetos",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Área de mensagens
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Olá! Sou seu assistente de projetos",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Pergunte sobre seus projetos ou peça ajuda para gerenciá-los",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isUser = msg["role"] == "user";
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: isUser 
                                  ? MainAxisAlignment.end 
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.smart_toy,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isUser ? Colors.black : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20).copyWith(
                                        bottomLeft: isUser 
                                            ? const Radius.circular(20)
                                            : const Radius.circular(4),
                                        bottomRight: isUser 
                                            ? const Radius.circular(4)
                                            : const Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      msg["msg"] ?? "",
                                      style: TextStyle(
                                        color: isUser ? Colors.white : Colors.black87,
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
            
            // Loading indicator
            if (_loading)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20).copyWith(
                          bottomLeft: const Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Pensando...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // Área de input
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Digite sua mensagem...",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.edit,
                            color: Colors.grey[600],
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: _sendMessage,
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.black, // Mudado para preto
              unselectedItemColor: Colors.black,
              backgroundColor: Colors.white,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              unselectedLabelStyle: TextStyle(color: Colors.black),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
            ),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home, 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.smart_toy, 1),
                label: 'ChallengeMind',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.dashboard, 2),
                label: 'Projetos',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.add_box, 3),
                label: 'Add Projeto',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
