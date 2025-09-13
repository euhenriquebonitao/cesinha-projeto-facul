import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/services/ai_knowledge_service.dart';

/// Serviço para gerenciar templates de prompts avançados para a IA
class AIPromptService {
  
  /// Gera um prompt personalizado baseado no contexto e tipo de pergunta
  static String generateContextualPrompt({
    required String userQuestion,
    required List<Project> projects,
    required String conversationHistory,
    Map<String, dynamic>? additionalContext,
  }) {
    final questionType = _analyzeQuestionType(userQuestion);
    final projectContext = _analyzeProjectContext(userQuestion, projects);
    final urgency = _analyzeUrgency(userQuestion);
    
    return _buildPrompt(
      questionType: questionType,
      projectContext: projectContext,
      urgency: urgency,
      userQuestion: userQuestion,
      projects: projects,
      conversationHistory: conversationHistory,
      additionalContext: additionalContext,
    );
  }

  /// Analisa o tipo de pergunta do usuário
  static QuestionType _analyzeQuestionType(String question) {
    final lowerQuestion = question.toLowerCase();
    
    if (lowerQuestion.contains('risco') || lowerQuestion.contains('problema') || lowerQuestion.contains('atraso')) {
      return QuestionType.riskAnalysis;
    } else if (lowerQuestion.contains('recomendação') || lowerQuestion.contains('sugestão') || lowerQuestion.contains('como melhorar')) {
      return QuestionType.recommendation;
    } else if (lowerQuestion.contains('status') || lowerQuestion.contains('progresso') || lowerQuestion.contains('andamento')) {
      return QuestionType.statusUpdate;
    } else if (lowerQuestion.contains('categoria') || lowerQuestion.contains('tipo') || lowerQuestion.contains('classificação')) {
      return QuestionType.categorization;
    } else if (lowerQuestion.contains('tecnologia') || lowerQuestion.contains('tech') || lowerQuestion.contains('ferramenta')) {
      return QuestionType.technology;
    } else if (lowerQuestion.contains('prazo') || lowerQuestion.contains('cronograma') || lowerQuestion.contains('data')) {
      return QuestionType.timeline;
    } else if (lowerQuestion.contains('recursos') || lowerQuestion.contains('orçamento') || lowerQuestion.contains('custo')) {
      return QuestionType.resources;
    } else if (lowerQuestion.contains('equipe') || lowerQuestion.contains('responsável') || lowerQuestion.contains('pessoa')) {
      return QuestionType.team;
    } else if (lowerQuestion.contains('análise') || lowerQuestion.contains('insight') || lowerQuestion.contains('estatística')) {
      return QuestionType.analytics;
    } else {
      return QuestionType.general;
    }
  }

  /// Analisa o contexto dos projetos mencionados na pergunta
  static ProjectContext _analyzeProjectContext(String question, List<Project> projects) {
    final lowerQuestion = question.toLowerCase();
    final mentionedProjects = <Project>[];
    
    for (final project in projects) {
      if (lowerQuestion.contains(project.name.toLowerCase()) ||
          lowerQuestion.contains(project.category.toLowerCase()) ||
          lowerQuestion.contains(project.technology.toLowerCase())) {
        mentionedProjects.add(project);
      }
    }
    
    if (mentionedProjects.isEmpty) {
      return ProjectContext.allProjects;
    } else if (mentionedProjects.length == 1) {
      return ProjectContext.singleProject;
    } else {
      return ProjectContext.multipleProjects;
    }
  }

  /// Analisa a urgência da pergunta
  static UrgencyLevel _analyzeUrgency(String question) {
    final lowerQuestion = question.toLowerCase();
    
    if (lowerQuestion.contains('urgente') || lowerQuestion.contains('crítico') || lowerQuestion.contains('emergência')) {
      return UrgencyLevel.critical;
    } else if (lowerQuestion.contains('importante') || lowerQuestion.contains('prioridade') || lowerQuestion.contains('rápido')) {
      return UrgencyLevel.high;
    } else if (lowerQuestion.contains('quando') || lowerQuestion.contains('quanto tempo') || lowerQuestion.contains('prazo')) {
      return UrgencyLevel.medium;
    } else {
      return UrgencyLevel.low;
    }
  }

