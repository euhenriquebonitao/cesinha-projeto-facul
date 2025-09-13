import 'package:flutter/material.dart';

class CategoryFilterRow extends StatelessWidget {
  final String? selectedTechnology;
  final String? selectedSector;
  final String? selectedStatus;
  final Function(String categoryType, String? value) onCategorySelected;

  const CategoryFilterRow({
    super.key,
    required this.selectedTechnology,
    required this.selectedSector,
    required this.selectedStatus,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCategoryFilterButton(context, 'Tecnologia', [
          'Tecnologia 1',
          'Tecnologia 2',
        ], selectedTechnology),
        const SizedBox(width: 10),
        _buildCategoryFilterButton(context, 'Setor', [
          'Setor 1',
          'Setor 2',
        ], selectedSector),
        const SizedBox(width: 10),
        _buildCategoryFilterButton(context, 'Status', [
          'Finalizado',
          'Em Andamento',
          'Pendente',
        ], selectedStatus),
      ],
    );
  }

  Widget _buildCategoryFilterButton(
    BuildContext context,
    String categoryType,
    List<String> options,
    String? selectedValue,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        hint: Text(
          categoryType,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onChanged: (String? newValue) {
          onCategorySelected(categoryType, newValue);
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return options.map<Widget>((String item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color:
                    item == selectedValue ||
                        (selectedValue == null && item == categoryType)
                    ? Colors.grey[400]
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color:
                      item == selectedValue ||
                          (selectedValue == null && item == categoryType)
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
