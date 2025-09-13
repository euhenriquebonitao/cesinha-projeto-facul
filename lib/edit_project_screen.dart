import 'package:flutter/material.dart';
import 'package:challenge_vision/models/project.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project;
  final Function(Project) onProjectUpdated;

  const EditProjectScreen({
    super.key,
    required this.project,
    required this.onProjectUpdated,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _projectNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _responsibleAreaController;
  late final TextEditingController _responsiblePersonController;
  late final TextEditingController _technologyController;
  late final TextEditingController _unitController;

  late String _selectedStatus;
  late String _selectedCategory;
  late DateTime _estimatedCompletionDate;
  late DateTime _criticalDate;

  @override
  void initState() {
    super.initState();
    // Inicializar controllers com dados do projeto
    _projectNameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
    _responsibleAreaController = TextEditingController(
      text: widget.project.responsibleArea,
    );
    _responsiblePersonController = TextEditingController(
      text: widget.project.responsiblePerson,
    );
    _technologyController = TextEditingController(
      text: widget.project.technology,
    );
    _unitController = TextEditingController(text: widget.project.unit);

    _selectedStatus = widget.project.status ?? 'Em Andamento';
    _selectedCategory = widget.project.category ?? 'Inovação';
    _estimatedCompletionDate =
        widget.project.estimatedCompletionDate ??
        DateTime.now().add(const Duration(days: 30));
    _criticalDate =
        widget.project.criticalDate ??
        DateTime.now().add(const Duration(days: 20));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Editar Projeto',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editar Informações do Projeto',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Nome do Projeto
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Projeto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do projeto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Inovação', 'Pesquisa', 'Desenvolvimento', 'Melhoria']
                    .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: ['Em Andamento', 'Finalizado', 'Pendente', 'Cancelado']
                    .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Área Responsável
              TextFormField(
                controller: _responsibleAreaController,
                decoration: const InputDecoration(
                  labelText: 'Área Responsável',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a área responsável';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Responsável
              TextFormField(
                controller: _responsiblePersonController,
                decoration: const InputDecoration(
                  labelText: 'Responsável',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o responsável';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tecnologia
              TextFormField(
                controller: _technologyController,
                decoration: const InputDecoration(
                  labelText: 'Tecnologia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.science),
                ),
              ),
              const SizedBox(height: 16),

              // Unidade
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Unidade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição Geral',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Prazos',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Data de Conclusão Estimada
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Data estimada para conclusão'),
                subtitle: Text(
                  '${_estimatedCompletionDate.day}/${_estimatedCompletionDate.month}/${_estimatedCompletionDate.year}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _estimatedCompletionDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _estimatedCompletionDate = date;
                    });
                  }
                },
              ),

              // Data Crítica
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Data crítica'),
                subtitle: Text(
                  '${_criticalDate.day}/${_criticalDate.month}/${_criticalDate.year}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _criticalDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _criticalDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),

              // Botão Salvar Alterações
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProject() {
    if (_formKey.currentState!.validate()) {
      final updatedProject = widget.project.copyWith(
        name: _projectNameController.text,
        category: _selectedCategory,
        status: _selectedStatus,
        responsibleArea: _responsibleAreaController.text,
        responsiblePerson: _responsiblePersonController.text,
        technology: _technologyController.text,
        unit: _unitController.text,
        description: _descriptionController.text,
        estimatedCompletionDate: _estimatedCompletionDate,
        criticalDate: _criticalDate,
      );

      // Chama a função callback para atualizar o projeto
      widget.onProjectUpdated(updatedProject);
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _responsibleAreaController.dispose();
    _responsiblePersonController.dispose();
    _technologyController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}
