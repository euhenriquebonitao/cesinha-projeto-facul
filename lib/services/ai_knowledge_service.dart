import 'dart:convert';
import 'package:challenge_vision/models/project.dart';

/// Serviço responsável por gerenciar e estruturar o conhecimento da IA
class AIKnowledgeService {
  static const String _knowledgeBaseVersion = "1.0.0";
  
  /// Base de conhecimento sobre a Eurofarma
  static const Map<String, dynamic> _eurofarmaKnowledge = {
    "company": {
      "name": "Eurofarma",
      "industry": "Farmacêutica",
      "focus": "Desenvolvimento, produção e comercialização de medicamentos",
      "values": [
        "Inovação",
        "Qualidade",
        "Acessibilidade",
        "Sustentabilidade",
        "Excelência operacional"
      ],
      "departments": [
        "P&D (Pesquisa e Desenvolvimento)",
        "Produção",
        "Qualidade",
        "Regulatório",
        "Comercial",
        "Marketing",
        "TI",
        "RH",
        "Financeiro"
      ]
    },
    "project_categories": {
      "Inovação": {
        "description": "Projetos focados em desenvolvimento de novos produtos, tecnologias ou processos inovadores",
        "typical_duration": "6-24 meses",
        "key_metrics": ["ROI", "Time to Market", "Patent Applications"],
        "stakeholders": ["P&D", "Regulatório", "Marketing"]
      },
      "Pesquisa": {
        "description": "Projetos de pesquisa científica, estudos clínicos e investigação de novos compostos",
        "typical_duration": "12-36 meses",
        "key_metrics": ["Success Rate", "Publication Count", "Clinical Trial Results"],
        "stakeholders": ["P&D", "Regulatório", "Clinical Affairs"]
      },
      "Desenvolvimento": {
        "description": "Projetos de desenvolvimento de produtos, melhorias de processos e otimizações",
        "typical_duration": "3-12 meses",
        "key_metrics": ["Cost Reduction", "Efficiency Gain", "Quality Improvement"],
        "stakeholders": ["Produção", "Qualidade", "TI"]
      },
      "Melhoria": {
        "description": "Projetos de melhoria contínua, otimização de processos e implementação de boas práticas",
        "typical_duration": "1-6 meses",
        "key_metrics": ["Process Efficiency", "Cost Savings", "Quality Metrics"],
        "stakeholders": ["Produção", "Qualidade", "Operações"]
      }
    },
    "project_status": {
      "Em Andamento": {
        "description": "Projeto ativo e em desenvolvimento",
        "next_actions": ["Monitoramento de progresso", "Gestão de riscos", "Comunicação com stakeholders"],
        "warning_signs": ["Atrasos frequentes", "Mudanças de escopo", "Problemas de recursos"]
      },
      "Finalizado": {
        "description": "Projeto concluído com sucesso",
        "next_actions": ["Documentação final", "Lições aprendidas", "Celebração da equipe"],
        "success_indicators": ["Objetivos atingidos", "Prazo respeitado", "Qualidade mantida"]
      },
      "Pendente": {
        "description": "Projeto aguardando aprovação ou recursos",
        "next_actions": ["Aprovação de budget", "Alocação de recursos", "Definição de cronograma"],
        "blockers": ["Aprovação gerencial", "Recursos financeiros", "Recursos humanos"]
      },
      "Cancelado": {
        "description": "Projeto interrompido por questões estratégicas ou técnicas",
        "next_actions": ["Documentação de motivos", "Lições aprendidas", "Redistribuição de recursos"],
        "common_reasons": ["Mudança estratégica", "Problemas técnicos", "Restrições regulatórias"]
      }
    },
    "technologies": {
      "Flutter": {
        "description": "Framework para desenvolvimento de aplicações móveis",
        "use_cases": ["Apps internos", "Ferramentas de produtividade", "Dashboards"],
        "expertise_level": "Alto"
      },
      "Firebase": {
        "description": "Plataforma de desenvolvimento de aplicações",
        "use_cases": ["Autenticação", "Banco de dados", "Analytics"],
        "expertise_level": "Médio"
      },
      "Python": {
        "description": "Linguagem de programação para análise de dados e automação",
        "use_cases": ["Data Science", "Automação", "Machine Learning"],
        "expertise_level": "Alto"
      },
      "React": {
        "description": "Biblioteca JavaScript para interfaces de usuário",
        "use_cases": ["Dashboards web", "Ferramentas internas", "Portais"],
        "expertise_level": "Médio"
      }
    },
    "best_practices": {
      "project_management": [
        "Definir objetivos claros e mensuráveis",
        "Estabelecer cronograma realista com marcos",
        "Identificar e gerenciar riscos proativamente",
        "Manter comunicação regular com stakeholders",
        "Documentar decisões e mudanças",
        "Realizar revisões periódicas de progresso"
      ],
      "risk_management": [
        "Identificar riscos técnicos, financeiros e regulatórios",
        "Avaliar probabilidade e impacto de cada risco",
        "Desenvolver planos de mitigação",
        "Monitorar indicadores de risco",
        "Ter planos de contingência prontos"
      ],
      "quality_assurance": [
        "Definir critérios de qualidade desde o início",
        "Implementar testes em todas as fases",
        "Documentar processos e procedimentos",
        "Realizar revisões de código e design",
        "Validar com usuários finais"
      ]
    }
  };

