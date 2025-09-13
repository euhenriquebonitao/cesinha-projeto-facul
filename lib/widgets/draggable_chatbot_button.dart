import 'package:flutter/material.dart';

class DraggableChatbotButton extends StatefulWidget {
  final VoidCallback onTap;
  final double initialX;
  final double initialY;

  const DraggableChatbotButton({
    super.key,
    required this.onTap,
    this.initialX = 0.8,
    this.initialY = 0.7,
  });

  @override
  State<DraggableChatbotButton> createState() => _DraggableChatbotButtonState();
}

class _DraggableChatbotButtonState extends State<DraggableChatbotButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  Offset _position = const Offset(0, 0);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    
    // Animação de pulso
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animação de bounce
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animação de pulso
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Posicionar o botão baseado nas dimensões da tela
    final screenSize = MediaQuery.of(context).size;
    _position = Offset(
      screenSize.width * widget.initialX,
      screenSize.height * widget.initialY,
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
    _pulseController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
    
    // Verificar se o botão está fora da tela e reposicionar
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = 60.0;
    
    double newX = _position.dx;
    double newY = _position.dy;
    
    // Limitar dentro dos limites da tela
    newX = newX.clamp(0, screenSize.width - buttonSize);
    newY = newY.clamp(0, screenSize.height - buttonSize - 100); // 100px de margem para o bottom nav
    
    setState(() {
      _position = Offset(newX, newY);
    });
    
    // Reiniciar animação de pulso
    _pulseController.repeat(reverse: true);
  }

  void _onTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _bounceAnimation]),
          builder: (context, child) {
            final scale = _isDragging ? 1.0 : _pulseAnimation.value * _bounceAnimation.value;
            
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C2C2C),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: _isDragging ? 15 : 8,
                      spreadRadius: _isDragging ? 2 : 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Ícone do ChallengeMind
                    const Center(
                      child: Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    // Pequeno indicador de notificação
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Efeito de ondas quando não está sendo arrastado
                    if (!_isDragging)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
