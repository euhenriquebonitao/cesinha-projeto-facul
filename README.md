# 🚀 Sprint 3 - Sistema de Gestão de Projetos

## 📋 Descrição

Sistema completo de gestão de projetos desenvolvido em Flutter com integração Firebase, oferecendo uma interface moderna e intuitiva para gerenciar projetos corporativos com funcionalidades avançadas de análise e acompanhamento.

## ✨ Funcionalidades Principais

### 🔐 Autenticação
- **Login seguro** com Firebase Authentication
- **Logout** com limpeza de sessão
- **Gerenciamento de usuários** integrado

### 🏠 Tela Inicial (Home)
- **Bem-vindo** personalizado
- **Carrossel automático** de projetos
- **Botão flutuante** do ChallengeBot (arrastável)
- **Sincronização** com Firebase
- **Menu lateral** de perfil do usuário

### 🤖 ChallengeBot - Assistente Inteligente
- **Interface de chat** moderna e responsiva
- **Análise de projetos** com insights personalizados
- **Integração com Gemini AI** para respostas inteligentes
- **Design otimizado** com cores contrastantes
- **Histórico de conversas** persistente

### 📊 Área de Projetos
- **Visualização em grid** dos projetos
- **Filtros avançados** expansíveis:
  - Categoria (Inovação, Pesquisa, Desenvolvimento, Melhoria)
  - Status (Em Andamento, Finalizado, Pendente, Cancelado)
  - Data estimada (Mais Próxima, Mais Distante, Recente, Antiga)
  - **Favoritos** (projetos marcados como favoritos)
- **Busca inteligente** por nome, descrição e tecnologia
- **Ações diretas** nos cards (Editar, Deletar, Ver Detalhes)
- **Seleção múltipla** de projetos

### 📋 Detalhamento de Projetos
- **Visão completa** do projeto selecionado
- **Insights do ChallengeBot** baseados no status real
- **Informações detalhadas**:
  - Status atual com cores dinâmicas
  - Responsável e área responsável
  - Tecnologia utilizada
  - Datas de conclusão e críticas
  - Descrição completa
- **Design profissional** com cards organizados

### 🎨 Interface e UX
- **Design moderno** com paleta preto/branco/cinza
- **Animações suaves** e transições
- **Responsividade** para diferentes tamanhos de tela
- **Navegação intuitiva** com bottom navigation
- **Feedback visual** para todas as ações

## 🛠️ Tecnologias Utilizadas

### Frontend
- **Flutter 3.8.0+** - Framework principal
- **Dart** - Linguagem de programação
- **Material Design** - Design system

### Backend e Armazenamento
- **Firebase Authentication** - Autenticação de usuários
- **Cloud Firestore** - Banco de dados em tempo real
- **Hive** - Armazenamento local offline
- **Shared Preferences** - Configurações do usuário

### Integrações
- **Gemini AI** - Assistente inteligente via API
- **HTTP** - Comunicação com APIs externas
- **Path Provider** - Gerenciamento de arquivos
- **Share Plus** - Compartilhamento de dados

## 📱 Telas do Sistema

### 1. **Tela de Login**
- Autenticação segura
- Validação de campos
- Feedback de erros

### 2. **Tela Inicial (Home)**
- Carrossel de projetos com scroll automático
- Botão flutuante do ChallengeBot
- Menu de perfil lateral
- Sincronização com Firebase

### 3. **ChallengeBot**
- Interface de chat moderna
- Integração com IA
- Análise de projetos
- Histórico de conversas

### 4. **Área de Projetos**
- Grid de projetos
- Filtros avançados
- Busca inteligente
- Ações diretas nos cards

### 5. **Detalhamento de Projeto**
- Visão completa do projeto
- Insights inteligentes
- Informações organizadas
- Design profissional

## 🚀 Instalação e Configuração

### Pré-requisitos
- Flutter SDK 3.8.0 ou superior
- Dart SDK
- Android Studio / VS Code
- Conta Firebase configurada

