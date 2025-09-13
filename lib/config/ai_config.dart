/// Configurações para o sistema de IA do ChallengeBot
class AIConfig {
  
  // Configurações da API
  static const String geminiApiKey = "AIzaSyB9utH-MH3Smsdrs6tj3R3tUUiyqHXai30";
  static const String geminiModel = "gemini-1.5-flash-latest";
  static const String geminiApiUrl = "https://generativelanguage.googleapis.com/v1beta/models";
  
  // Configurações de contexto
  static const int maxContextLength = 8000; // Máximo de caracteres no contexto
  static const int maxProjectsInContext = 50; // Máximo de projetos no contexto
  static const int maxConversationHistory = 10; // Máximo de conversas no histórico
  
  // Configurações de sessão
  static const int maxSessionsStored = 50; // Máximo de sessões salvas
  static const int maxMessagesPerSession = 100; // Máximo de mensagens por sessão
  static const int sessionTimeoutMinutes = 30; // Timeout da sessão em minutos
  
  // Configurações de resposta
  static const int maxResponseLength = 2000; // Máximo de caracteres na resposta
  static const int responseTimeoutSeconds = 30; // Timeout da resposta em segundos
  
  // Configurações de análise
  static const List<String> riskKeywords = [
    'risco', 'problema', 'atraso', 'crítico', 'urgente', 'emergência'
  ];
  
  static const List<String> recommendationKeywords = [
    'recomendação', 'sugestão', 'como melhorar', 'otimizar', 'melhorar'
  ];
  
  static const List<String> statusKeywords = [
    'status', 'progresso', 'andamento', 'situação', 'estado'
  ];
  
  static const List<String> technologyKeywords = [
    'tecnologia', 'tech', 'ferramenta', 'software', 'sistema'
  ];
  
  // Configurações da Eurofarma
  static const String companyName = "Eurofarma";
  static const String companyIndustry = "Farmacêutica";
  static const String companyFocus = "Desenvolvimento, produção e comercialização de medicamentos";
  
  static const List<String> companyValues = [
    "Inovação",
    "Qualidade", 
    "Acessibilidade",
    "Sustentabilidade",
    "Excelência operacional"
  ];
  
  static const List<String> companyDepartments = [
    "P&D (Pesquisa e Desenvolvimento)",
    "Produção",
    "Qualidade",
    "Regulatório",
    "Comercial",
    "Marketing",
    "TI",
    "RH",
    "Financeiro"
  ];
  
  // Configurações de categorias de projetos
  static const Map<String, Map<String, dynamic>> projectCategories = {
    "Inovação": {
      "description": "Projetos focados em desenvolvimento de novos produtos, tecnologias ou processos inovadores",
      "typical_duration": "6-24 meses",
      "key_metrics": ["ROI", "Time to Market", "Patent Applications"],
      "stakeholders": ["P&D", "Regulatório", "Marketing"],
      "priority": "high"
    },
    "Pesquisa": {
      "description": "Projetos de pesquisa científica, estudos clínicos e investigação de novos compostos",
      "typical_duration": "12-36 meses", 
      "key_metrics": ["Success Rate", "Publication Count", "Clinical Trial Results"],
      "stakeholders": ["P&D", "Regulatório", "Clinical Affairs"],
      "priority": "high"
    },
    "Desenvolvimento": {
      "description": "Projetos de desenvolvimento de produtos, melhorias de processos e otimizações",
      "typical_duration": "3-12 meses",
      "key_metrics": ["Cost Reduction", "Efficiency Gain", "Quality Improvement"],
      "stakeholders": ["Produção", "Qualidade", "TI"],
      "priority": "medium"
    },
    "Melhoria": {
      "description": "Projetos de melhoria contínua, otimização de processos e implementação de boas práticas",
      "typical_duration": "1-6 meses",
      "key_metrics": ["Process Efficiency", "Cost Savings", "Quality Metrics"],
      "stakeholders": ["Produção", "Qualidade", "Operações"],
      "priority": "medium"
    }
  };
  
  // Configurações de status de projetos
  static const Map<String, Map<String, dynamic>> projectStatus = {
    "Em Andamento": {
      "description": "Projeto ativo e em desenvolvimento",
      "next_actions": ["Monitoramento de progresso", "Gestão de riscos", "Comunicação com stakeholders"],
      "warning_signs": ["Atrasos frequentes", "Mudanças de escopo", "Problemas de recursos"],
      "color": "blue",
      "priority": "active"
    },
    "Finalizado": {
      "description": "Projeto concluído com sucesso",
      "next_actions": ["Documentação final", "Lições aprendidas", "Celebração da equipe"],
      "success_indicators": ["Objetivos atingidos", "Prazo respeitado", "Qualidade mantida"],
      "color": "green",
      "priority": "completed"
    },
    "Pendente": {
      "description": "Projeto aguardando aprovação ou recursos",
      "next_actions": ["Aprovação de budget", "Alocação de recursos", "Definição de cronograma"],
      "blockers": ["Aprovação gerencial", "Recursos financeiros", "Recursos humanos"],
      "color": "orange",
      "priority": "waiting"
    },
    "Cancelado": {
      "description": "Projeto interrompido por questões estratégicas ou técnicas",
      "next_actions": ["Documentação de motivos", "Lições aprendidas", "Redistribuição de recursos"],
      "common_reasons": ["Mudança estratégica", "Problemas técnicos", "Restrições regulatórias"],
      "color": "red",
      "priority": "cancelled"
    }
  };
  
