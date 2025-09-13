import 'dart:math';
import 'package:challenge_vision/models/project.dart';

class ProjectEvolutionService {
  static final Random _random = Random();

  // Simula a evolução de um projeto baseada no tempo e probabilidades
  static Project evolveProject(Project project) {
    final now = DateTime.now();
    final daysSinceCreation = now.difference(project.createdAt ?? now).inDays;
    
    // Probabilidade de evolução baseada no tempo e status atual
    final evolutionChance = _calculateEvolutionChance(project, daysSinceCreation);
    
    if (_random.nextDouble() < evolutionChance) {
      return _applyEvolution(project);
    }
    
    return project;
  }

  // Calcula a chance de evolução baseada no status e tempo
  static double _calculateEvolutionChance(Project project, int daysSinceCreation) {
    double baseChance = 0.0;
    
    switch (project.status.toLowerCase()) {
      case 'pendente':
        // Projetos pendentes têm 20% de chance por dia de evoluir
        baseChance = 0.20;
        break;
      case 'em andamento':
        // Projetos em andamento têm 15% de chance por dia de evoluir
        baseChance = 0.15;
        break;
      case 'finalizado':
        // Projetos finalizados não evoluem mais
        return 0.0;
      case 'cancelado':
        // Projetos cancelados têm 5% de chance de ser reativados
        baseChance = 0.05;
        break;
      default:
        baseChance = 0.10;
    }
    
    // Aumenta a chance com o tempo (projetos antigos têm mais chance de evoluir)
    final timeMultiplier = 1.0 + (daysSinceCreation * 0.01);
    
    return (baseChance * timeMultiplier).clamp(0.0, 0.8); // Máximo 80%
  }

  // Aplica a evolução ao projeto
  static Project _applyEvolution(Project project) {
    final newProject = Project(
      id: project.id,
      name: project.name,
      category: project.category,
      status: _getNextStatus(project.status),
      responsibleArea: project.responsibleArea,
      responsiblePerson: project.responsiblePerson,
      technology: project.technology,
      unit: project.unit,
      description: project.description,
      estimatedCompletionDate: project.estimatedCompletionDate,
      criticalDate: project.criticalDate,
      rating: _calculateNewRating(project),
      interactions: project.interactions + 1, // Incrementa interações
      isNew: false,
      isFavorited: project.isFavorited,
      createdAt: project.createdAt,
      updatedAt: DateTime.now(),
    );
    
    return newProject;
  }

  // Determina o próximo status na evolução
  static String _getNextStatus(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pendente':
        return 'Em Andamento';
      case 'em andamento':
        // 70% chance de finalizar, 30% chance de continuar em andamento
        return _random.nextDouble() < 0.7 ? 'Finalizado' : 'Em Andamento';
      case 'finalizado':
        return 'Finalizado'; // Não muda mais
      case 'cancelado':
        // 50% chance de ser reativado como pendente
        return _random.nextDouble() < 0.5 ? 'Pendente' : 'Cancelado';
      default:
        return 'Em Andamento';
    }
  }

  // Calcula nova avaliação baseada na evolução
  static double _calculateNewRating(Project project) {
    final currentRating = project.rating;
    final variation = (_random.nextDouble() - 0.5) * 0.5; // Variação de -0.25 a +0.25
    final newRating = (currentRating + variation).clamp(1.0, 5.0);
    return double.parse(newRating.toStringAsFixed(1));
  }

  // Simula a evolução de uma lista de projetos
  static List<Project> evolveProjects(List<Project> projects) {
    return projects.map((project) => evolveProject(project)).toList();
  }

  // Calcula estatísticas de evolução
  static Map<String, dynamic> getEvolutionStats(List<Project> projects) {
    final totalProjects = projects.length;
    final statusCounts = <String, int>{};
    final avgRating = projects.fold(0.0, (sum, p) => sum + p.rating) / totalProjects;
    final totalInteractions = projects.fold(0, (sum, p) => sum + p.interactions);
    
    for (final project in projects) {
      statusCounts[project.status] = (statusCounts[project.status] ?? 0) + 1;
    }
    
    return {
      'totalProjects': totalProjects,
      'statusCounts': statusCounts,
      'averageRating': avgRating,
      'totalInteractions': totalInteractions,
      'completionRate': (statusCounts['Finalizado'] ?? 0) / totalProjects,
    };
  }
}
