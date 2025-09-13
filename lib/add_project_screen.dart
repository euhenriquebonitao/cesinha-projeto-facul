import 'package:flutter/material.dart';
import 'package:challenge_vision/models/project.dart';

class AddProjectScreen extends StatefulWidget {
  final Function(Project) onProjectCreated;

  const AddProjectScreen({super.key, required this.onProjectCreated});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _responsibleAreaController = TextEditingController();
  final _responsiblePersonController = TextEditingController();
  final _technologyController = TextEditingController();
  final _unitController = TextEditingController();

  String _selectedStatus = 'Em Andamento';
  String _selectedCategory = 'Inovação';
  DateTime _estimatedCompletionDate = DateTime.now().add(
    const Duration(days: 30),
  );
  DateTime _criticalDate = DateTime.now().add(const Duration(days: 20));
  
  int _selectedIndex = 3; // Add Projeto é o índice 3

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegação direta para cada tela
    if (index == 0) {
      // Home - voltar para Home
      Navigator.of(context).pop();
    } else if (index == 1) {
      // ChallengeMind - ir para ChallengeMind
      Navigator.of(context).pushNamed('/challenge-bot');
    } else if (index == 2) {
      // Projetos - ir para Projetos
      Navigator.of(context).pushNamed('/projects');
    } else if (index == 3) {
      // Add Projeto - já estamos aqui, não precisa navegar
      return;
    }
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black,
        size: 24,
      ),
    );
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
          'Criar Novo Projeto',
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
                'Informações do Projeto',
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

              // Botão Criar Projeto
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _createProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Criar Projeto',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.black, // Mudado para preto
              unselectedItemColor: Colors.black,
              backgroundColor: Colors.white,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              unselectedLabelStyle: TextStyle(color: Colors.black),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
            ),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home, 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.smart_toy, 1),
                label: 'ChallengeMind',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.dashboard, 2),
                label: 'Projetos',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.add_box, 3),
                label: 'Add Projeto',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void _createProject() {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        id: UniqueKey().toString(), // Adicionar um ID único
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
        rating: 5.0,
        interactions: 0,
        isNew: true,
      );

      // Chama a função callback para adicionar o projeto
      widget.onProjectCreated(newProject);

      // Volta para a tela anterior
      Navigator.of(context).pop();

      // Mostra mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Projeto "${newProject.name}" criado com sucesso!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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
