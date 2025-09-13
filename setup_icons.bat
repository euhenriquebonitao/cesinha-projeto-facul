@echo off
echo 🎨 Configurando ícones do Challenge Vision...

REM Criar diretórios se não existirem
if not exist "android\app\src\main\res\mipmap-hdpi" mkdir "android\app\src\main\res\mipmap-hdpi"
if not exist "android\app\src\main\res\mipmap-mdpi" mkdir "android\app\src\main\res\mipmap-mdpi"
if not exist "android\app\src\main\res\mipmap-xhdpi" mkdir "android\app\src\main\res\mipmap-xhdpi"
if not exist "android\app\src\main\res\mipmap-xxhdpi" mkdir "android\app\src\main\res\mipmap-xxhdpi"
if not exist "android\app\src\main\res\mipmap-xxxhdpi" mkdir "android\app\src\main\res\mipmap-xxxhdpi"

REM Copiar imagem para diferentes resoluções do Android
copy "assets\images\images-challenge-vision.png" "android\app\src\main\res\mipmap-mdpi\ic_launcher.png"
copy "assets\images\images-challenge-vision.png" "android\app\src\main\res\mipmap-hdpi\ic_launcher.png"
copy "assets\images\images-challenge-vision.png" "android\app\src\main\res\mipmap-xhdpi\ic_launcher.png"
copy "assets\images\images-challenge-vision.png" "android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png"
copy "assets\images\images-challenge-vision.png" "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"

REM Criar diretório iOS se não existir
if not exist "ios\Runner\Assets.xcassets\AppIcon.appiconset" mkdir "ios\Runner\Assets.xcassets\AppIcon.appiconset"

REM Copiar imagem para iOS
copy "assets\images\images-challenge-vision.png" "ios\Runner\Assets.xcassets\AppIcon.appiconset\AppIcon.png"

echo ✅ Ícones configurados com sucesso!
echo 📱 Agora você pode compilar o aplicativo com o novo ícone.
echo.
echo Para compilar:
echo   flutter clean
echo   flutter pub get
echo   flutter build apk
echo.
pause
