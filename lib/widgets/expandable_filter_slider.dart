import 'package:flutter/material.dart';

class ExpandableFilterSlider extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedStatus;
  final String? selectedDateOrder;
  final bool? selectedFavorites;
  final Function(String?, String?, String?, bool?) onFiltersChanged;

  const ExpandableFilterSlider({
    super.key,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.selectedDateOrder,
    required this.selectedFavorites,
    required this.onFiltersChanged,
  });

  @override
  State<ExpandableFilterSlider> createState() => _ExpandableFilterSliderState();
}

class _ExpandableFilterSliderState extends State<ExpandableFilterSlider>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  String? _selectedCategory;
  String? _selectedStatus;
  String? _selectedDateOrder;
  bool? _selectedFavorites;

  final List<String> _categories = [
    'Inovação',
    'Pesquisa',
    'Desenvolvimento',
    'Melhoria',
  ];

  final List<String> _statuses = [
    'Em Andamento',
    'Finalizado',
    'Pendente',
    'Cancelado',
  ];

  final List<String> _dateOrders = [
    'Mais Próxima',
    'Mais Distante',
    'Recente',
    'Antiga',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedStatus = widget.selectedStatus;
    _selectedDateOrder = widget.selectedDateOrder;
    _selectedFavorites = widget.selectedFavorites;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  bool _hasActiveFilters() {
    return _selectedCategory != null || 
           _selectedStatus != null || 
           _selectedDateOrder != null ||
           _selectedFavorites == true;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedStatus = null;
      _selectedDateOrder = null;
      _selectedFavorites = null;
    });
    widget.onFiltersChanged(null, null, null, null);
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged(_selectedCategory, _selectedStatus, _selectedDateOrder, _selectedFavorites);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header do slider
          GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Filtros Avançados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  if (_hasActiveFilters())
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_getActiveFiltersCount()} ativo${_getActiveFiltersCount() > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Conteúdo expansível
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  
                  // Filtro de Categoria
                  _buildFilterSection(
                    'Categoria',
                    Icons.category,
                    _selectedCategory,
                    _categories,
                    (value) {
                      setState(() {
                        _selectedCategory = _selectedCategory == value ? null : value;
                      });
                      _notifyFiltersChanged();
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtro de Status
                  _buildFilterSection(
                    'Status',
                    Icons.flag,
                    _selectedStatus,
                    _statuses,
                    (value) {
                      setState(() {
                        _selectedStatus = _selectedStatus == value ? null : value;
                      });
                      _notifyFiltersChanged();
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtro de Data
                  _buildFilterSection(
                    'Data Estimada',
                    Icons.schedule,
                    _selectedDateOrder,
                    _dateOrders,
                    (value) {
                      setState(() {
                        _selectedDateOrder = _selectedDateOrder == value ? null : value;
                      });
                      _notifyFiltersChanged();
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtro de Favoritos
                  _buildFavoritesFilter(),
                  
                  const SizedBox(height: 16),
                  
                  // Botão limpar filtros
                  if (_hasActiveFilters())
                    Center(
                      child: TextButton.icon(
                        onPressed: _clearAllFilters,
                        icon: const Icon(Icons.clear, color: Colors.red),
                        label: const Text(
                          'Limpar Filtros',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    IconData icon,
    String? selectedValue,
    List<String> options,
    Function(String) onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFavoritesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Meus Favoritos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedFavorites = _selectedFavorites == true ? null : true;
            });
            _notifyFiltersChanged();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _selectedFavorites == true ? Colors.red : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedFavorites == true ? Colors.red : Colors.grey[400]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _selectedFavorites == true ? Icons.favorite : Icons.favorite_border,
                  color: _selectedFavorites == true ? Colors.white : Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedFavorites == true ? 'Apenas Favoritos' : 'Mostrar Favoritos',
                  style: TextStyle(
                    color: _selectedFavorites == true ? Colors.white : Colors.grey[600],
                    fontWeight: _selectedFavorites == true ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedStatus != null) count++;
    if (_selectedDateOrder != null) count++;
    if (_selectedFavorites == true) count++;
    return count;
  }
}