### 1. Clone o repositório
```bash
git clone [URL_DO_REPOSITORIO]
cd sprint_3
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Configure o Firebase
- Adicione o arquivo `google-services.json` na pasta `android/app/`
- Configure o `firebase_options.dart` com suas credenciais

### 4. Gere os adapters do Hive
```bash
flutter packages pub run build_runner build
```

### 5. Execute o projeto
```bash
flutter run
```

## 📦 Geração de APK

### APK de Debug (para testes)
```bash
flutter build apk --debug
```

### APK de Release (para produção)
```bash
flutter build apk --release
```

### APK Universal (todas as arquiteturas)
```bash
flutter build apk --release
```

### APK com Split por Arquitetura (menor tamanho)
```bash
flutter build apk --split-per-abi --release
```

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── login_screen.dart                  # Tela de login
├── home_screen.dart                   # Tela inicial
├── project_customization_screen.dart  # Área de projetos
├── add_project_screen.dart            # Adicionar projeto
├── edit_project_screen.dart           # Editar projeto
├── models/
│   ├── project.dart                   # Modelo de dados do projeto
│   └── project.g.dart                 # Gerado pelo Hive
├── screens/
│   ├── challenge_bot_screen.dart      # Tela do ChallengeBot
│   └── project_details_screen.dart    # Detalhamento do projeto
├── services/
│   ├── auth_service.dart              # Serviço de autenticação
│   ├── project_storage_service.dart   # Serviço de armazenamento
│   └── cloud_sync_service.dart        # Sincronização com Firebase
└── widgets/
    ├── draggable_chatbot_button.dart  # Botão flutuante do chatbot
    ├── profile_drawer.dart            # Menu lateral de perfil
    ├── project_card.dart              # Card de projeto no carrossel
    ├── project_carousel.dart          # Carrossel de projetos
    ├── project_customization_card.dart # Card de projeto na área
    ├── project_search_bar.dart        # Barra de busca
    ├── expandable_filter_slider.dart  # Filtros expansíveis
    └── modern_filter_panel.dart       # Painel de filtros (legado)
```

## 🔧 Configurações Avançadas

### Firebase
- Configure o projeto no [Firebase Console](https://console.firebase.google.com)
- Ative Authentication e Firestore
- Configure as regras de segurança

### Hive
- Os adapters são gerados automaticamente
- Dados são armazenados localmente para funcionamento offline
- Sincronização automática com Firebase quando online

### Gemini AI
- Configure sua API key no serviço de autenticação
- Ajuste os prompts conforme necessário
- Monitore o uso da API

## 📊 Funcionalidades de Dados

### Modelo de Projeto
```dart
class Project {
  String id;                    // ID único
  String name;                  // Nome do projeto
  String category;              // Categoria
  double rating;                // Avaliação
  int interactions;             // Número de interações
  String unit;                  // Unidade responsável
  String status;                // Status atual
  bool isNew;                   // Projeto novo
  bool isFavorited;             // Favoritado
  String responsibleArea;       // Área responsável
  String responsiblePerson;     // Pessoa responsável
  String technology;            // Tecnologia utilizada
  String description;           // Descrição
  DateTime estimatedCompletionDate; // Data estimada
  DateTime criticalDate;        // Data crítica
  String? ownerUserId;          // ID do proprietário
}
```

### Filtros Disponíveis
- **Categoria**: Inovação, Pesquisa, Desenvolvimento, Melhoria
- **Status**: Em Andamento, Finalizado, Pendente, Cancelado
- **Data**: Mais Próxima, Mais Distante, Recente, Antiga
- **Favoritos**: Apenas projetos marcados como favoritos
- **Busca**: Por nome, descrição ou tecnologia

## 🎯 Casos de Uso

### Para Gestores
- Visualizar todos os projetos em andamento
- Filtrar por categoria e status
- Acompanhar prazos e responsáveis
- Obter insights do ChallengeBot

### Para Desenvolvedores
- Gerenciar projetos técnicos
- Acompanhar tecnologias utilizadas
- Organizar por favoritos
- Detalhar informações técnicas

### Para Equipes
- Colaborar em projetos
- Compartilhar informações
- Acompanhar progresso
- Comunicar via ChallengeBot

## 🔒 Segurança

- **Autenticação obrigatória** para todas as funcionalidades
- **Dados criptografados** localmente com Hive
- **Sincronização segura** com Firebase
- **Validação de entrada** em todos os formulários
- **Logout automático** em caso de erro de autenticação

## 🚀 Performance

- **Carregamento otimizado** com lazy loading
- **Cache local** para funcionamento offline
- **Sincronização inteligente** apenas quando necessário
- **Interface responsiva** com animações suaves
- **Memória otimizada** com disposição adequada de recursos

## 🐛 Solução de Problemas

### Erro de Compilação
```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build
```

### Erro de Firebase
- Verifique se o `google-services.json` está correto
- Confirme se o projeto Firebase está ativo
- Verifique as regras de segurança do Firestore

### Erro de Hive
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### APK não gera
- Verifique se o Android SDK está configurado
- Execute `flutter doctor` para diagnosticar problemas
- Teste primeiro com `flutter build apk --debug`

## 📈 Roadmap Futuro

- [ ] Notificações push
- [ ] Relatórios em PDF
- [ ] Integração com calendário
- [ ] Chat em tempo real
- [ ] Dashboard de métricas
- [ ] Exportação de dados
- [ ] Modo escuro
- [ ] Suporte a múltiplos idiomas

## 👥 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 📞 Suporte

Para suporte e dúvidas:
- Abra uma issue no repositório
- Entre em contato com a equipe de desenvolvimento
- Consulte a documentação do Flutter

---

**Desenvolvido com ❤️ usando Flutter e Firebase**