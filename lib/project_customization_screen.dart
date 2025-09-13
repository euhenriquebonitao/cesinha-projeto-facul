import 'package:flutter/material.dart';
import 'add_project_screen.dart';
import 'edit_project_screen.dart';
import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/widgets/project_customization_card.dart';
import 'package:challenge_vision/widgets/project_customization_search_bar.dart';
import 'package:challenge_vision/widgets/expandable_filter_slider.dart';
import 'package:challenge_vision/widgets/profile_drawer.dart';
import 'package:challenge_vision/screens/project_details_screen.dart';
import 'package:challenge_vision/screens/challenge_bot_screen.dart';
import 'package:challenge_vision/widgets/project_analytics_dashboard.dart';

class ProjectCustomizationScreen extends StatefulWidget {
  final Function(Project) onProjectUpdated;
  final Function(Project) onProjectDeleted;
  final Function(Project)
  onProjectAdded; // Novo callback para adicionar projeto
  final List<Project> projects;
  final VoidCallback? onNavigateBack;
  final int? fromTabIndex; // Para saber de qual aba veio

  const ProjectCustomizationScreen({
    super.key,
    required this.onProjectUpdated,
    required this.onProjectDeleted,
    required this.onProjectAdded, // Adicionar ao construtor
    required this.projects,
    this.onNavigateBack,
    this.fromTabIndex,
  });

  @override
  State<ProjectCustomizationScreen> createState() =>
      _ProjectCustomizationScreenState();
}

