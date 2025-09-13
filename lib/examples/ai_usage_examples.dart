import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/services/ai_knowledge_service.dart';
import 'package:challenge_vision/services/conversation_history_service.dart';
import 'package:challenge_vision/services/ai_prompt_service.dart';

/// Exemplos de uso do sistema de IA aprimorado
class AIUsageExamples {
  
  /// Exemplo 1: Análise de Riscos
  static Future<void> riskAnalysisExample() async {
    // Dados de exemplo
    final projects = _createSampleProjects();
    
    // Inicializar serviços
    await ConversationHistoryService.init();
    await ConversationHistoryService.startNewSession(
      title: 'Análise de Riscos - Exemplo',
      projects: projects,
    );
    
    // Simular pergunta do usuário
    final userQuestion = "Quais projetos estão em risco de atraso?";
    
    // Gerar prompt contextualizado
    final conversationContext = ConversationHistoryService.generateConversationContext();
    final prompt = AIPromptService.generateContextualPrompt(
      userQuestion: userQuestion,
      projects: projects,
      conversationHistory: conversationContext,
    );
    
    print("=== EXEMPLO 1: ANÁLISE DE RISCOS ===");
    print("Pergunta: $userQuestion");
    print("Prompt gerado: ${prompt.substring(0, 200)}...");
    
    // Simular resposta da IA
    final aiResponse = """
Com base na análise dos seus projetos, identifiquei os seguintes riscos:

🚨 PROJETOS EM RISCO CRÍTICO:
1. **Sistema de Gestão de Qualidade** - Data crítica em 15 dias
   - Risco: Atraso na implementação de módulos críticos
   - Mitigação: Alocar recursos adicionais e revisar cronograma

2. **Automação de Processos** - Data crítica em 20 dias
   - Risco: Dependências externas não resolvidas
   - Mitigação: Identificar fornecedores alternativos

📊 RECOMENDAÇÕES GERAIS:
- Implementar revisões semanais de progresso
- Estabelecer indicadores de alerta precoce
- Criar planos de contingência para projetos críticos
""";
    
    // Salvar no histórico
    await ConversationHistoryService.addMessage(
      role: 'user',
      content: userQuestion,
    );
    await ConversationHistoryService.addMessage(
      role: 'bot',
      content: aiResponse,
    );
    
    print("Resposta da IA: $aiResponse");
  }
  
  /// Exemplo 2: Recomendações Estratégicas
  static Future<void> strategicRecommendationsExample() async {
    final projects = _createSampleProjects();
    
    final userQuestion = "Como posso otimizar o portfólio de projetos?";
    
    final prompt = AIPromptService.generateContextualPrompt(
      userQuestion: userQuestion,
      projects: projects,
      conversationHistory: "",
    );
    
    print("\n=== EXEMPLO 2: RECOMENDAÇÕES ESTRATÉGICAS ===");
    print("Pergunta: $userQuestion");
    
    final aiResponse = """
🎯 ANÁLISE DO PORTFÓLIO ATUAL:

DISTRIBUIÇÃO POR CATEGORIA:
- Inovação: 40% (4 projetos) - Excelente para crescimento futuro
- Desenvolvimento: 30% (3 projetos) - Bom equilíbrio
- Pesquisa: 20% (2 projetos) - Pode ser expandido
- Melhoria: 10% (1 projeto) - Necessita mais atenção

🚀 RECOMENDAÇÕES ESTRATÉGICAS:

1. **DIVERSIFICAÇÃO TECNOLÓGICA**
   - Padronizar uso de Flutter para apps internos
   - Investir em capacitação em Python para análise de dados
   - Considerar React para dashboards web

2. **BALANCEAMENTO DE RECURSOS**
   - Redistribuir 20% dos recursos de Inovação para Melhoria
   - Criar equipe dedicada para projetos de Pesquisa
   - Implementar metodologia ágil em todos os projetos

3. **OTIMIZAÇÃO DE CRONOGRAMAS**
   - Sincronizar projetos relacionados
   - Estabelecer marcos compartilhados
   - Implementar gestão de dependências

4. **MÉTRICAS DE SUCESSO**
   - ROI por categoria de projeto
   - Time-to-market para projetos de Inovação
   - Taxa de conclusão dentro do prazo
""";
    
    print("Resposta da IA: $aiResponse");
  }
  
