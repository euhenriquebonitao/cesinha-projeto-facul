@echo off
echo ========================================
echo INSTALANDO ANDROID SDK E GERANDO APK
echo ========================================

echo.
echo 1. Verificando se o Flutter está funcionando...
flutter --version

echo.
echo 2. Verificando status do Flutter Doctor...
flutter doctor

echo.
echo 3. Tentando instalar Android SDK via Flutter...
flutter config --android-sdk C:\Android\Sdk

echo.
echo 4. Criando diretório do Android SDK...
if not exist "C:\Android\Sdk" mkdir "C:\Android\Sdk"

echo.
echo 5. Baixando Android SDK Command Line Tools...
echo Por favor, baixe manualmente o Android SDK Command Line Tools de:
echo https://developer.android.com/studio#command-tools
echo E extraia para C:\Android\Sdk\

echo.
echo 6. Após instalar o Android SDK, execute:
echo flutter doctor --android-licenses
echo flutter build apk --release

echo.
echo ========================================
echo INSTALAÇÃO CONCLUÍDA
echo ========================================
pause
