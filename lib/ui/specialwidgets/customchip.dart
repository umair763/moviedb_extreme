import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const CustomChip({super.key, required this.categories, required this.onCategorySelected, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        return ChoiceChip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selectedCategory == category ? Colors.black : Colors.white,
            ),
          ),
          selected: selectedCategory == category,
          onSelected: (bool selected) {
            onCategorySelected(category);
          },
          selectedColor: Colors.amber,
          backgroundColor: Colors.grey[850],
          elevation: 3,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 10),
        );
      }).toList(),
    );
  }
}
