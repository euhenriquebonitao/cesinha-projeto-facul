import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:challenge_vision/models/project.dart';

class CloudSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection path para projetos do usuário
  String get _projectsPath {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }
    return 'users/${user.uid}/projects';
  }

  // Sincronizar projetos do Firestore para o Hive (pull)
  Future<List<Project>> syncDown() async {
    try {
      if (_auth.currentUser == null) {
        print('❌ SYNC: Usuário não autenticado');
        return [];
      }

      print('🔄 SYNC: Iniciando sincronização (Firestore → Hive)');
      print('🔄 SYNC: Usuário logado: ${_auth.currentUser!.email}');
      print('🔄 SYNC: UID do usuário: ${_auth.currentUser!.uid}');
      print('🔄 SYNC: Path da coleção: $_projectsPath');

      print('🔄 SYNC: Tentando conectar com Firestore...');
      final QuerySnapshot snapshot = await _firestore
          .collection(_projectsPath)
          .get();

      print('🔄 SYNC: Query executada. Documentos encontrados: ${snapshot.docs.length}');
      print('🔄 SYNC: Tamanho da query: ${snapshot.size}');

      final List<Project> projects = [];

      for (var doc in snapshot.docs) {
        try {
          print('🔄 SYNC: Processando documento: ${doc.id}');
          final data = doc.data() as Map<String, dynamic>;
          print('🔄 SYNC: Dados do documento: $data');
          final project = Project.fromMap(data);
          projects.add(project);
          print('📥 SYNC: Projeto "${project.name}" baixado da nuvem');
        } catch (e) {
          print('❌ SYNC: Erro ao processar documento ${doc.id}: $e');
          print('❌ SYNC: Tipo do erro: ${e.runtimeType}');
        }
      }

      print('✅ SYNC: ${projects.length} projetos baixados da nuvem');
      return projects;
    } catch (e) {
      print('❌ SYNC: Erro ao baixar projetos: $e');
      print('❌ SYNC: Tipo do erro: ${e.runtimeType}');
      print('❌ SYNC: Stack trace: ${e.toString()}');
      throw 'Erro ao sincronizar projetos. Verifique sua conexão.';
    }
  }

  // Sincronizar projeto do Hive para o Firestore (push)
  Future<void> syncUp(Project project) async {
    try {
      if (_auth.currentUser == null) {
        print('❌ SYNC: Usuário não autenticado');
        return;
      }

      print('🔄 SYNC: Enviando projeto "${project.name}" para a nuvem');
      print('🔄 SYNC: Usuário logado: ${_auth.currentUser!.email}');
      print('🔄 SYNC: UID do usuário: ${_auth.currentUser!.uid}');
      print('🔄 SYNC: Path da coleção: $_projectsPath');
      print('🔄 SYNC: ID do projeto: ${project.id}');

      // Adicionar ownerUserId ao projeto
      final projectData = project.toJson();
      projectData['ownerUserId'] = _auth.currentUser!.uid;
      projectData['lastModified'] = FieldValue.serverTimestamp();

      print('🔄 SYNC: Dados do projeto: $projectData');

      print('🔄 SYNC: Tentando conectar com Firestore...');
      await _firestore
          .collection(_projectsPath)
          .doc(project.id)
          .set(projectData, SetOptions(merge: true));

      print('✅ SYNC: Projeto "${project.name}" enviado para a nuvem com sucesso!');
      print('✅ SYNC: Documento salvo em: $_projectsPath/${project.id}');
    } catch (e) {
      print('❌ SYNC: Erro ao enviar projeto: $e');
      print('❌ SYNC: Tipo do erro: ${e.runtimeType}');
      print('❌ SYNC: Stack trace: ${e.toString()}');
      throw 'Erro ao salvar projeto na nuvem. Verifique sua conexão.';
    }
  }

  // Deletar projeto da nuvem
  Future<void> deleteFromCloud(String projectId) async {
    try {
      if (_auth.currentUser == null) {
        print('❌ SYNC: Usuário não autenticado');
        return;
      }

      print('🔄 SYNC: Deletando projeto $projectId da nuvem');

      await _firestore.collection(_projectsPath).doc(projectId).delete();

      print('✅ SYNC: Projeto $projectId deletado da nuvem');
    } catch (e) {
      print('❌ SYNC: Erro ao deletar projeto da nuvem: $e');
      throw 'Erro ao deletar projeto da nuvem. Verifique sua conexão.';
    }
  }

  // Sincronizar todos os projetos do Hive para a nuvem
  Future<void> syncAllUp(List<Project> projects) async {
    try {
      if (_auth.currentUser == null) {
        print('❌ SYNC: Usuário não autenticado');
        return;
      }

      print('🔄 SYNC: Enviando ${projects.length} projetos para a nuvem');

      final batch = _firestore.batch();

      for (var project in projects) {
        final projectData = project.toJson();
        projectData['ownerUserId'] = _auth.currentUser!.uid;
        projectData['lastModified'] = FieldValue.serverTimestamp();

        batch.set(
          _firestore.collection(_projectsPath).doc(project.id),
          projectData,
          SetOptions(merge: true),
        );
      }

      await batch.commit();
      print('✅ SYNC: ${projects.length} projetos enviados para a nuvem');
    } catch (e) {
      print('❌ SYNC: Erro ao enviar projetos para a nuvem: $e');
      throw 'Erro ao sincronizar projetos. Verifique sua conexão.';
    }
  }

  // Listener para mudanças em tempo real
  Stream<List<Project>> get projectsStream {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return _firestore.collection(_projectsPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              return Project.fromMap(data);
            } catch (e) {
              print('❌ SYNC: Erro ao processar documento ${doc.id}: $e');
              return null;
            }
          })
          .where((project) => project != null)
          .cast<Project>()
          .toList();
    });
  }

  // Verificar se há conexão com a internet
  Future<bool> hasConnection() async {
    try {
      await _firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }
}
