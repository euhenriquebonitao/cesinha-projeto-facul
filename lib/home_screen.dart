import 'package:flutter/material.dart';
import 'add_project_screen.dart';
import 'project_customization_screen.dart';
import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/widgets/project_search_bar.dart';
import 'package:challenge_vision/widgets/project_carousel.dart';
import 'package:challenge_vision/services/project_storage_service.dart'; // Importar o serviço
import 'screens/challenge_bot_screen.dart'; // Importar a tela do ChallengeMind
import 'package:challenge_vision/widgets/draggable_chatbot_button.dart'; // Importar o botão flutuante do ChallengeMind
import 'package:challenge_vision/widgets/profile_drawer.dart'; // Importar o menu lateral de perfil

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // To manage the selected tab in BottomNavigationBar
  int _lastActiveIndex = 0; // To remember the last active tab
  String _searchQuery = ''; // Para filtrar por nome do projeto
  String? _selectedCategory; // Para filtrar por categoria
  String? _selectedStatus; // Para filtrar por status
  String? _selectedDateOrder; // Para filtrar por data
  bool? _selectedFavorites; // Para filtrar por favoritos
  bool _isFiltersExpanded = false; // Para controlar se os filtros estão expandidos

  final ProjectStorageService _storageService =
      ProjectStorageService(); // Instanciar o serviço
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de projetos - começa vazia, só projetos criados pelo usuário
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects(); // Carregar projetos ao iniciar a tela
  }

  Future<void> _loadProjects() async {
    print('🔄 HOME: Carregando projetos...');
    
    // Primeiro, tentar sincronizar do Firebase
    try {
      print('☁️ HOME: Tentando sincronizar do Firebase...');
      await _storageService.syncFromCloud();
      print('✅ HOME: Sincronização do Firebase concluída');
    } catch (e) {
      print('⚠️ HOME: Erro na sincronização do Firebase: $e');
      // Continuar mesmo com erro - carregar do Hive local
    }
    
    // Depois, carregar do Hive (que agora tem os dados sincronizados)
    final loadedProjects = await _storageService.loadProjects();
    print('📊 HOME: ${loadedProjects.length} projetos carregados do Hive');
    
    setState(() {
      _projects = loadedProjects;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _lastActiveIndex = index; // Lembrar a última aba ativa
    });

    // Navegação direta para cada tela
    if (index == 0) {
      // Home - já estamos aqui, não precisa navegar
      return;
    } else if (index == 1) {
      // ChallengeMind - ir direto para ChallengeMind
      _navigateToChallengeBot();
    } else if (index == 2) {
      // Projetos - ir direto para Projetos
      _navigateToProjectCustomization();
    } else if (index == 3) {
      // Add Projeto - ir direto para Add Projeto
      _navigateToAddProject();
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

  void _navigateToChallengeBot() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChallengeMindScreen(
          projects: _projects,
          fromTabIndex: _lastActiveIndex, // Passar índice de origem
          onNavigateBack: () {
            setState(() {
              _selectedIndex = _lastActiveIndex; // Voltar para última aba ativa
            });
          },
        ), // Passar projetos para o ChallengeMind
      ),
    );
  }

  void _navigateToAddProject() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddProjectScreen(onProjectCreated: _addNewProject),
      ),
    );
    // Não resetar para Home aqui, pois _addNewProject já navega para projetos
  }

  void _addNewProject(Project newProject) {
    // Gerar um ID válido para o Firestore
    final validId = DateTime.now().millisecondsSinceEpoch.toString();
    final projectWithId = newProject.copyWith(id: validId);
    
    setState(() {
      _projects.insert(0, projectWithId); // Adiciona no início da lista com um ID único
    });
    _storageService.saveProject(projectWithId); // CORREÇÃO: Salvar projeto individual com sincronização Firebase

    // Após criar o projeto, navegar automaticamente para a tela de projetos
    _navigateToProjectCustomization();
  }

  void _navigateToProjectCustomization() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectCustomizationScreen(
          onProjectUpdated: _updateProject,
          onProjectDeleted: _deleteProject,
          onProjectAdded:
              _addNewProject, // Passar o callback para adicionar projeto
          projects: _projects,
          fromTabIndex: _lastActiveIndex, // Passar índice de origem
          onNavigateBack: () {
            setState(() {
              _selectedIndex = _lastActiveIndex; // Voltar para última aba ativa
            });
          },
        ),
      ),
    );
  }

  void _updateProject(Project updatedProject) {
    setState(() {
      final index = _projects.indexWhere((p) => p.id == updatedProject.id);
      if (index != -1) {
        _projects[index] = updatedProject;
      }
    });
    _storageService.saveProjects(_projects); // Salvar projetos após atualizar
  }

  void _deleteProject(Project projectToDelete) {
    print('🗑️ HOME: Deletando projeto "${projectToDelete.name}" (ID: ${projectToDelete.id})');
    
    setState(() {
      _projects.removeWhere((p) => p.id == projectToDelete.id);
    });
    
    // CORREÇÃO: Usar deleteProject individual para deletar do Firebase também
    _storageService.deleteProject(projectToDelete.id);
    
    print('✅ HOME: Projeto "${projectToDelete.name}" removido da lista local');
  }


  // Função para verificar se há filtros ativos
  bool _hasActiveFilters() {
    return _selectedCategory != null || 
           _selectedStatus != null || 
           _selectedDateOrder != null ||
           _selectedFavorites == true;
  }

  // Função para contar quantos filtros estão ativos
  int _getActiveFiltersCount() {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedStatus != null) count++;
    if (_selectedDateOrder != null) count++;
    if (_selectedFavorites == true) count++;
    return count;
  }

  // Função para construir seção de filtro
  Widget _buildFilterSection(String title, IconData icon, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: chips,
        ),
      ],
    );
  }

  // Função para construir chip de filtro
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  // Função para filtrar projetos por nome, categoria, status, data e favoritos
  List<Project> get _filteredProjects {
    List<Project> filtered = _projects;
    
    // Filtro por nome
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        final projectName = project.name.toLowerCase();
        return projectName.contains(_searchQuery.toLowerCase());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const ProfileDrawer(),
      body: Stack(
        children: [
          // Conteúdo principal da tela
          Column(
            children: [
              // AppBar customizado
              Container(
                color: Colors.white,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bem-vindo',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.cloud_sync, color: Colors.green, size: 25),
                              onPressed: () async {
                                await _loadProjects();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('☁️ Sincronização com Firebase executada!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
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
                      ],
                    ),
                  ),
                ),
              ),
              // Conteúdo da tela
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bem-vindo ao ChallengeVision',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.storage, color: Colors.green, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Projetos salvos no Hive: ${_projects.length}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Pesquise o projeto desejado',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ProjectSearchBar(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'Seus Projetos',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            // Contador de resultados
                            if (_hasActiveFilters())
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_filteredProjects.length} resultados',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Filtros avançados expansíveis
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              // Cabeçalho dos filtros (sempre visível)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isFiltersExpanded = !_isFiltersExpanded;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.filter_list,
                                        size: 18,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Filtros Avançados',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      // Indicador de filtros ativos
                                      if (_hasActiveFilters())
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${_getActiveFiltersCount()}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        _isFiltersExpanded ? Icons.expand_less : Icons.expand_more,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Conteúdo dos filtros (expansível)
                              if (_isFiltersExpanded) ...[
                                Container(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Categoria
                                      _buildFilterSection(
                                        'Categoria',
                                        Icons.category,
                                        [
                                          _buildFilterChip('Inovação', _selectedCategory == 'inovação', () {
                                            setState(() {
                                              _selectedCategory = _selectedCategory == 'inovação' ? null : 'inovação';
                                            });
                                          }),
                                          _buildFilterChip('Pesquisa', _selectedCategory == 'pesquisa', () {
                                            setState(() {
                                              _selectedCategory = _selectedCategory == 'pesquisa' ? null : 'pesquisa';
                                            });
                                          }),
                                          _buildFilterChip('Desenvolvimento', _selectedCategory == 'desenvolvimento', () {
                                            setState(() {
                                              _selectedCategory = _selectedCategory == 'desenvolvimento' ? null : 'desenvolvimento';
                                            });
                                          }),
                                          _buildFilterChip('Melhoria', _selectedCategory == 'melhoria', () {
                                            setState(() {
                                              _selectedCategory = _selectedCategory == 'melhoria' ? null : 'melhoria';
                                            });
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Status
                                      _buildFilterSection(
                                        'Status',
                                        Icons.flag,
                                        [
                                          _buildFilterChip('Em Andamento', _selectedStatus == 'em andamento', () {
                                            setState(() {
                                              _selectedStatus = _selectedStatus == 'em andamento' ? null : 'em andamento';
                                            });
                                          }),
                                          _buildFilterChip('Finalizado', _selectedStatus == 'finalizado', () {
                                            setState(() {
                                              _selectedStatus = _selectedStatus == 'finalizado' ? null : 'finalizado';
                                            });
                                          }),
                                          _buildFilterChip('Pendente', _selectedStatus == 'pendente', () {
                                            setState(() {
                                              _selectedStatus = _selectedStatus == 'pendente' ? null : 'pendente';
                                            });
                                          }),
                                          _buildFilterChip('Cancelado', _selectedStatus == 'cancelado', () {
                                            setState(() {
                                              _selectedStatus = _selectedStatus == 'cancelado' ? null : 'cancelado';
                                            });
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Data Estimada
                                      _buildFilterSection(
                                        'Data Estimada',
                                        Icons.calendar_today,
                                        [
                                          _buildFilterChip('Mais Próxima', _selectedDateOrder == 'Mais Próxima', () {
                                            setState(() {
                                              _selectedDateOrder = _selectedDateOrder == 'Mais Próxima' ? null : 'Mais Próxima';
                                            });
                                          }),
                                          _buildFilterChip('Mais Distante', _selectedDateOrder == 'Mais Distante', () {
                                            setState(() {
                                              _selectedDateOrder = _selectedDateOrder == 'Mais Distante' ? null : 'Mais Distante';
                                            });
                                          }),
                                          _buildFilterChip('Recente', _selectedDateOrder == 'Recente', () {
                                            setState(() {
                                              _selectedDateOrder = _selectedDateOrder == 'Recente' ? null : 'Recente';
                                            });
                                          }),
                                          _buildFilterChip('Antiga', _selectedDateOrder == 'Antiga', () {
                                            setState(() {
                                              _selectedDateOrder = _selectedDateOrder == 'Antiga' ? null : 'Antiga';
                                            });
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Favoritos
                                      _buildFilterSection(
                                        'Meus Favoritos',
                                        Icons.favorite,
                                        [
                                          _buildFilterChip('Mostrar Favoritos', _selectedFavorites == true, () {
                                            setState(() {
                                              _selectedFavorites = _selectedFavorites == true ? null : true;
                                            });
                                          }),
                                        ],
                                      ),
                                      // Botão limpar filtros
                                      if (_hasActiveFilters())
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton.icon(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedCategory = null;
                                                    _selectedStatus = null;
                                                    _selectedDateOrder = null;
                                                    _selectedFavorites = null;
                                                  });
                                                },
                                                icon: const Icon(Icons.clear, size: 16),
                                                label: const Text('Limpar Filtros'),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                  textStyle: const TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProjectCarousel(
                          filteredProjects: _filteredProjects,
                          searchQuery: _searchQuery,
                          onClearSearch: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Botão flutuante do ChallengeMind
          DraggableChatbotButton(
            onTap: _navigateToChallengeBot,
          ),
        ],
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
}