  /// Exemplo 3: Análise de Tecnologias
  static Future<void> technologyAnalysisExample() async {
    final projects = _createSampleProjects();
    
    final userQuestion = "Quais tecnologias devemos priorizar?";
    
    print("\n=== EXEMPLO 3: ANÁLISE DE TECNOLOGIAS ===");
    print("Pergunta: $userQuestion");
    
    final aiResponse = """
🔧 ANÁLISE TECNOLÓGICA ATUAL:

TECNOLOGIAS EM USO:
- Flutter: 4 projetos (40%) - Forte presença
- Python: 3 projetos (30%) - Crescimento consistente
- React: 2 projetos (20%) - Estável
- Java: 1 projeto (10%) - Legado

📈 RECOMENDAÇÕES DE PRIORIZAÇÃO:

1. **FLUTTER - PRIORIDADE ALTA**
   - Vantagens: Desenvolvimento rápido, multiplataforma
   - Ação: Padronizar para todos os apps internos
   - ROI: Alto - reduz tempo de desenvolvimento em 40%

2. **PYTHON - PRIORIDADE ALTA**
   - Vantagens: Análise de dados, automação, IA/ML
   - Ação: Investir em capacitação da equipe
   - ROI: Médio-Alto - melhora eficiência operacional

3. **REACT - PRIORIDADE MÉDIA**
   - Vantagens: Dashboards web, ferramentas internas
   - Ação: Manter para projetos web específicos
   - ROI: Médio - complementa Flutter

4. **JAVA - PRIORIDADE BAIXA**
   - Vantagens: Sistemas legados
   - Ação: Migração gradual para tecnologias modernas
   - ROI: Baixo - manutenção de sistemas antigos

🎯 ESTRATÉGIA TECNOLÓGICA:
- Foco em Flutter + Python como stack principal
- React para casos específicos de web
- Plano de migração gradual do Java
- Investimento em capacitação contínua
""";
    
    print("Resposta da IA: $aiResponse");
  }
  
  /// Exemplo 4: Insights de Conversação
  static Future<void> conversationInsightsExample() async {
    print("\n=== EXEMPLO 4: INSIGHTS DE CONVERSAÇÃO ===");
    
    // Simular várias conversas
    await ConversationHistoryService.init();
    
    // Sessão 1
    await ConversationHistoryService.startNewSession(
      title: 'Análise de Riscos',
      projects: _createSampleProjects(),
    );
    await ConversationHistoryService.addMessage(role: 'user', content: 'Quais projetos estão em risco?');
    await ConversationHistoryService.addMessage(role: 'bot', content: 'Identifiquei 3 projetos em risco...');
    await ConversationHistoryService.endCurrentSession();
    
    // Sessão 2
    await ConversationHistoryService.startNewSession(
      title: 'Recomendações Tecnológicas',
      projects: _createSampleProjects(),
    );
    await ConversationHistoryService.addMessage(role: 'user', content: 'Quais tecnologias priorizar?');
    await ConversationHistoryService.addMessage(role: 'bot', content: 'Recomendo Flutter e Python...');
    await ConversationHistoryService.endCurrentSession();
    
    // Sessão 3
    await ConversationHistoryService.startNewSession(
      title: 'Otimização de Portfólio',
      projects: _createSampleProjects(),
    );
    await ConversationHistoryService.addMessage(role: 'user', content: 'Como otimizar o portfólio?');
    await ConversationHistoryService.addMessage(role: 'bot', content: 'Sugiro rebalancear recursos...');
    await ConversationHistoryService.endCurrentSession();
    
    // Gerar insights
    final insights = ConversationHistoryService.generateConversationInsights();
    
    print("📊 INSIGHTS DE CONVERSAÇÃO:");
    print("Total de sessões: ${insights['totalSessions']}");
    print("Total de mensagens: ${insights['totalMessages']}");
    print("Média por sessão: ${insights['averageSessionLength']}");
    print("Nível de engajamento: ${insights['userEngagement']}");
    
    print("\n🔥 TÓPICOS MAIS DISCUTIDOS:");
    for (final topic in insights['commonTopics']) {
      print("- ${topic['topic']}: ${topic['count']} menções");
    }
    
    print("\n⭐ PROJETOS MAIS MENCIONADOS:");
    for (final project in insights['mostDiscussedProjects']) {
      print("- Projeto ${project['projectId']}: ${project['mentionCount']} menções");
    }
  }
  
