import 'package:flutter/material.dart';
import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/widgets/expanding_chart_widget.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          children: [
            const Text(
              'Detalhes do projeto',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.bar_chart,
                color: Colors.black,
                size: 16,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Card de Insights do ChallengeMind
            _buildChallengeMindInsights(),
            const SizedBox(height: 24),

            // Visão Geral do Projeto
            _buildProjectOverview(),
            const SizedBox(height: 24),

            // Descrição Geral
            _buildGeneralDescription(),
            const SizedBox(height: 24),

            // Etapas do Projeto
            _buildProjectSteps(),
            const SizedBox(height: 24),

            // Prazos
            _buildDeadlines(),
            const SizedBox(height: 24),

            // Informações Adicionais
            _buildAdditionalInfo(),
            const SizedBox(height: 24),

            // Gráfico de Evolução do Projeto
            _buildProjectEvolutionChart(),
            const SizedBox(height: 32),

            // Botão Voltar
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeMindInsights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ChallengeMind Insights',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _generateProjectInsight(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.science,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Projeto: ${widget.project.name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Status', widget.project.status, Icons.flag),
          _buildInfoRow('Área responsável', widget.project.responsibleArea, Icons.business),
          _buildInfoRow('Responsável', widget.project.responsiblePerson, Icons.person),
          _buildInfoRow('Tecnologia', widget.project.technology, Icons.engineering),
          _buildInfoRow('Unidade', widget.project.unit, Icons.location_on),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descrição Geral:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.project.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSteps() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status do Projeto:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusItem(widget.project.status),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String status) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status.toLowerCase()) {
      case 'em andamento':
        statusColor = Colors.orange;
        statusIcon = Icons.play_circle;
        break;
      case 'finalizado':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pendente':
        statusColor = Colors.yellow[700]!;
        statusIcon = Icons.pause_circle;
        break;
      case 'cancelado':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          statusIcon,
          color: statusColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prazos:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildDeadlineItem(
            'Data estimada para conclusão',
            '${widget.project.estimatedCompletionDate.day}/${widget.project.estimatedCompletionDate.month}/${widget.project.estimatedCompletionDate.year}',
            Icons.calendar_today,
            Colors.blue,
          ),
          _buildDeadlineItem(
            'Data crítica',
            '${widget.project.criticalDate.day}/${widget.project.criticalDate.month}/${widget.project.criticalDate.year}',
            Icons.warning,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String label, String date, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações Adicionais:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Categoria', widget.project.category, Icons.category),
          _buildInfoRow('ID do Projeto', widget.project.id, Icons.fingerprint),
          _buildInfoRow('Projeto Novo', widget.project.isNew ? 'Sim' : 'Não', Icons.new_releases),
          _buildInfoRow('Favoritado', widget.project.isFavorited ? 'Sim' : 'Não', Icons.favorite),
          if (widget.project.ownerUserId != null)
            _buildInfoRow('Proprietário', widget.project.ownerUserId!, Icons.person_pin),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Voltar aos Projetos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectEvolutionChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Evolução do Projeto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Este gráfico mostra como o projeto evoluiu ao longo do tempo, crescendo com cada alteração e interação.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Widget de gráfico expandível
          ExpandingChartWidget(
            project: widget.project,
            isExpanded: true, // Sempre expandido na tela de detalhes
          ),
        ],
      ),
    );
  }

  String _generateProjectInsight() {
    // Gera insights dinâmicos baseados no projeto
    if (widget.project.name.toLowerCase().contains('ai') || 
        widget.project.name.toLowerCase().contains('inteligência')) {
      return 'Projeto de IA identificado. Recomenda-se monitorar o progresso da fase de testes e validar a qualidade dos dados de entrada.';
    } else if (widget.project.status.toLowerCase().contains('andamento')) {
      return 'Projeto em andamento. Mantenha o acompanhamento regular e verifique se os prazos estão sendo cumpridos conforme planejado.';
    } else if (widget.project.status.toLowerCase().contains('finalizado')) {
      return 'Projeto finalizado com sucesso. Considere documentar as lições aprendidas e aplicar as melhores práticas em futuros projetos.';
    } else {
      return 'Projeto em status: ${widget.project.status}. Recomenda-se revisar o cronograma e alocação de recursos para garantir o sucesso da entrega.';
    }
  }
}
