@echo off
echo ========================================
echo GERANDO APK COM LOGS DETALHADOS
echo ========================================

echo.
echo 1. Limpando projeto...
flutter clean

echo.
echo 2. Obtendo dependências...
flutter pub get

echo.
echo 3. Regenerando adapters...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo 4. Gerando APK de debug (com logs)...
flutter build apk --debug

echo.
echo ========================================
echo APK GERADO COM LOGS DETALHADOS!
echo Localização: build\app\outputs\flutter-apk\app-debug.apk
echo ========================================
echo.
echo INSTRUÇÕES PARA TESTE:
echo 1. Instale o APK no celular
echo 2. Abra o terminal e execute: flutter logs
echo 3. No app, faça login com teste@exemplo.com
echo 4. Crie um projeto
echo 5. Observe os logs no terminal
echo 6. Me mande os logs completos
echo ========================================
pause