  /// Gera contexto enriquecido para a IA baseado nos projetos
  static String generateEnrichedContext(List<Project> projects) {
    final context = StringBuffer();
    
    // Informações da empresa
    context.writeln("=== CONTEXTO DA EMPRESA ===");
    context.writeln("Empresa: ${_eurofarmaKnowledge['company']['name']}");
    context.writeln("Setor: ${_eurofarmaKnowledge['company']['industry']}");
    context.writeln("Foco: ${_eurofarmaKnowledge['company']['focus']}");
    context.writeln("Valores: ${_eurofarmaKnowledge['company']['values'].join(', ')}");
    context.writeln();
    
    // Análise dos projetos
    context.writeln("=== ANÁLISE DOS PROJETOS ATUAIS ===");
    context.writeln("Total de projetos: ${projects.length}");
    
    // Estatísticas por categoria
    final categoryStats = <String, int>{};
    final statusStats = <String, int>{};
    final technologyStats = <String, int>{};
    
    for (final project in projects) {
      categoryStats[project.category] = (categoryStats[project.category] ?? 0) + 1;
      statusStats[project.status] = (statusStats[project.status] ?? 0) + 1;
      technologyStats[project.technology] = (technologyStats[project.technology] ?? 0) + 1;
    }
    
    context.writeln("Distribuição por categoria:");
    categoryStats.forEach((category, count) {
      final percentage = ((count / projects.length) * 100).toStringAsFixed(1);
      context.writeln("- $category: $count projetos ($percentage%)");
    });
    
    context.writeln("\nDistribuição por status:");
    statusStats.forEach((status, count) {
      final percentage = ((count / projects.length) * 100).toStringAsFixed(1);
      context.writeln("- $status: $count projetos ($percentage%)");
    });
    
    context.writeln("\nTecnologias mais utilizadas:");
    technologyStats.forEach((tech, count) {
      final percentage = ((count / projects.length) * 100).toStringAsFixed(1);
      context.writeln("- $tech: $count projetos ($percentage%)");
    });
    
    // Projetos em risco
    final now = DateTime.now();
    final projectsAtRisk = projects.where((p) => 
      p.criticalDate.isBefore(now.add(const Duration(days: 30))) && 
      p.status == "Em Andamento"
    ).toList();
    
    if (projectsAtRisk.isNotEmpty) {
      context.writeln("\n⚠️ PROJETOS EM RISCO (data crítica próxima):");
      for (final project in projectsAtRisk) {
        final daysUntilCritical = project.criticalDate.difference(now).inDays;
        context.writeln("- ${project.name}: ${daysUntilCritical} dias restantes");
      }
    }
    
    // Projetos favoritos
    final favoriteProjects = projects.where((p) => p.isFavorited).toList();
    if (favoriteProjects.isNotEmpty) {
      context.writeln("\n⭐ PROJETOS FAVORITOS:");
      for (final project in favoriteProjects) {
        context.writeln("- ${project.name} (${project.category})");
      }
    }
    
    context.writeln();
    
    // Regras de negócio
    context.writeln("=== REGRAS DE NEGÓCIO E MELHORES PRÁTICAS ===");
    context.writeln("Boas práticas de gestão de projetos:");
    for (final practice in _eurofarmaKnowledge['best_practices']['project_management']) {
      context.writeln("- $practice");
    }
    
    context.writeln("\nGestão de riscos:");
    for (final practice in _eurofarmaKnowledge['best_practices']['risk_management']) {
      context.writeln("- $practice");
    }
    
    context.writeln();
    
    // Dados detalhados dos projetos
    context.writeln("=== DADOS DETALHADOS DOS PROJETOS ===");
    for (final project in projects) {
      context.writeln("Projeto: ${project.name}");
      context.writeln("- Categoria: ${project.category}");
      context.writeln("- Status: ${project.status}");
      context.writeln("- Responsável: ${project.responsiblePerson} (${project.responsibleArea})");
      context.writeln("- Tecnologia: ${project.technology}");
      context.writeln("- Data estimada: ${project.estimatedCompletionDate.day}/${project.estimatedCompletionDate.month}/${project.estimatedCompletionDate.year}");
      context.writeln("- Data crítica: ${project.criticalDate.day}/${project.criticalDate.month}/${project.criticalDate.year}");
      context.writeln("- Descrição: ${project.description}");
      context.writeln("- Avaliação: ${project.rating}/5.0");
      context.writeln("- Interações: ${project.interactions}");
      context.writeln("- Favorito: ${project.isFavorited ? 'Sim' : 'Não'}");
      context.writeln();
    }
    
    return context.toString();
  }
  
