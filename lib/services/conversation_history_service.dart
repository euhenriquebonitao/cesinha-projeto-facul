import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:challenge_vision/models/project.dart';

/// Modelo para representar uma mensagem na conversa
class ConversationMessage {
  final String role; // 'user' ou 'bot'
  final String content;
  final DateTime timestamp;
  final String? projectContext; // ID do projeto relacionado, se houver
  final Map<String, dynamic>? metadata; // Dados adicionais

  ConversationMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.projectContext,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'projectContext': projectContext,
      'metadata': metadata,
    };
  }

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      role: json['role'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      projectContext: json['projectContext'],
      metadata: json['metadata'],
    );
  }
}

/// Modelo para representar uma sessão de conversa
class ConversationSession {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ConversationMessage> messages;
  final List<String> projectIds; // IDs dos projetos discutidos
  final Map<String, dynamic> sessionMetadata;

  ConversationSession({
    required this.id,
    required this.title,
    required this.startTime,
    this.endTime,
    required this.messages,
    required this.projectIds,
    required this.sessionMetadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'projectIds': projectIds,
      'sessionMetadata': sessionMetadata,
    };
  }

  factory ConversationSession.fromJson(Map<String, dynamic> json) {
    return ConversationSession(
      id: json['id'],
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      messages: (json['messages'] as List)
          .map((m) => ConversationMessage.fromJson(m))
          .toList(),
      projectIds: List<String>.from(json['projectIds']),
      sessionMetadata: json['sessionMetadata'] ?? {},
    );
  }
}

/// Serviço para gerenciar histórico de conversas com a IA
class ConversationHistoryService {
  static const String _sessionsKey = 'conversation_sessions';
  static const String _currentSessionKey = 'current_conversation_session';
  static const int _maxSessions = 50; // Máximo de sessões salvas
  static const int _maxMessagesPerSession = 100; // Máximo de mensagens por sessão

  static ConversationSession? _currentSession;
  static List<ConversationSession> _sessions = [];

  /// Inicializa o serviço
  static Future<void> init() async {
    await _loadSessions();
    await _loadCurrentSession();
  }

  /// Inicia uma nova sessão de conversa
  static Future<ConversationSession> startNewSession({
    required String title,
    List<Project>? projects,
  }) async {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final projectIds = projects?.map((p) => p.id).toList() ?? [];
    
    _currentSession = ConversationSession(
      id: sessionId,
      title: title,
      startTime: DateTime.now(),
      messages: [],
      projectIds: projectIds,
      sessionMetadata: {
        'projectCount': projects?.length ?? 0,
        'sessionType': 'general',
        'version': '1.0.0',
      },
    );

    await _saveCurrentSession();
    return _currentSession!;
  }

  /// Adiciona uma mensagem à sessão atual
  static Future<void> addMessage({
    required String role,
    required String content,
    String? projectContext,
    Map<String, dynamic>? metadata,
  }) async {
    if (_currentSession == null) {
      await startNewSession(title: 'Nova Conversa');
    }

    final message = ConversationMessage(
      role: role,
      content: content,
      timestamp: DateTime.now(),
      projectContext: projectContext,
      metadata: metadata,
    );

    _currentSession!.messages.add(message);

    // Limitar número de mensagens por sessão
    if (_currentSession!.messages.length > _maxMessagesPerSession) {
      _currentSession!.messages.removeAt(0);
    }

    await _saveCurrentSession();
  }

