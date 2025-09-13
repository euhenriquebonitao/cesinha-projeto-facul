import 'package:flutter/material.dart';
import 'package:challenge_vision/services/conversation_history_service.dart';
import 'package:challenge_vision/models/project.dart';

/// Widget para exibir insights e estatísticas da IA
class AIInsightsPanel extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback? onRefresh;

  const AIInsightsPanel({
    super.key,
    required this.projects,
    this.onRefresh,
  });

  @override
  State<AIInsightsPanel> createState() => _AIInsightsPanelState();
}

class _AIInsightsPanelState extends State<AIInsightsPanel> {
  Map<String, dynamic>? _insights;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() {
      _loading = true;
    });

    try {
      final insights = ConversationHistoryService.generateConversationInsights();
      setState(() {
        _insights = insights;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_insights == null) {
      return const Center(
        child: Text('Erro ao carregar insights'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Insights da IA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _loadInsights();
                  widget.onRefresh?.call();
                },
                tooltip: 'Atualizar insights',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Estatísticas gerais
          _buildStatCard(
            'Sessões de Conversa',
            '${_insights!['totalSessions']}',
            Icons.chat,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          
          _buildStatCard(
            'Total de Mensagens',
            '${_insights!['totalMessages']}',
            Icons.message,
            Colors.green,
          ),
          const SizedBox(height: 12),
          
          _buildStatCard(
            'Média por Sessão',
            '${_insights!['averageSessionLength']} mensagens',
            Icons.trending_up,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          
          // Nível de engajamento
          _buildEngagementCard(),
          const SizedBox(height: 16),
          
          // Tópicos mais discutidos
          if (_insights!['commonTopics'].isNotEmpty) ...[
            const Text(
              'Tópicos Mais Discutidos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...(_insights!['commonTopics'] as List).map((topic) => 
              _buildTopicItem(topic['topic'], topic['count'])
            ).toList(),
            const SizedBox(height: 16),
          ],
          
          // Projetos mais discutidos
          if (_insights!['mostDiscussedProjects'].isNotEmpty) ...[
            const Text(
              'Projetos Mais Discutidos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...(_insights!['mostDiscussedProjects'] as List).map((project) => 
              _buildProjectItem(project['projectId'], project['mentionCount'])
            ).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementCard() {
    final engagement = _insights!['userEngagement'] as String;
    Color color;
    String text;
    IconData icon;

    switch (engagement) {
      case 'high':
        color = Colors.green;
        text = 'Alto Engajamento';
        icon = Icons.trending_up;
        break;
      case 'medium':
        color = Colors.orange;
        text = 'Médio Engajamento';
        icon = Icons.trending_flat;
        break;
      default:
        color = Colors.red;
        text = 'Baixo Engajamento';
        icon = Icons.trending_down;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nível de Engajamento',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(String topic, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              topic,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(String projectId, int mentionCount) {
    // Buscar o projeto pelo ID
    final project = widget.projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => Project(
        id: projectId,
        name: 'Projeto não encontrado',
        category: '',
        unit: '',
        status: '',
        responsibleArea: '',
        responsiblePerson: '',
        technology: '',
        description: '',
        estimatedCompletionDate: DateTime.now(),
        criticalDate: DateTime.now(),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  project.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$mentionCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