  /// Gera prompt específico baseado no tipo de pergunta
  static String generateSpecificPrompt(String userQuestion, List<Project> projects) {
    final question = userQuestion.toLowerCase();
    
    if (question.contains('risco') || question.contains('crítico') || question.contains('atraso')) {
      return _generateRiskAnalysisPrompt(projects);
    } else if (question.contains('categoria') || question.contains('tipo')) {
      return _generateCategoryAnalysisPrompt(projects);
    } else if (question.contains('tecnologia') || question.contains('tech')) {
      return _generateTechnologyAnalysisPrompt(projects);
    } else if (question.contains('status') || question.contains('andamento')) {
      return _generateStatusAnalysisPrompt(projects);
    } else if (question.contains('recomendação') || question.contains('sugestão')) {
      return _generateRecommendationPrompt(projects);
    } else {
      return _generateGeneralPrompt(projects);
    }
  }
  
  static String _generateRiskAnalysisPrompt(List<Project> projects) {
    return """
Você é um especialista em gestão de riscos de projetos farmacêuticos. 
Analise os projetos fornecidos e identifique:
1. Projetos em risco de atraso
2. Possíveis causas de atraso
3. Recomendações de mitigação
4. Ações preventivas
5. Indicadores de alerta precoce

Baseie-se nas melhores práticas da indústria farmacêutica e nas regras de negócio da Eurofarma.
""";
  }
  
  static String _generateCategoryAnalysisPrompt(List<Project> projects) {
    return """
Você é um consultor especializado em categorização de projetos farmacêuticos.
Analise a distribuição de projetos por categoria e forneça:
1. Insights sobre o portfólio de projetos
2. Recomendações de balanceamento
3. Oportunidades de sinergia entre categorias
4. Estratégias de otimização por categoria
5. Métricas de sucesso específicas por categoria

Considere as características únicas de cada categoria na Eurofarma.
""";
  }
  
  static String _generateTechnologyAnalysisPrompt(List<Project> projects) {
    return """
Você é um especialista em tecnologia farmacêutica e transformação digital.
Analise o uso de tecnologias nos projetos e forneça:
1. Análise de maturidade tecnológica
2. Oportunidades de padronização
3. Recomendações de tecnologias emergentes
4. Estratégias de capacitação técnica
5. ROI esperado de investimentos tecnológicos

Considere as necessidades específicas da indústria farmacêutica.
""";
  }
  
  static String _generateStatusAnalysisPrompt(List<Project> projects) {
    return """
Você é um especialista em gestão de projetos farmacêuticos.
Analise o status dos projetos e forneça:
1. Análise de progresso geral
2. Identificação de gargalos
3. Recomendações de aceleração
4. Estratégias de recuperação para projetos atrasados
5. Melhores práticas para manutenção de cronograma

Baseie-se nas metodologias ágeis adaptadas para a indústria farmacêutica.
""";
  }
  
  static String _generateRecommendationPrompt(List<Project> projects) {
    return """
Você é um consultor sênior em gestão de projetos farmacêuticos.
Com base na análise dos projetos, forneça:
1. Recomendações estratégicas
2. Oportunidades de melhoria
3. Priorizações sugeridas
4. Estratégias de otimização de recursos
5. Roadmap de implementação

Considere os objetivos estratégicos da Eurofarma e as tendências da indústria.
""";
  }
  
  static String _generateGeneralPrompt(List<Project> projects) {
    return """
Você é o ChallengeBot, assistente inteligente especializado em gestão de projetos farmacêuticos da Eurofarma.
Seu papel é:
1. Fornecer insights baseados em dados dos projetos
2. Sugerir melhorias e otimizações
3. Identificar riscos e oportunidades
4. Apoiar decisões estratégicas
5. Compartilhar melhores práticas da indústria

Seja sempre:
- Preciso e baseado em dados
- Prático e acionável
- Alinhado com os valores da Eurofarma
- Focado em resultados mensuráveis
- Proativo na identificação de problemas

Use o contexto fornecido sobre os projetos e as regras de negócio da empresa.
""";
  }
  
  /// Obtém informações sobre uma categoria específica
  static Map<String, dynamic>? getCategoryInfo(String category) {
    return _eurofarmaKnowledge['project_categories'][category];
  }
  
  /// Obtém informações sobre um status específico
  static Map<String, dynamic>? getStatusInfo(String status) {
    return _eurofarmaKnowledge['project_status'][status];
  }
  
  /// Obtém informações sobre uma tecnologia específica
  static Map<String, dynamic>? getTechnologyInfo(String technology) {
    return _eurofarmaKnowledge['technologies'][technology];
  }
  
  /// Versão da base de conhecimento
  static String get knowledgeBaseVersion => _knowledgeBaseVersion;
}
