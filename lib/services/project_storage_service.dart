import 'package:hive_flutter/hive_flutter.dart';
import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/services/cloud_sync_service.dart';
import 'package:challenge_vision/services/project_evolution_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectStorageService {
  static const String _boxName = 'projects_box';
  static Box<Project>? _box;
  static final CloudSyncService _cloudSync = CloudSyncService();

  // Inicializa o box do Hive
  static Future<void> init() async {
    print('🚀 HIVE: Inicializando banco de dados Hive...');
    _box = await Hive.openBox<Project>(_boxName);
    print('✅ HIVE: Box "$_boxName" aberto com sucesso!');
    print('📊 HIVE: Total de projetos existentes: ${_box!.length}');
    print('📁 HIVE: Caminho do banco: ${_box!.path}');
  }

  // Retorna o box, inicializando se necessário
  static Box<Project> get box {
    if (_box == null) {
      throw Exception(
        'ProjectStorageService não foi inicializado. Chame init() primeiro.',
      );
    }
    return _box!;
  }

  // Carrega todos os projetos
  Future<List<Project>> loadProjects() async {
    final projects = box.values.toList();
    print('🔍 HIVE: Carregando ${projects.length} projetos do banco Hive');
    print('📊 HIVE: Box path: ${box.path}');
    print('📋 HIVE: Box name: ${box.name}');
    
    // Aplicar evolução automática aos projetos
    final evolvedProjects = ProjectEvolutionService.evolveProjects(projects);
    
    // Salvar projetos evoluídos de volta no banco
    if (evolvedProjects != projects) {
      print('🔄 EVOLUTION: Aplicando evolução automática aos projetos...');
      for (int i = 0; i < evolvedProjects.length; i++) {
        if (evolvedProjects[i] != projects[i]) {
          await box.putAt(i, evolvedProjects[i]);
          print('✨ EVOLUTION: Projeto "${evolvedProjects[i].name}" evoluiu!');
        }
      }
    }
    
    return evolvedProjects;
  }

  // Salva um projeto
  Future<void> saveProject(Project project) async {
    print('💾 STORAGE: Iniciando salvamento do projeto "${project.name}"');
    
    // Adicionar ownerUserId se usuário estiver logado
    final currentUser = FirebaseAuth.instance.currentUser;
    print('💾 STORAGE: Usuário atual: ${currentUser?.email ?? "Não logado"}');
    print('💾 STORAGE: UID do usuário: ${currentUser?.uid ?? "N/A"}');
    
    final now = DateTime.now();
    final projectWithOwner = project.copyWith(
      ownerUserId: currentUser?.uid,
      createdAt: project.createdAt ?? now,
      updatedAt: now,
    );
    print('💾 STORAGE: Projeto com owner: ${projectWithOwner.ownerUserId}');

    await box.put(projectWithOwner.id, projectWithOwner);
    print('💾 HIVE: Projeto "${projectWithOwner.name}" salvo no banco Hive');
    print('📈 HIVE: Total de projetos: ${box.length}');
    print('🆔 HIVE: ID do projeto: ${projectWithOwner.id}');

    // Sincronizar com a nuvem se usuário estiver logado
    if (currentUser != null) {
      print('☁️ STORAGE: Usuário logado, iniciando sincronização com Firebase...');
      try {
        await _cloudSync.syncUp(projectWithOwner);
        print(
          '☁️ SYNC: Projeto "${projectWithOwner.name}" sincronizado com a nuvem',
        );
      } catch (e) {
        print(
          '⚠️ SYNC: Erro ao sincronizar projeto: $e (Tipo: ${e.runtimeType})',
        );
        print('⚠️ SYNC: Stack trace: ${e.toString()}');
        // Não falha se não conseguir sincronizar - dados ficam no Hive local
      }
    } else {
      print('⚠️ STORAGE: Usuário não logado, projeto salvo apenas localmente');
    }
  }

  // Salva múltiplos projetos
  Future<void> saveProjects(List<Project> projects) async {
    final Map<String, Project> projectMap = {
      for (var project in projects) project.id: project,
    };
    await box.putAll(projectMap);
    print('💾 HIVE: ${projects.length} projetos salvos em lote no banco Hive');
    print('📈 HIVE: Total de projetos: ${box.length}');
  }

  // Remove um projeto
  Future<void> deleteProject(String projectId) async {
    await box.delete(projectId);
    print('🗑️ HIVE: Projeto removido (ID: $projectId)');
    print('📈 HIVE: Total de projetos: ${box.length}');

    // Remover da nuvem se usuário estiver logado
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await _cloudSync.deleteFromCloud(projectId);
        print('☁️ SYNC: Projeto $projectId removido da nuvem');
      } catch (e) {
        print('⚠️ SYNC: Erro ao remover projeto da nuvem: $e');
      }
    }
  }

  // Atualiza um projeto existente
  Future<void> updateProject(Project project) async {
    await box.put(project.id, project);
    print('🔄 HIVE: Projeto "${project.name}" atualizado no banco Hive');
    print('📈 HIVE: Total de projetos: ${box.length}');

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await _cloudSync.syncUp(project);
        print(
          '☁️ SYNC: Projeto "${project.name}" atualizado e sincronizado com a nuvem',
        );
      } catch (e) {
        print(
          '⚠️ SYNC: Erro ao atualizar e sincronizar projeto: $e (Tipo: ${e.runtimeType})',
        );
      }
    }
  }

  // Busca um projeto por ID
  Project? getProject(String projectId) {
    final project = box.get(projectId);
    if (project != null) {
      print('🔍 HIVE: Projeto encontrado: ${project.name}');
    } else {
      print('❌ HIVE: Projeto não encontrado (ID: $projectId)');
    }
    return project;
  }

  // Limpa todos os projetos
  Future<void> clearAllProjects() async {
    await box.clear();
    print('🧹 HIVE: Todos os projetos foram removidos do banco');
    print('📈 HIVE: Total de projetos: ${box.length}');
  }

  // Limpa projetos com IDs inválidos (que começam com [ e terminam com ])
  Future<void> clearInvalidProjects() async {
    final invalidKeys = box.keys.where((key) => 
      key.toString().startsWith('[') && key.toString().endsWith(']')
    ).toList();
    
    if (invalidKeys.isNotEmpty) {
      print('🧹 HIVE: Removendo ${invalidKeys.length} projetos com IDs inválidos...');
      for (var key in invalidKeys) {
        await box.delete(key);
        print('🗑️ HIVE: Projeto removido (ID inválido: $key)');
      }
      print('✅ HIVE: Projetos com IDs inválidos removidos');
    } else {
      print('✅ HIVE: Nenhum projeto com ID inválido encontrado');
    }
    print('📈 HIVE: Total de projetos: ${box.length}');
  }

  // Fecha o box
  Future<void> close() async {
    await box.close();
    print('🔒 HIVE: Box fechado');
  }

  // Método de debug para mostrar informações completas
  void debugInfo() {
    print('🔍 === DEBUG HIVE ===');
    print('📦 Box name: ${box.name}');
    print('📁 Box path: ${box.path}');
    print('📊 Total projetos: ${box.length}');
    print('🔓 Box aberto: ${box.isOpen}');
    print('🔑 Chaves: ${box.keys.toList()}');
    print(
      '👤 Usuário logado: ${FirebaseAuth.instance.currentUser?.email ?? "Não logado"}',
    );
    print('🔍 === FIM DEBUG ===');
  }

  // Sincronizar projetos da nuvem para o Hive
  Future<void> syncFromCloud() async {
    try {
      print('🔄 SYNC: Iniciando sincronização da nuvem...');
      print('🔄 SYNC: Usuário atual: ${FirebaseAuth.instance.currentUser?.email ?? "Não logado"}');
      print('🔄 SYNC: UID do usuário: ${FirebaseAuth.instance.currentUser?.uid ?? "N/A"}');
      
      final cloudProjects = await _cloudSync.syncDown();

      if (cloudProjects.isNotEmpty) {
        print('🔄 SYNC: ${cloudProjects.length} projetos encontrados na nuvem, salvando no Hive...');
        await saveProjects(cloudProjects);
        print(
          '✅ SYNC: ${cloudProjects.length} projetos sincronizados da nuvem',
        );
      } else {
        print('ℹ️ SYNC: Nenhum projeto encontrado na nuvem');
      }
    } catch (e) {
      print('❌ SYNC: Erro ao sincronizar da nuvem: $e');
      print('❌ SYNC: Tipo do erro: ${e.runtimeType}');
      print('❌ SYNC: Stack trace: ${e.toString()}');
      throw 'Erro ao sincronizar projetos. Verifique sua conexão.';
    }
  }

  // Sincronizar todos os projetos do Hive para a nuvem
  Future<void> syncToCloud() async {
    try {
      final localProjects = await loadProjects();
      if (localProjects.isNotEmpty) {
        await _cloudSync.syncAllUp(localProjects);
        print('✅ SYNC: ${localProjects.length} projetos enviados para a nuvem');
      } else {
        print('ℹ️ SYNC: Nenhum projeto local para enviar');
      }
    } catch (e) {
      print('❌ SYNC: Erro ao enviar para a nuvem: $e');
      throw 'Erro ao sincronizar projetos. Verifique sua conexão.';
    }
  }

  // Verificar se há conexão com a internet
  Future<bool> hasInternetConnection() async {
    return await _cloudSync.hasConnection();
  }
}
