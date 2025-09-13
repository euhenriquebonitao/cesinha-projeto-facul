

import 'package:flutter/material.dart';
import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/screens/project_details_screen.dart';
import 'package:challenge_vision/widgets/expanding_chart_widget.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  // Using the isFavorited from the Project model directly
  bool _isChartExpanded = false;

  void _toggleFavorite() {
    setState(() {
      widget.project.isFavorited =
          !widget.project.isFavorited; // Update the model directly
      print(
        'Favorite status toggled for ${widget.project.name}: ${widget.project.isFavorited}',
      );
    });
  }

  void _viewMore() {
    print('View more details for project: ${widget.project.name}');
    // Navigate to project detail screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(
          project: widget.project,
        ),
      ),
    );
  }

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

  // Calcula o progresso baseado no status do projeto
  double _getProgressPercentage() {
    switch (widget.project.status.toLowerCase()) {
      case 'pendente':
        return 0.1; // 10% - Projeto iniciado
      case 'em andamento':
        return 0.6; // 60% - Projeto em desenvolvimento
      case 'finalizado':
        return 1.0; // 100% - Projeto concluído
      case 'cancelado':
        return 0.0; // 0% - Projeto cancelado
      default:
        return 0.3; // 30% - Status desconhecido
    }
  }

  // Calcula a cor da barra de progresso baseada no status
  Color _getProgressColor() {
    switch (widget.project.status.toLowerCase()) {
      case 'pendente':
        return Colors.orange; // Laranja para pendente
      case 'em andamento':
        return Colors.blue; // Azul para em andamento
      case 'finalizado':
        return Colors.green; // Verde para finalizado
      case 'cancelado':
        return Colors.red; // Vermelho para cancelado
      default:
        return Colors.grey; // Cinza para status desconhecido
    }
  }

  // Calcula a probabilidade de expansão baseada no progresso
  double _getExpansionProbability() {
    final progress = _getProgressPercentage();
    // Probabilidade aumenta conforme o progresso
    // 0% = 5% chance, 50% = 30% chance, 100% = 60% chance
    return 0.05 + (progress * 0.55);
  }

  // Gera um indicador visual de probabilidade de expansão
  String _getExpansionIndicator() {
    final probability = _getExpansionProbability();
    if (probability < 0.2) {
      return '🟡'; // Baixa probabilidade
    } else if (probability < 0.4) {
      return '🟠'; // Média probabilidade
    } else {
      return '🟢'; // Alta probabilidade
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detectar se é desktop baseado na largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;
    
    // Calcular largura responsiva
    double cardWidth;
    if (isDesktop) {
      cardWidth = 350; // Largura fixa para desktop
    } else if (isTablet) {
      cardWidth = screenWidth * 0.6; // 60% da tela para tablet
    } else {
      cardWidth = screenWidth * 0.8; // 80% da tela para mobile
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: cardWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[800]!,
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com favorito e badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'NOVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      widget.project.isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.project.isFavorited
                          ? Colors.red
                          : Colors.grey[600],
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Ícone do projeto baseado na categoria
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[600]!,
                      Colors.grey[700]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(widget.project.category),
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Informações do projeto
            Center(
              child: Column(
                children: [
                  Text(
                    widget.project.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.project.name,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Informações adicionais enriquecidas
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[800]?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[600]!.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.business, widget.project.unit, Colors.blue),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, widget.project.responsiblePerson, Colors.green),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.engineering, widget.project.technology, Colors.orange),
                ],
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Status com indicador visual
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getProgressColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getProgressColor(),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getProgressColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.project.status,
                    style: TextStyle(
                      color: _getProgressColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Rating e interações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard(
                  Icons.star,
                  '${widget.project.rating.toStringAsFixed(1)}',
                  'Rating',
                  Colors.amber,
                ),
                _buildMetricCard(
                  Icons.touch_app,
                  '${widget.project.interactions}',
                  'Interações',
                  Colors.purple,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Descrição resumida do projeto
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[800]!.withOpacity(0.8),
                    Colors.grey[700]!.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[600]!.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Descrição',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.project.description.length > 100 
                        ? '${widget.project.description.substring(0, 100)}...'
                        : widget.project.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Barra de progresso dinâmica
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[800]?.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[600]!.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicador de probabilidade de expansão
                  Row(
                    children: [
                      Text(
                        _getExpansionIndicator(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Expansão: ${(_getExpansionProbability() * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Barra de progresso
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _getProgressPercentage(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getProgressColor(),
                              _getProgressColor().withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Texto de progresso
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(_getProgressPercentage() * 100).toInt()}% concluído',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${widget.project.interactions} interações',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Informações de prazo e área responsável
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[900]!.withOpacity(0.8),
                    Colors.grey[800]!.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[600]!.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today, 'Conclusão: ${widget.project.estimatedCompletionDate.day}/${widget.project.estimatedCompletionDate.month}/${widget.project.estimatedCompletionDate.year}', Colors.blue),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.business_center, 'Área: ${widget.project.responsibleArea}', Colors.green),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Botão Veja mais
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _viewMore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(0, 48),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[600]!,
                        Colors.grey[700]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.visibility,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ver Detalhes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Gráfico expandível
            ExpandingChartWidget(
              project: widget.project,
              isExpanded: _isChartExpanded,
              onToggle: () {
                setState(() {
                  _isChartExpanded = !_isChartExpanded;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