  // Configurações de tecnologias
  static const Map<String, Map<String, dynamic>> technologies = {
    "Flutter": {
      "description": "Framework para desenvolvimento de aplicações móveis",
      "use_cases": ["Apps internos", "Ferramentas de produtividade", "Dashboards"],
      "expertise_level": "Alto",
      "recommended_for": ["Apps móveis", "Prototipagem rápida", "Desenvolvimento multiplataforma"],
      "learning_curve": "Média"
    },
    "Firebase": {
      "description": "Plataforma de desenvolvimento de aplicações",
      "use_cases": ["Autenticação", "Banco de dados", "Analytics"],
      "expertise_level": "Médio",
      "recommended_for": ["Backend rápido", "Autenticação", "Analytics"],
      "learning_curve": "Baixa"
    },
    "Python": {
      "description": "Linguagem de programação para análise de dados e automação",
      "use_cases": ["Data Science", "Automação", "Machine Learning"],
      "expertise_level": "Alto",
      "recommended_for": ["Análise de dados", "Automação", "IA/ML"],
      "learning_curve": "Baixa"
    },
    "React": {
      "description": "Biblioteca JavaScript para interfaces de usuário",
      "use_cases": ["Dashboards web", "Ferramentas internas", "Portais"],
      "expertise_level": "Médio",
      "recommended_for": ["Interfaces web", "Dashboards", "SPAs"],
      "learning_curve": "Média"
    },
    "Java": {
      "description": "Linguagem de programação para sistemas enterprise",
      "use_cases": ["Sistemas legados", "Backend enterprise", "Integrações"],
      "expertise_level": "Alto",
      "recommended_for": ["Sistemas críticos", "Backend robusto", "Integrações"],
      "learning_curve": "Alta"
    }
  };
  
  // Configurações de melhores práticas
  static const Map<String, List<String>> bestPractices = {
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
    ],
    "team_management": [
      "Definir papéis e responsabilidades claramente",
      "Estabelecer canais de comunicação eficazes",
      "Promover colaboração e conhecimento compartilhado",
      "Reconhecer e recompensar contribuições",
      "Investir em capacitação contínua"
    ]
  };
  
  // Configurações de métricas
  static const Map<String, List<String>> keyMetrics = {
    "innovation": ["ROI", "Time to Market", "Patent Applications", "New Product Revenue"],
    "research": ["Success Rate", "Publication Count", "Clinical Trial Results", "Regulatory Approvals"],
    "development": ["Cost Reduction", "Efficiency Gain", "Quality Improvement", "Customer Satisfaction"],
    "improvement": ["Process Efficiency", "Cost Savings", "Quality Metrics", "Employee Satisfaction"]
  };
  
  // Configurações de alertas
  static const Map<String, dynamic> alertSettings = {
    "critical_date_threshold": 30, // Dias antes da data crítica para alertar
    "low_rating_threshold": 3.0, // Rating abaixo do qual alertar
    "high_interaction_threshold": 50, // Interações acima do qual destacar
    "stale_project_days": 90, // Dias sem atividade para considerar projeto inativo
  };
  
  // Configurações de personalização
  static const Map<String, dynamic> personalization = {
    "enable_learning": true, // Habilitar aprendizado com conversas
    "enable_insights": true, // Habilitar geração de insights
    "enable_recommendations": true, // Habilitar recomendações automáticas
    "enable_alerts": true, // Habilitar alertas proativos
    "language": "pt-BR", // Idioma das respostas
    "tone": "professional", // Tom das respostas (professional, friendly, technical)
  };
  
  // Métodos utilitários
  static bool isRiskKeyword(String text) {
    final lowerText = text.toLowerCase();
    return riskKeywords.any((keyword) => lowerText.contains(keyword));
  }
  
  static bool isRecommendationKeyword(String text) {
    final lowerText = text.toLowerCase();
    return recommendationKeywords.any((keyword) => lowerText.contains(keyword));
  }
  
  static bool isStatusKeyword(String text) {
    final lowerText = text.toLowerCase();
    return statusKeywords.any((keyword) => lowerText.contains(keyword));
  }
  
  static bool isTechnologyKeyword(String text) {
    final lowerText = text.toLowerCase();
    return technologyKeywords.any((keyword) => lowerText.contains(keyword));
  }
  
  static String getCategoryPriority(String category) {
    return projectCategories[category]?['priority'] ?? 'low';
  }
  
  static String getStatusColor(String status) {
    return projectStatus[status]?['color'] ?? 'grey';
  }
  
  static List<String> getCategoryMetrics(String category) {
    return List<String>.from(projectCategories[category]?['key_metrics'] ?? []);
  }
  
  static List<String> getBestPractices(String type) {
    return List<String>.from(bestPractices[type] ?? []);
  }
}
