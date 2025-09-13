@echo off
echo ========================================
echo INSTALAÇÃO MÍNIMA DO ANDROID SDK
echo ========================================

echo.
echo 1. Criando diretório...
if not exist "C:\Android\Sdk" mkdir "C:\Android\Sdk"

echo.
echo 2. Baixando Android SDK Command Line Tools...
curl -o "C:\Android\Sdk\commandlinetools.zip" "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"

echo.
echo 3. Extraindo...
powershell -Command "Expand-Archive -Path 'C:\Android\Sdk\commandlinetools.zip' -DestinationPath 'C:\Android\Sdk' -Force"

echo.
echo 4. Configurando variáveis de ambiente...
setx ANDROID_HOME "C:\Android\Sdk"
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\tools\bin"

echo.
echo 5. Configurando Flutter...
flutter config --android-sdk C:\Android\Sdk

echo.
echo 6. Instalando componentes necessários...
C:\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat "platform-tools" "platforms;android-33" "build-tools;33.0.0"

echo.
echo 7. Aceitando licenças...
echo y | C:\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat --licenses

echo.
echo 8. Gerando APK...
flutter build apk --release

echo.
echo ========================================
echo APK GERADO COM SUCESSO!
echo Localização: build\app\outputs\flutter-apk\app-release.apk
echo ========================================
pause


