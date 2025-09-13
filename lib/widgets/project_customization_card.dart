import 'package:flutter/material.dart';
import 'package:challenge_vision/models/project.dart';

class ProjectCustomizationCard extends StatelessWidget {
  final Project project;
  final bool isSelected;
  final VoidCallback onTap;

  const ProjectCustomizationCard({
    super.key,
    required this.project,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'inovação':
        return Icons.lightbulb; // Lâmpada para inovação
      case 'pesquisa':
        return Icons.science; // Ciência para pesquisa
      case 'desenvolvimento':
        return Icons.code; // Código para desenvolvimento
      case 'melhoria':
        return Icons.trending_up; // Tendência de alta para melhoria
      default:
        return Icons.work; // Ícone padrão de trabalho
    }
  }

  Color _getStatusColor() {
    switch (project.status.toLowerCase()) {
      case 'pendente':
        return Colors.orange;
      case 'em andamento':
        return Colors.blue;
      case 'finalizado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected 
                ? [Colors.grey[600]!, Colors.grey[700]!, Colors.grey[800]!]
                : [Colors.grey[800]!, Colors.grey[900]!, Colors.black],
          ),
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
              ? Border.all(color: Colors.grey[400]!, width: 2)
              : Border.all(color: Colors.grey[600]!.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? Colors.grey.withOpacity(0.4)
                  : Colors.black.withOpacity(0.2),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo circular com ícone da categoria
              Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isSelected 
                          ? [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]
                          : [Colors.grey[600]!, Colors.grey[700]!],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(project.category),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Categoria
              Center(
                child: Text(
                  project.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 4),

              // Nome do projeto
              Center(
                child: Text(
                  project.name,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

              // Container com informações
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Rating e interações
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              project.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.touch_app, color: Colors.purple, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${project.interactions}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getStatusColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            project.status,
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Botão Escolher Projeto
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected 
                          ? [Colors.red[400]!, Colors.red[600]!]
                          : [Colors.green[400]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected ? Colors.red : Colors.green).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? Icons.close : Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSelected ? 'Selecionado' : 'Escolher Projeto',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