class _ProjectCustomizationScreenState
    extends State<ProjectCustomizationScreen> {
  String? _selectedCategory;
  String? _selectedStatus;
  String? _selectedDateOrder;
  bool? _selectedFavorites;
  String? _searchQuery;
  Project? _selectedProject;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2; // Projetos tab
  bool _showAllProjects = false; // Controla se mostra todos os projetos ou apenas os primeiros 4
  bool _isDashboardExpanded = false; // Controla se o dashboard está expandido

  // Usar a lista de projetos passada como parâmetro
  List<Project> get _projects => widget.projects;

  // Função para filtrar projetos
  List<Project> get _filteredProjects {
    List<Project> filtered = _projects;
    
    // Filtro por nome
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      filtered = filtered.where((project) {
        final projectName = project.name.toLowerCase();
        return projectName.contains(_searchQuery!.toLowerCase());
      }).toList();
    }
    
    // Filtro por categoria
    if (_selectedCategory != null) {
      filtered = filtered.where((project) {
        return project.category.toLowerCase().contains(_selectedCategory!.toLowerCase());
      }).toList();
    }
    
    // Filtro por status
    if (_selectedStatus != null) {
      filtered = filtered.where((project) {
        return project.status.toLowerCase().contains(_selectedStatus!.toLowerCase());
      }).toList();
    }
    
    // Filtro por favoritos
    if (_selectedFavorites == true) {
      filtered = filtered.where((project) {
        return project.isFavorited;
      }).toList();
    }
    
    // Filtro por data (ordenar)
    if (_selectedDateOrder != null) {
      filtered.sort((a, b) {
        switch (_selectedDateOrder) {
          case 'Mais Próxima':
            return a.estimatedCompletionDate.compareTo(b.estimatedCompletionDate);
          case 'Mais Distante':
            return b.estimatedCompletionDate.compareTo(a.estimatedCompletionDate);
          case 'Recente':
            return b.estimatedCompletionDate.compareTo(a.estimatedCompletionDate);
          case 'Antiga':
            return a.estimatedCompletionDate.compareTo(b.estimatedCompletionDate);
          default:
            return 0;
        }
      });
    }
    
    return filtered;
  }

  // Função para obter projetos para exibição (limitados ou todos)
  List<Project> get _displayProjects {
    final filtered = _filteredProjects;
    
    // Se não está mostrando todos e há mais de 4 projetos, limita a 4
    if (!_showAllProjects && filtered.length > 4) {
      return filtered.take(4).toList();
    }
    
    return filtered;
  }

  void _onFiltersChanged(String? category, String? status, String? dateOrder, bool? favorites) {
    setState(() {
      _selectedCategory = category;
      _selectedStatus = status;
      _selectedDateOrder = dateOrder;
      _selectedFavorites = favorites;
      // Resetar visualização quando filtros mudarem
      _showAllProjects = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegação direta para cada tela
    if (index == 0) {
      // Home - voltar para Home
      Navigator.of(context).pop();
      widget.onNavigateBack?.call();
    } else if (index == 1) {
      // ChallengeMind - ir direto para ChallengeMind
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChallengeMindScreen(
            projects: _projects,
            fromTabIndex: widget.fromTabIndex, // Passar índice de origem
            onNavigateBack: () {
              setState(() {
                _selectedIndex = widget.fromTabIndex ?? 2; // Voltar para aba de origem
              });
            },
          ),
        ),
      );
    } else if (index == 2) {
      // Projetos - já estamos aqui, não precisa navegar
      return;
    } else if (index == 3) {
      // Add Projeto - ir direto para Add Projeto
      _addProject();
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

  void _selectProject(Project project) {
    setState(() {
      // Se o projeto já está selecionado, desmarca
      if (_selectedProject?.id == project.id) {
        _selectedProject = null;
      } else {
        _selectedProject = project;
      }
    });
  }

  void _addProject() {
    // Navegar para tela de adicionar projeto
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProjectScreen(
          onProjectCreated: (newProject) {
            // Adicionar o novo projeto à lista via callback
            widget.onProjectAdded(newProject);
            Navigator.of(context).pop(); // Volta para a tela de projetos
          },
        ),
      ),
    );
  }

  void _deleteProject() {
    if (_selectedProject != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: Text(
              'Tem certeza que deseja excluir o projeto "${_selectedProject!.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  widget.onProjectDeleted(_selectedProject!);
                  setState(() {
                    _selectedProject = null;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Projeto excluído com sucesso!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um projeto primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _editProject() {
    if (_selectedProject != null) {
      // Navegar para tela de edição
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditProjectScreen(
            project: _selectedProject!,
            onProjectUpdated: (updatedProject) {
              widget.onProjectUpdated(updatedProject);
              setState(() {
                _selectedProject = updatedProject;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Projeto atualizado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um projeto primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      drawer: const ProfileDrawer(),
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
        title: const Text(
          'Área Projetos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 1200 ? 32.0 : 16.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width > 1200 ? 1400 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com estatísticas
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.dashboard,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gerenciamento de Projetos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_projects.length} projetos cadastrados',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_selectedProject != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Projeto Selecionado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Dashboard de análises
                  ProjectAnalyticsDashboard(
                    projects: _projects,
                    isExpanded: _isDashboardExpanded,
                    onToggle: () {
                      setState(() {
                        _isDashboardExpanded = !_isDashboardExpanded;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Barra de busca
                  ProjectCustomizationSearchBar(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    searchQuery: _searchQuery,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Slider de filtros expansível
                  ExpandableFilterSlider(
                    selectedCategory: _selectedCategory,
                    selectedStatus: _selectedStatus,
                    selectedDateOrder: _selectedDateOrder,
                    selectedFavorites: _selectedFavorites,
                    onFiltersChanged: _onFiltersChanged,
                  ),
                  
                  const SizedBox(height: 20),
                  // Seção de projetos
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.folder,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Flexible(
                              child: Text(
                                'Projetos Disponíveis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Container flexível para os badges
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_hasActiveFilters())
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_filteredProjects.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (_filteredProjects.length > 4 && !_showAllProjects) ...[
                                    const SizedBox(width: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '+${_filteredProjects.length - 4}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _filteredProjects.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _hasActiveFilters()
                                          ? 'Nenhum projeto encontrado com os filtros aplicados'
                                          : 'Nenhum projeto encontrado',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (_hasActiveFilters()) ...[
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedCategory = null;
                                            _selectedStatus = null;
                                            _selectedDateOrder = null;
                                            _searchQuery = '';
                                          });
                                        },
                                        child: const Text(
                                          'Limpar filtros',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  _buildResponsiveProjectGrid(),
                                  // Botão "Veja mais" se há mais de 4 projetos e não está mostrando todos
                                  if (_filteredProjects.length > 4 && !_showAllProjects) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _showAllProjects = true;
                                          });
                                        },
                                        icon: const Icon(Icons.expand_more, color: Colors.white, size: 18),
                                        label: Text(
                                          'Veja mais (+${_filteredProjects.length - 4})',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  // Botão "Ver menos" se está mostrando todos e há mais de 4
                                  if (_filteredProjects.length > 4 && _showAllProjects) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _showAllProjects = false;
                                          });
                                        },
                                        icon: const Icon(Icons.expand_less, color: Colors.black, size: 18),
                                        label: const Text(
                                          'Ver menos',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.black),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Botão de adicionar projeto
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Gerenciar Projetos',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Clique em um projeto para ver as opções de edição, exclusão e visualização. Ou adicione um novo projeto:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: _buildModernActionButton(
                                  'Adicionar Novo Projeto',
                                  Icons.add_circle,
                                  Colors.green,
                                  _addProject,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
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

  bool _hasActiveFilters() {
    return _selectedCategory != null || 
           _selectedStatus != null || 
           _selectedDateOrder != null ||
           (_searchQuery != null && _searchQuery!.isNotEmpty);
  }

  Widget _buildProjectCardWithActions(Project project, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey[300]!,
          width: isSelected ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card principal
          Expanded(
            child: ProjectCustomizationCard(
              project: project,
              isSelected: isSelected,
              onTap: () => _selectProject(project),
            ),
          ),
          
          // Ações diretas - só aparecem quando selecionado
          if (isSelected)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botão Editar
                  GestureDetector(
                    onTap: () {
                      _selectedProject = project;
                      _editProject();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  
                  // Botão Deletar
                  GestureDetector(
                    onTap: () {
                      _selectedProject = project;
                      _deleteProject();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  
                  // Botão Ver Detalhes
                  GestureDetector(
                    onTap: () {
                      _selectedProject = project;
                      _showProjectDetails(project);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showProjectDetails(Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(project: project),
      ),
    );
  }


  Widget _buildModernActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildResponsiveProjectGrid() {
    // Detectar se é desktop baseado na largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;
    
    // Calcular número de colunas baseado no tamanho da tela
    int crossAxisCount;
    double childAspectRatio;
    
    if (isDesktop) {
      crossAxisCount = (screenWidth / 300).floor().clamp(3, 6); // Entre 3 e 6 colunas
      childAspectRatio = 0.7; // Cards mais quadrados
    } else if (isTablet) {
      crossAxisCount = 3; // 3 colunas para tablet
      childAspectRatio = 0.65;
    } else {
      crossAxisCount = 2; // 2 colunas para mobile
      childAspectRatio = 0.65;
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _displayProjects.length,
      itemBuilder: (context, index) {
        final project = _displayProjects[index];
        final isSelected = _selectedProject?.id == project.id;

        return _buildProjectCardWithActions(project, isSelected);
      },
    );
  }
}