  /// Exemplo 5: Uso da Base de Conhecimento
  static void knowledgeBaseExample() {
    print("\n=== EXEMPLO 5: BASE DE CONHECIMENTO ===");
    
    // Obter informações sobre categorias
    final innovationInfo = AIKnowledgeService.getCategoryInfo('Inovação');
    print("📋 INFORMAÇÕES SOBRE INOVAÇÃO:");
    print("Descrição: ${innovationInfo?['description']}");
    print("Duração típica: ${innovationInfo?['typical_duration']}");
    print("Métricas-chave: ${innovationInfo?['key_metrics'].join(', ')}");
    
    // Obter informações sobre status
    final statusInfo = AIKnowledgeService.getStatusInfo('Em Andamento');
    print("\n📊 INFORMAÇÕES SOBRE STATUS 'EM ANDAMENTO':");
    print("Descrição: ${statusInfo?['description']}");
    print("Próximas ações: ${statusInfo?['next_actions'].join(', ')}");
    print("Sinais de alerta: ${statusInfo?['warning_signs'].join(', ')}");
    
    // Obter informações sobre tecnologia
    final techInfo = AIKnowledgeService.getTechnologyInfo('Flutter');
    print("\n🔧 INFORMAÇÕES SOBRE FLUTTER:");
    print("Descrição: ${techInfo?['description']}");
    print("Casos de uso: ${techInfo?['use_cases'].join(', ')}");
    print("Nível de expertise: ${techInfo?['expertise_level']}");
  }
  
  /// Executar todos os exemplos
  static Future<void> runAllExamples() async {
    print("🚀 EXECUTANDO EXEMPLOS DO SISTEMA DE IA APRIMORADO\n");
    
    await riskAnalysisExample();
    await strategicRecommendationsExample();
    await technologyAnalysisExample();
    await conversationInsightsExample();
    knowledgeBaseExample();
    
    print("\n✅ TODOS OS EXEMPLOS EXECUTADOS COM SUCESSO!");
  }
  
  /// Criar projetos de exemplo
  static List<Project> _createSampleProjects() {
    return [
      Project(
        id: '1',
        name: 'Sistema de Gestão de Qualidade',
        category: 'Inovação',
        unit: 'TI',
        status: 'Em Andamento',
        responsibleArea: 'Qualidade',
        responsiblePerson: 'João Silva',
        technology: 'Flutter',
        description: 'Sistema para gestão de processos de qualidade',
        estimatedCompletionDate: DateTime.now().add(const Duration(days: 30)),
        criticalDate: DateTime.now().add(const Duration(days: 15)),
        rating: 4.5,
        interactions: 25,
        isFavorited: true,
      ),
      Project(
        id: '2',
        name: 'Automação de Processos',
        category: 'Desenvolvimento',
        unit: 'Produção',
        status: 'Em Andamento',
        responsibleArea: 'Operações',
        responsiblePerson: 'Maria Santos',
        technology: 'Python',
        description: 'Automação de processos produtivos',
        estimatedCompletionDate: DateTime.now().add(const Duration(days: 45)),
        criticalDate: DateTime.now().add(const Duration(days: 20)),
        rating: 4.2,
        interactions: 18,
        isFavorited: false,
      ),
      Project(
        id: '3',
        name: 'Dashboard de Analytics',
        category: 'Inovação',
        unit: 'TI',
        status: 'Finalizado',
        responsibleArea: 'Business Intelligence',
        responsiblePerson: 'Pedro Costa',
        technology: 'React',
        description: 'Dashboard para análise de dados',
        estimatedCompletionDate: DateTime.now().subtract(const Duration(days: 10)),
        criticalDate: DateTime.now().subtract(const Duration(days: 5)),
        rating: 4.8,
        interactions: 32,
        isFavorited: true,
      ),
      Project(
        id: '4',
        name: 'Pesquisa de Novos Compostos',
        category: 'Pesquisa',
        unit: 'P&D',
        status: 'Em Andamento',
        responsibleArea: 'Pesquisa',
        responsiblePerson: 'Ana Lima',
        technology: 'Python',
        description: 'Pesquisa de novos compostos farmacêuticos',
        estimatedCompletionDate: DateTime.now().add(const Duration(days: 90)),
        criticalDate: DateTime.now().add(const Duration(days: 60)),
        rating: 4.0,
        interactions: 15,
        isFavorited: false,
      ),
      Project(
        id: '5',
        name: 'Otimização de Linha de Produção',
        category: 'Melhoria',
        unit: 'Produção',
        status: 'Pendente',
        responsibleArea: 'Operações',
        responsiblePerson: 'Carlos Oliveira',
        technology: 'Java',
        description: 'Otimização da linha de produção principal',
        estimatedCompletionDate: DateTime.now().add(const Duration(days: 60)),
        criticalDate: DateTime.now().add(const Duration(days: 45)),
        rating: 3.8,
        interactions: 8,
        isFavorited: false,
      ),
    ];
  }
}
