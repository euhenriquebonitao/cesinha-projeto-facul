import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:challenge_vision/services/project_analytics_service.dart';
import 'package:challenge_vision/models/project.dart';

class ExpandingChartWidget extends StatefulWidget {
  final Project project;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const ExpandingChartWidget({
    super.key,
    required this.project,
    this.isExpanded = false,
    this.onToggle,
  });

  @override
  State<ExpandingChartWidget> createState() => _ExpandingChartWidgetState();
}

class _ExpandingChartWidgetState extends State<ExpandingChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _chartController;
  late Animation<double> _expandAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeInOut,
    );
    
    if (widget.isExpanded) {
      _expandController.forward();
      _chartController.forward();
    }
  }

  @override
  void didUpdateWidget(ExpandingChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expandController.forward();
        _chartController.forward();
      } else {
        _expandController.reverse();
        _chartController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              // Botão para expandir/contrair
              GestureDetector(
                onTap: widget.onToggle,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.isExpanded ? Icons.show_chart : Icons.trending_up,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Gráfico de Evolução',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.expand_more,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Conteúdo expandível
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
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
                  child: AnimatedBuilder(
                    animation: _chartAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _chartAnimation.value,
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * _chartAnimation.value),
                          child: _buildChartContent(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartContent() {
    final evolutionData = ProjectAnalyticsService.getProjectEvolutionHistory(widget.project);
    
    if (evolutionData.isEmpty) {
      return const Center(
        child: Text('Dados insuficientes para gerar gráfico'),
      );
    }

    return Column(
      children: [
        // Gráfico de linha principal
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 0.2,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < evolutionData.length) {
                        final date = evolutionData[value.toInt()].date;
                        return Text(
                          '${date.day}/${date.month}',
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.2,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value * 100).toInt()}%',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (evolutionData.length - 1).toDouble(),
              minY: 0,
              maxY: 1,
              lineBarsData: [
                LineChartBarData(
                  spots: evolutionData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.progress);
                  }).toList(),
                  isCurved: true,
                  color: _getProgressColor(),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: _getProgressColor(),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: _getProgressColor().withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Gráfico de barras para interações
        SizedBox(
          height: 120,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: evolutionData.map((e) => e.interactions.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < evolutionData.length) {
                        final date = evolutionData[value.toInt()].date;
                        return Text(
                          '${date.day}/${date.month}',
                          style: const TextStyle(fontSize: 8),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 8),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: evolutionData.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.interactions.toDouble(),
                      color: Colors.blue[400]!,
                      width: 8,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Estatísticas resumidas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('Progresso', '${(evolutionData.last.progress * 100).toInt()}%', Colors.green),
            _buildStatCard('Interações', '${evolutionData.last.interactions}', Colors.blue),
            _buildStatCard('Avaliação', '${evolutionData.last.rating.toStringAsFixed(1)}', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    switch (widget.project.status.toLowerCase()) {
      case 'pendente': return Colors.orange;
      case 'em andamento': return Colors.blue;
      case 'finalizado': return Colors.green;
      case 'cancelado': return Colors.red;
      default: return Colors.grey;
    }
  }
}
