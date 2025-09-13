import 'package:challenge_vision/models/project.dart';
import 'dart:math';

class ProjectAnalyticsService {
  static final Random _random = Random();

  // Dados históricos de evolução de um projeto
  static List<ProjectEvolutionData> getProjectEvolutionHistory(Project project) {
    final now = DateTime.now();
    final createdAt = project.createdAt ?? now;
    final daysSinceCreation = now.difference(createdAt).inDays;
    
    List<ProjectEvolutionData> history = [];
    
    // Simular dados históricos baseados no tempo de criação
    for (int i = 0; i <= daysSinceCreation; i++) {
      final date = createdAt.add(Duration(days: i));
      final progress = _calculateHistoricalProgress(project, i, daysSinceCreation);
      final interactions = _calculateHistoricalInteractions(project, i, daysSinceCreation);
      final rating = _calculateHistoricalRating(project, i, daysSinceCreation);
      
      history.add(ProjectEvolutionData(
        date: date,
        progress: progress,
        interactions: interactions,
        rating: rating,
        status: _getHistoricalStatus(project, i, daysSinceCreation),
      ));
    }
    
    return history;
  }

  // Calcula o progresso histórico baseado no tempo e alterações
  static double _calculateHistoricalProgress(Project project, int day, int totalDays) {
    if (totalDays == 0) return 0.1;
    
    final progressRatio = day / totalDays;
    final currentProgress = _getCurrentProgress(project);
    
    // Adicionar variação baseada em alterações (interações, edições, etc.)
    final changeMultiplier = _getChangeMultiplier(project, day);
    
    // Interpolação suave do progresso com crescimento baseado em alterações
    final baseProgress = (progressRatio * currentProgress);
    final growthFactor = 1.0 + (changeMultiplier * 0.3); // Até 30% de crescimento
    
    return (baseProgress * growthFactor).clamp(0.0, 1.0);
  }

  // Calcula interações históricas com crescimento dinâmico
  static int _calculateHistoricalInteractions(Project project, int day, int totalDays) {
    if (totalDays == 0) return 0;
    
    final interactionRatio = day / totalDays;
    final currentInteractions = project.interactions;
    
    // Adicionar crescimento baseado em alterações
    final changeMultiplier = _getChangeMultiplier(project, day);
    final growthFactor = 1.0 + (changeMultiplier * 0.5); // Até 50% de crescimento
    
    return ((interactionRatio * currentInteractions) * growthFactor).round();
  }

  // Calcula rating histórico
  static double _calculateHistoricalRating(Project project, int day, int totalDays) {
    if (totalDays == 0) return 3.0;
    
    final ratingRatio = day / totalDays;
    final currentRating = project.rating;
    final startRating = 3.0;
    
    return (startRating + (ratingRatio * (currentRating - startRating))).clamp(1.0, 5.0);
  }

  // Obtém status histórico
  static String _getHistoricalStatus(Project project, int day, int totalDays) {
    if (totalDays == 0) return 'Pendente';
    
    final progressRatio = day / totalDays;
    final currentProgress = _getCurrentProgress(project);
    
    if (progressRatio < 0.2) return 'Pendente';
    if (progressRatio < 0.8) return 'Em Andamento';
    return 'Finalizado';
  }

  // Obtém progresso atual baseado no status
  static double _getCurrentProgress(Project project) {
    switch (project.status.toLowerCase()) {
      case 'pendente': return 0.1;
      case 'em andamento': return 0.6;
      case 'finalizado': return 1.0;
      case 'cancelado': return 0.0;
      default: return 0.3;
    }
  }

