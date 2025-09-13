@echo off
echo ========================================
echo INSTALAÇÃO AUTOMÁTICA DO ANDROID SDK
echo ========================================

echo.
echo 1. Criando diretório do Android SDK...
if not exist "C:\Android\Sdk" mkdir "C:\Android\Sdk"

echo.
echo 2. Baixando Android SDK Command Line Tools...
echo Baixando de https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip

powershell -Command "& {Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip' -OutFile 'C:\Android\Sdk\commandlinetools.zip'}"

echo.
echo 3. Extraindo arquivos...
powershell -Command "& {Expand-Archive -Path 'C:\Android\Sdk\commandlinetools.zip' -DestinationPath 'C:\Android\Sdk' -Force}"

echo.
echo 4. Configurando Flutter...
flutter config --android-sdk C:\Android\Sdk

echo.
echo 5. Instalando licenças do Android...
echo y | flutter doctor --android-licenses

echo.
echo 6. Verificando instalação...
flutter doctor

echo.
echo 7. Gerando APK...
flutter build apk --release

echo.
echo ========================================
echo INSTALAÇÃO CONCLUÍDA!
echo APK gerado em: build\app\outputs\flutter-apk\app-release.apk
echo ========================================
pause
