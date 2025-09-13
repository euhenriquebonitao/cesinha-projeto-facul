import 'package:flutter/material.dart';
import 'package:challenge_vision/models/project.dart';
import 'package:challenge_vision/widgets/project_card.dart';
import 'dart:async';

class ProjectCarousel extends StatefulWidget {
  final List<Project> filteredProjects;
  final String searchQuery;
  final VoidCallback onClearSearch;

  const ProjectCarousel({
    super.key,
    required this.filteredProjects,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    if (widget.filteredProjects.length <= 1) return;
    
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % widget.filteredProjects.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _restartAutoScroll() {
    _stopAutoScroll();
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(ProjectCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reiniciar animação se a lista de projetos mudou
    if (oldWidget.filteredProjects.length != widget.filteredProjects.length) {
      _restartAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detectar se é desktop baseado na largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;
    
    return Column(
      children: [
        SizedBox(
          height: isDesktop ? null : 315, // Altura fixa apenas para mobile/tablet
          child: widget.filteredProjects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        widget.searchQuery.isNotEmpty
                            ? 'Nenhum projeto encontrado com "${widget.searchQuery}"'
                            : 'Nenhum projeto encontrado',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: widget.onClearSearch,
                          child: const Text(
                            'Limpar busca',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : isDesktop 
                  ? _buildDesktopLayout()
                  : GestureDetector(
                      onPanStart: (_) => _stopAutoScroll(),
                      onPanEnd: (_) => _restartAutoScroll(),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemCount: widget.filteredProjects.length,
                        itemBuilder: (context, index) {
                          return ProjectCard(project: widget.filteredProjects[index]);
                        },
                      ),
                    ),
        ),
        // Indicadores de página (apenas para mobile/tablet)
        if (!isDesktop && widget.filteredProjects.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.filteredProjects.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index 
                      ? Colors.blue 
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout() {
    // Para desktop, mostrar cards em uma grade responsiva
    final screenWidth = MediaQuery.of(context).size.width;
    final cardsPerRow = (screenWidth / 400).floor().clamp(2, 4); // Entre 2 e 4 cards por linha
    
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: widget.filteredProjects.map((project) => 
          ProjectCard(project: project),
        ).toList(),
      ),
    );
  }
}