  // Calcula multiplicador de crescimento baseado em alterações do projeto
  static double _getChangeMultiplier(Project project, int day) {
    // Baseado em diferentes fatores que indicam atividade/alterações
    double multiplier = 0.0;
    
    // Fator 1: Número de interações (mais interações = mais alterações)
    final interactionFactor = (project.interactions / 10.0).clamp(0.0, 1.0);
    multiplier += interactionFactor * 0.4;
    
    // Fator 2: Status do projeto (projetos em andamento têm mais alterações)
    final statusFactor = _getStatusActivityFactor(project.status);
    multiplier += statusFactor * 0.3;
    
    // Fator 3: Variação baseada no dia (simula picos de atividade)
    final dayVariation = (sin(day * 0.1) + 1) / 2; // Variação senoidal entre 0 e 1
    multiplier += dayVariation * 0.2;
    
    // Fator 4: Rating do projeto (projetos bem avaliados tendem a ter mais atividade)
    final ratingFactor = (project.rating - 1.0) / 4.0; // Normalizar de 1-5 para 0-1
    multiplier += ratingFactor * 0.1;
    
    return multiplier.clamp(0.0, 1.0);
  }

  // Fator de atividade baseado no status
  static double _getStatusActivityFactor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente': return 0.2;
      case 'em andamento': return 0.8;
      case 'finalizado': return 0.1;
      case 'cancelado': return 0.0;
      default: return 0.3;
    }
  }

  // Dados de evolução de todos os projetos
  static Map<String, List<ProjectEvolutionData>> getAllProjectsEvolution(List<Project> projects) {
    Map<String, List<ProjectEvolutionData>> allData = {};
    
    for (final project in projects) {
      allData[project.id] = getProjectEvolutionHistory(project);
    }
    
    return allData;
  }

  // Estatísticas gerais de evolução
  static ProjectAnalyticsStats getAnalyticsStats(List<Project> projects) {
    if (projects.isEmpty) {
      return ProjectAnalyticsStats(
        totalProjects: 0,
        averageProgress: 0.0,
        averageRating: 0.0,
        totalInteractions: 0,
        completionRate: 0.0,
        statusDistribution: {},
        trendData: [],
      );
    }

    double totalProgress = 0.0;
    double totalRating = 0.0;
    int totalInteractions = 0;
    int completedProjects = 0;
    Map<String, int> statusDistribution = {};
    List<TrendDataPoint> trendData = [];

    for (final project in projects) {
      final progress = _getCurrentProgress(project);
      totalProgress += progress;
      totalRating += project.rating;
      totalInteractions += project.interactions;
      
      if (project.status.toLowerCase() == 'finalizado') {
        completedProjects++;
      }
      
      statusDistribution[project.status] = (statusDistribution[project.status] ?? 0) + 1;
    }

    // Gerar dados de tendência (últimos 30 dias)
    final now = DateTime.now();
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final projectsOnDate = projects.where((p) {
        final createdAt = p.createdAt ?? now;
        return createdAt.isBefore(date) || createdAt.isAtSameMomentAs(date);
      }).length;
      
      trendData.add(TrendDataPoint(
        date: date,
        value: projectsOnDate.toDouble(),
        label: 'Projetos Ativos',
      ));
    }

    return ProjectAnalyticsStats(
      totalProjects: projects.length,
      averageProgress: totalProgress / projects.length,
      averageRating: totalRating / projects.length,
      totalInteractions: totalInteractions,
      completionRate: completedProjects / projects.length,
      statusDistribution: statusDistribution,
      trendData: trendData,
    );
  }
}

// Classe para dados de evolução de um projeto
class ProjectEvolutionData {
  final DateTime date;
  final double progress;
  final int interactions;
  final double rating;
  final String status;

  ProjectEvolutionData({
    required this.date,
    required this.progress,
    required this.interactions,
    required this.rating,
    required this.status,
  });
}

// Classe para estatísticas gerais
class ProjectAnalyticsStats {
  final int totalProjects;
  final double averageProgress;
  final double averageRating;
  final int totalInteractions;
  final double completionRate;
  final Map<String, int> statusDistribution;
  final List<TrendDataPoint> trendData;

  ProjectAnalyticsStats({
    required this.totalProjects,
    required this.averageProgress,
    required this.averageRating,
    required this.totalInteractions,
    required this.completionRate,
    required this.statusDistribution,
    required this.trendData,
  });
}

// Classe para dados de tendência
class TrendDataPoint {
  final DateTime date;
  final double value;
  final String label;

  TrendDataPoint({
    required this.date,
    required this.value,
    required this.label,
  });
}
