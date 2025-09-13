import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:challenge_vision/services/project_analytics_service.dart';
import 'package:challenge_vision/models/project.dart';

class ProjectAnalyticsDashboard extends StatefulWidget {
  final List<Project> projects;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const ProjectAnalyticsDashboard({
    super.key,
    required this.projects,
    this.isExpanded = false,
    this.onToggle,
  });

  @override
  State<ProjectAnalyticsDashboard> createState() => _ProjectAnalyticsDashboardState();
}

class _ProjectAnalyticsDashboardState extends State<ProjectAnalyticsDashboard>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _chartController;
  late Animation<double> _expandAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
  void didUpdateWidget(ProjectAnalyticsDashboard oldWidget) {
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
    final stats = ProjectAnalyticsService.getAnalyticsStats(widget.projects);
    
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              // Cabeçalho do dashboard
              GestureDetector(
                onTap: widget.onToggle,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.analytics,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard de Análises',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${widget.projects.length} projetos • ${(stats.completionRate * 100).toInt()}% concluídos',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.expand_more,
                          color: Colors.white,
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
                          scale: 0.9 + (0.1 * _chartAnimation.value),
                          child: _buildDashboardContent(stats),
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

  Widget _buildDashboardContent(ProjectAnalyticsStats stats) {
    return Column(
      children: [
        // Cards de estatísticas principais
        Row(
          children: [
            Expanded(child: _buildStatCard('Total', '${stats.totalProjects}', Colors.blue, Icons.work)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatCard('Progresso', '${(stats.averageProgress * 100).toInt()}%', Colors.green, Icons.trending_up)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatCard('Avaliação', '${stats.averageRating.toStringAsFixed(1)}', Colors.orange, Icons.star)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatCard('Interações', '${stats.totalInteractions}', Colors.purple, Icons.touch_app)),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Gráfico de pizza - Distribuição por status
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _buildPieChartSections(stats.statusDistribution),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildLegend(stats.statusDistribution),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Gráfico de linha - Tendência de projetos
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
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
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < stats.trendData.length) {
                        final date = stats.trendData[value.toInt()].date;
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
                    interval: 1,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (stats.trendData.length - 1).toDouble(),
              minY: 0,
              maxY: stats.trendData.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: stats.trendData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.value);
                  }).toList(),
                  isCurved: true,
                  color: Colors.blue[600]!,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Colors.blue[600]!,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Texto explicativo
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Os gráficos se expandem automaticamente conforme os projetos evoluem e novos dados são adicionados.',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
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

  List<PieChartSectionData> _buildPieChartSections(Map<String, int> statusDistribution) {
    final colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.red[400]!,
      Colors.purple[400]!,
    ];
    
    int colorIndex = 0;
    return statusDistribution.entries.map((entry) {
      final percentage = (entry.value / widget.projects.length) * 100;
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, int> statusDistribution) {
    final colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.red[400]!,
      Colors.purple[400]!,
    ];
    
    int colorIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statusDistribution.entries.map((entry) {
        final color = colors[colorIndex % colors.length];
        colorIndex++;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${entry.value}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
