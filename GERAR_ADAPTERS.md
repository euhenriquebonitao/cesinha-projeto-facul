# 🚀 Gerar os Adapters do Hive

## ❌ Problema Identificado:
O arquivo `project.g.dart` não foi gerado. Isso acontece porque o comando precisa ser executado corretamente.

## 🔧 Solução - Execute estes comandos na ordem:

### 1️⃣ Limpar o projeto:
```bash
cd c:\Eurofarma\sprint_3
flutter clean
```

### 2️⃣ Instalar dependências:
```bash
flutter pub get
```

### 3️⃣ Gerar os adapters (COMANDO CORRETO):
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4️⃣ Verificar se foi gerado:
Após executar o comando acima, você deve ver um arquivo `lib/models/project.g.dart` sendo criado.

### 5️⃣ Descomentar as linhas:

**No arquivo `lib/models/project.dart` (linha 4):**
```dart
// Mude de:
// part 'project.g.dart'; // Será gerado pelo build_runner

// Para:
part 'project.g.dart';
```

**No arquivo `lib/main.dart` (linhas 15 e 18):**
```dart
// Mude de:
// Hive.registerAdapter(ProjectAdapter());
// await ProjectStorageService.init();

// Para:
Hive.registerAdapter(ProjectAdapter());
await ProjectStorageService.init();
```

### 6️⃣ Testar:
```bash
flutter run
```

## 🎯 Resultado Esperado:
- ✅ Arquivo `project.g.dart` criado
- ✅ Sem erros vermelhos
- ✅ Hive funcionando perfeitamente

## 🆘 Se ainda não funcionar:
Execute este comando alternativo:
```bash
dart run build_runner build
```