  /// Constrói o prompt final baseado na análise
  static String _buildPrompt({
    required QuestionType questionType,
    required ProjectContext projectContext,
    required UrgencyLevel urgency,
    required String userQuestion,
    required List<Project> projects,
    required String conversationHistory,
    Map<String, dynamic>? additionalContext,
  }) {
    final buffer = StringBuffer();
    
    // Cabeçalho do prompt
    buffer.writeln("=== CHALLENGEBOT - ASSISTENTE ESPECIALIZADO EM GESTÃO DE PROJETOS FARMACÊUTICOS ===");
    buffer.writeln("Empresa: Eurofarma");
    buffer.writeln("Versão da Base de Conhecimento: ${AIKnowledgeService.knowledgeBaseVersion}");
    buffer.writeln("Data/Hora: ${DateTime.now().toIso8601String()}");
    buffer.writeln();
    
    // Contexto de urgência
    buffer.writeln("=== NÍVEL DE URGÊNCIA ===");
    switch (urgency) {
      case UrgencyLevel.critical:
        buffer.writeln("🚨 CRÍTICO: Esta pergunta requer atenção imediata e resposta prioritária.");
        break;
      case UrgencyLevel.high:
        buffer.writeln("⚠️ ALTA PRIORIDADE: Esta pergunta é importante e deve ser respondida com foco.");
        break;
      case UrgencyLevel.medium:
        buffer.writeln("📋 MÉDIA PRIORIDADE: Esta pergunta tem prazo definido e deve ser bem estruturada.");
        break;
      case UrgencyLevel.low:
        buffer.writeln("ℹ️ BAIXA PRIORIDADE: Esta pergunta pode ser respondida de forma mais detalhada.");
        break;
    }
    buffer.writeln();
    
    // Instruções específicas por tipo de pergunta
    buffer.writeln("=== INSTRUÇÕES ESPECÍFICAS ===");
    buffer.writeln(_getQuestionTypeInstructions(questionType));
    buffer.writeln();
    
    // Contexto dos projetos
    buffer.writeln("=== CONTEXTO DOS PROJETOS ===");
    buffer.writeln(_getProjectContextInstructions(projectContext, projects));
    buffer.writeln();
    
    // Histórico de conversas
    if (conversationHistory.isNotEmpty) {
      buffer.writeln("=== HISTÓRICO DE CONVERSAS ===");
      buffer.writeln(conversationHistory);
      buffer.writeln();
    }
    
    // Dados enriquecidos dos projetos
    buffer.writeln("=== DADOS ENRIQUECIDOS DOS PROJETOS ===");
    buffer.writeln(AIKnowledgeService.generateEnrichedContext(projects));
    buffer.writeln();
    
    // Contexto adicional
    if (additionalContext != null && additionalContext.isNotEmpty) {
      buffer.writeln("=== CONTEXTO ADICIONAL ===");
      additionalContext.forEach((key, value) {
        buffer.writeln("$key: $value");
      });
      buffer.writeln();
    }
    
    // Instruções finais
    buffer.writeln("=== INSTRUÇÕES FINAIS ===");
    buffer.writeln("1. Responda de forma clara, objetiva e acionável");
    buffer.writeln("2. Use dados específicos dos projetos quando relevante");
    buffer.writeln("3. Forneça recomendações práticas baseadas nas melhores práticas da Eurofarma");
    buffer.writeln("4. Seja proativo em identificar riscos e oportunidades");
    buffer.writeln("5. Mantenha o foco nos objetivos estratégicos da empresa");
    buffer.writeln("6. Use linguagem profissional mas acessível");
    buffer.writeln();
    
    // Pergunta do usuário
    buffer.writeln("=== PERGUNTA DO USUÁRIO ===");
    buffer.writeln(userQuestion);
    
    return buffer.toString();
  }

