@echo off
echo ========================================
echo TESTANDO APLICATIVO FLUTTER
echo ========================================

echo.
echo 1. Limpando cache do Flutter...
flutter clean

echo.
echo 2. Obtendo dependências...
flutter pub get

echo.
echo 3. Executando build_runner para regenerar adapters...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo 4. Construindo APK de release...
flutter build apk --release

echo.
echo 5. APK construído com sucesso!
echo Localização: build\app\outputs\flutter-apk\app-release.apk

echo.
echo ========================================
echo TESTE CONCLUÍDO
echo ========================================
pause
