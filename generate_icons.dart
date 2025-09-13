import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

void main() async {
  print('🎨 Gerando ícones do Challenge Vision...');
  
  try {
    // Ler a imagem original
    final ByteData data = await rootBundle.load('assets/images/images-challenge-vision.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final img.Image? originalImage = img.decodeImage(bytes);
    
    if (originalImage == null) {
      print('❌ Erro: Não foi possível carregar a imagem');
      return;
    }
    
    print('✅ Imagem carregada com sucesso: ${originalImage.width}x${originalImage.height}');
    
    // Tamanhos de ícone necessários para Android
    final List<int> androidSizes = [48, 72, 96, 144, 192];
    
    // Gerar ícones para Android
    for (int size in androidSizes) {
      final img.Image resized = img.copyResize(originalImage, width: size, height: size);
      final File outputFile = File('android/app/src/main/res/mipmap-hdpi/ic_launcher.png');
      
      // Criar diretório se não existir
      await outputFile.parent.create(recursive: true);
      
      // Salvar arquivo
      await outputFile.writeAsBytes(img.encodePng(resized));
      print('✅ Ícone Android ${size}x${size} gerado');
    }
    
    // Tamanhos de ícone necessários para iOS
    final List<int> iosSizes = [20, 29, 40, 58, 60, 76, 80, 87, 114, 120, 152, 167, 180, 1024];
    
    // Gerar ícones para iOS
    for (int size in iosSizes) {
      final img.Image resized = img.copyResize(originalImage, width: size, height: size);
      final File outputFile = File('ios/Runner/Assets.xcassets/AppIcon.appiconset/icon_${size}.png');
      
      // Criar diretório se não existir
      await outputFile.parent.create(recursive: true);
      
      // Salvar arquivo
      await outputFile.writeAsBytes(img.encodePng(resized));
      print('✅ Ícone iOS ${size}x${size} gerado');
    }
    
    print('🎉 Todos os ícones foram gerados com sucesso!');
    print('📱 Agora você pode compilar o aplicativo com o novo ícone.');
    
  } catch (e) {
    print('❌ Erro ao gerar ícones: $e');
  }
}