  /// Obtém instruções específicas baseadas no tipo de pergunta
  static String _getQuestionTypeInstructions(QuestionType type) {
    switch (type) {
      case QuestionType.riskAnalysis:
        return """
Foque em:
- Identificar riscos específicos nos projetos mencionados
- Avaliar probabilidade e impacto de cada risco
- Propor planos de mitigação concretos
- Sugerir indicadores de monitoramento
- Alertar sobre riscos críticos que requerem ação imediata
""";
      case QuestionType.recommendation:
        return """
Foque em:
- Fornecer recomendações específicas e acionáveis
- Justificar cada recomendação com dados dos projetos
- Priorizar recomendações por impacto e facilidade de implementação
- Sugerir cronograma de implementação
- Identificar recursos necessários
""";
      case QuestionType.statusUpdate:
        return """
Foque em:
- Analisar o status atual dos projetos
- Identificar projetos em atraso ou com problemas
- Sugerir ações para acelerar projetos lentos
- Destacar projetos que estão indo bem
- Propor melhorias no acompanhamento
""";
      case QuestionType.categorization:
        return """
Foque em:
- Analisar a distribuição de projetos por categoria
- Identificar desequilíbrios no portfólio
- Sugerir reclassificações se necessário
- Propor estratégias por categoria
- Destacar sinergias entre categorias
""";
      case QuestionType.technology:
        return """
Foque em:
- Analisar o uso de tecnologias nos projetos
- Identificar oportunidades de padronização
- Sugerir tecnologias emergentes relevantes
- Avaliar maturidade tecnológica
- Propor estratégias de capacitação
""";
      case QuestionType.timeline:
        return """
Foque em:
- Analisar cronogramas e prazos
- Identificar projetos em risco de atraso
- Sugerir otimizações de cronograma
- Propor marcos intermediários
- Alertar sobre dependências críticas
""";
      case QuestionType.resources:
        return """
Foque em:
- Analisar alocação de recursos
- Identificar gargalos de recursos
- Sugerir otimizações de orçamento
- Propor redistribuição de recursos
- Avaliar ROI dos investimentos
""";
      case QuestionType.team:
        return """
Foque em:
- Analisar composição das equipes
- Identificar gaps de competências
- Sugerir treinamentos necessários
- Propor reorganizações de equipe
- Destacar líderes de projeto
""";
      case QuestionType.analytics:
        return """
Foque em:
- Fornecer insights baseados em dados
- Identificar tendências e padrões
- Sugerir métricas de acompanhamento
- Propor dashboards e relatórios
- Destacar oportunidades de melhoria
""";
      case QuestionType.general:
        return """
Foque em:
- Fornecer uma resposta abrangente e útil
- Conectar a pergunta aos dados dos projetos
- Oferecer insights adicionais relevantes
- Sugerir próximos passos
- Manter o foco nos objetivos da Eurofarma
""";
    }
  }

  /// Obtém instruções baseadas no contexto dos projetos
  static String _getProjectContextInstructions(ProjectContext context, List<Project> projects) {
    switch (context) {
      case ProjectContext.allProjects:
        return """
Contexto: Análise de todos os ${projects.length} projetos do portfólio.
- Considere o portfólio como um todo
- Identifique padrões e tendências gerais
- Forneça insights estratégicos
- Sugira otimizações globais
""";
      case ProjectContext.singleProject:
        return """
Contexto: Foco em um projeto específico mencionado na pergunta.
- Analise detalhadamente o projeto específico
- Forneça insights profundos sobre este projeto
- Sugira melhorias específicas
- Identifique riscos e oportunidades particulares
""";
      case ProjectContext.multipleProjects:
        return """
Contexto: Análise de múltiplos projetos mencionados na pergunta.
- Compare os projetos mencionados
- Identifique similaridades e diferenças
- Sugira sinergias entre os projetos
- Proponha estratégias coordenadas
""";
    }
  }

  /// Gera prompt para análise de tendências
  static String generateTrendAnalysisPrompt(List<Project> projects) {
    return """
Você é um analista sênior especializado em tendências de projetos farmacêuticos.

Analise os seguintes aspectos dos projetos fornecidos:
1. Tendências por categoria ao longo do tempo
2. Padrões de uso de tecnologias
3. Distribuição de status e sua evolução
4. Correlações entre variáveis (categoria vs. tecnologia, status vs. prazo, etc.)
5. Identificação de outliers e projetos excepcionais
6. Previsões baseadas em tendências atuais

Forneça insights acionáveis e recomendações estratégicas baseadas na análise de tendências.
""";
  }

  /// Gera prompt para análise de performance
  static String generatePerformanceAnalysisPrompt(List<Project> projects) {
    return """
Você é um especialista em análise de performance de projetos farmacêuticos.

Analise os seguintes indicadores de performance:
1. Taxa de conclusão por categoria
2. Tempo médio de execução por tipo de projeto
3. Eficiência de uso de tecnologias
4. Performance por área responsável
5. Correlação entre rating e outros indicadores
6. Identificação de projetos de alta performance

Forneça recomendações para replicar sucessos e melhorar performance geral.
""";
  }
}

/// Enum para tipos de pergunta
enum QuestionType {
  riskAnalysis,
  recommendation,
  statusUpdate,
  categorization,
  technology,
  timeline,
  resources,
  team,
  analytics,
  general,
}

/// Enum para contexto dos projetos
enum ProjectContext {
  allProjects,
  singleProject,
  multipleProjects,
}

/// Enum para nível de urgência
enum UrgencyLevel {
  critical,
  high,
  medium,
  low,
}
