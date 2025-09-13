import 'package:flutter/material.dart';

class ProjectCustomizationSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? searchQuery;

  const ProjectCustomizationSearchBar({
    super.key,
    required this.onChanged,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Buscar por nome do projeto...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.grid_view),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ],
    );
  }
}