  /// Finaliza a sessão atual
  static Future<void> endCurrentSession() async {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(endTime: DateTime.now());
      await _saveSession(_currentSession!);
      _currentSession = null;
      await _clearCurrentSession();
    }
  }

  /// Obtém o histórico de mensagens da sessão atual
  static List<ConversationMessage> getCurrentSessionMessages() {
    return _currentSession?.messages ?? [];
  }

  /// Obtém todas as sessões salvas
  static List<ConversationSession> getAllSessions() {
    return List.from(_sessions);
  }

  /// Obtém sessões relacionadas a um projeto específico
  static List<ConversationSession> getSessionsForProject(String projectId) {
    return _sessions.where((session) => session.projectIds.contains(projectId)).toList();
  }

  /// Obtém sessões por período
  static List<ConversationSession> getSessionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _sessions.where((session) {
      return session.startTime.isAfter(startDate) && 
             session.startTime.isBefore(endDate);
    }).toList();
  }

  /// Busca sessões por conteúdo
  static List<ConversationSession> searchSessions(String query) {
    final lowerQuery = query.toLowerCase();
    return _sessions.where((session) {
      return session.title.toLowerCase().contains(lowerQuery) ||
             session.messages.any((msg) => 
               msg.content.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Gera insights baseados no histórico de conversas
  static Map<String, dynamic> generateConversationInsights() {
    if (_sessions.isEmpty) {
      return {
        'totalSessions': 0,
        'totalMessages': 0,
        'averageSessionLength': 0,
        'mostDiscussedProjects': [],
        'commonTopics': [],
        'userEngagement': 'low',
      };
    }

    final totalSessions = _sessions.length;
    final totalMessages = _sessions.fold(0, (sum, session) => sum + session.messages.length);
    final averageSessionLength = totalMessages / totalSessions;

    // Projetos mais discutidos
    final projectMentions = <String, int>{};
    for (final session in _sessions) {
      for (final projectId in session.projectIds) {
        projectMentions[projectId] = (projectMentions[projectId] ?? 0) + 1;
      }
    }
    final mostDiscussedProjects = projectMentions.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value))
        ..take(5);

    // Tópicos comuns (palavras-chave)
    final topicCounts = <String, int>{};
    final commonWords = ['projeto', 'risco', 'prazo', 'tecnologia', 'categoria', 'status', 'recomendação'];
    
    for (final session in _sessions) {
      for (final message in session.messages) {
        final content = message.content.toLowerCase();
        for (final word in commonWords) {
          if (content.contains(word)) {
            topicCounts[word] = (topicCounts[word] ?? 0) + 1;
          }
        }
      }
    }

    final commonTopics = topicCounts.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value))
        ..take(5);

    // Nível de engajamento do usuário
    String userEngagement;
    if (averageSessionLength > 10) {
      userEngagement = 'high';
    } else if (averageSessionLength > 5) {
      userEngagement = 'medium';
    } else {
      userEngagement = 'low';
    }

    return {
      'totalSessions': totalSessions,
      'totalMessages': totalMessages,
      'averageSessionLength': averageSessionLength.round(),
      'mostDiscussedProjects': mostDiscussedProjects.map((e) => {
        'projectId': e.key,
        'mentionCount': e.value,
      }).toList(),
      'commonTopics': commonTopics.map((e) => {
        'topic': e.key,
        'count': e.value,
      }).toList(),
      'userEngagement': userEngagement,
      'lastActivity': _sessions.isNotEmpty 
          ? _sessions.last.startTime.toIso8601String()
          : null,
    };
  }

  /// Gera contexto de conversas anteriores para a IA
  static String generateConversationContext() {
    if (_sessions.isEmpty) {
      return "Esta é a primeira conversa com o ChallengeBot.";
    }

    final recentSessions = _sessions.take(5).toList();
    final context = StringBuffer();
    
    context.writeln("=== CONTEXTO DE CONVERSAS ANTERIORES ===");
    context.writeln("Total de sessões: ${_sessions.length}");
    context.writeln("Última atividade: ${_sessions.last.startTime.day}/${_sessions.last.startTime.month}/${_sessions.last.startTime.year}");
    context.writeln();

    for (final session in recentSessions) {
      context.writeln("Sessão: ${session.title}");
      context.writeln("Data: ${session.startTime.day}/${session.startTime.month}/${session.startTime.year}");
      context.writeln("Mensagens: ${session.messages.length}");
      
      // Resumo das principais discussões
      final userMessages = session.messages.where((m) => m.role == 'user').toList();
      if (userMessages.isNotEmpty) {
        context.writeln("Principais tópicos discutidos:");
        for (final msg in userMessages.take(3)) {
          final preview = msg.content.length > 100 
              ? '${msg.content.substring(0, 100)}...'
              : msg.content;
          context.writeln("- $preview");
        }
      }
      context.writeln();
    }

    return context.toString();
  }

  /// Remove uma sessão específica
  static Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((session) => session.id == sessionId);
    await _saveSessions();
  }

  /// Limpa todo o histórico
  static Future<void> clearAllHistory() async {
    _sessions.clear();
    _currentSession = null;
    await _saveSessions();
    await _clearCurrentSession();
  }

  // Métodos privados para persistência

  static Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString(_sessionsKey);
    
    if (sessionsJson != null) {
      try {
        final List<dynamic> sessionsList = jsonDecode(sessionsJson);
        _sessions = sessionsList
            .map((json) => ConversationSession.fromJson(json))
            .toList();
      } catch (e) {
        print('Erro ao carregar sessões: $e');
        _sessions = [];
      }
    }
  }

  static Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Manter apenas as sessões mais recentes
    if (_sessions.length > _maxSessions) {
      _sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
      _sessions = _sessions.take(_maxSessions).toList();
    }

    final sessionsJson = jsonEncode(_sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_sessionsKey, sessionsJson);
  }

  static Future<void> _loadCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final currentSessionJson = prefs.getString(_currentSessionKey);
    
    if (currentSessionJson != null) {
      try {
        _currentSession = ConversationSession.fromJson(jsonDecode(currentSessionJson));
      } catch (e) {
        print('Erro ao carregar sessão atual: $e');
        _currentSession = null;
      }
    }
  }

  static Future<void> _saveCurrentSession() async {
    if (_currentSession != null) {
      final prefs = await SharedPreferences.getInstance();
      final currentSessionJson = jsonEncode(_currentSession!.toJson());
      await prefs.setString(_currentSessionKey, currentSessionJson);
    }
  }

  static Future<void> _saveSession(ConversationSession session) async {
    _sessions.add(session);
    await _saveSessions();
  }

  static Future<void> _clearCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentSessionKey);
  }
}

/// Extensão para facilitar a criação de cópias de ConversationSession
extension ConversationSessionExtension on ConversationSession {
  ConversationSession copyWith({
    String? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    List<ConversationMessage>? messages,
    List<String>? projectIds,
    Map<String, dynamic>? sessionMetadata,
  }) {
    return ConversationSession(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      messages: messages ?? this.messages,
      projectIds: projectIds ?? this.projectIds,
      sessionMetadata: sessionMetadata ?? this.sessionMetadata,
    );
  }
}
