import 'package:flutter/material.dart';

class ModernFilterPanel extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedStatus;
  final String? selectedDateOrder;
  final Function(String?, String?, String?) onFiltersChanged;

  const ModernFilterPanel({
    super.key,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.selectedDateOrder,
    required this.onFiltersChanged,
  });

  @override
  State<ModernFilterPanel> createState() => _ModernFilterPanelState();
}

class _ModernFilterPanelState extends State<ModernFilterPanel> {
  String? _selectedCategory;
  String? _selectedStatus;
  String? _selectedDateOrder;

  final List<String> _categories = [
    'Tecnologia',
    'Saúde',
    'E-commerce',
    'Mobile',
    'Web',
    'IA',
    'Blockchain',
    'IoT',
    'Games',
    'Educação',
  ];

  final List<String> _statuses = [
    'Em Andamento',
    'Concluído',
    'Pausado',
    'Planejamento',
    'Teste',
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text(
                    'Limpar',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          
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

  bool _hasActiveFilters() {
    return _selectedCategory != null || 
           _selectedStatus != null || 
           _selectedDateOrder != null;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedStatus = null;
      _selectedDateOrder = null;
    });
    _notifyFiltersChanged();
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged(_selectedCategory, _selectedStatus, _selectedDateOrder);
  }
}
