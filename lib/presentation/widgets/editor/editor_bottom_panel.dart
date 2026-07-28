import 'package:flutter/material.dart';

class EditorBottomPanel extends StatelessWidget {
  final int selectedColor;
  final List<int> colors;
  final Function(int) onColorSelected;
  final VoidCallback onPickImage;
  final VoidCallback onPickFile;

  const EditorBottomPanel({
    super.key,
    required this.selectedColor,
    required this.colors,
    required this.onColorSelected,
    required this.onPickImage,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.image_outlined), onPressed: onPickImage),
              IconButton(icon: const Icon(Icons.attach_file_rounded), onPressed: onPickFile),
              const Spacer(),
              const Text('Background Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final colorValue = colors[index];
                final isSelected = selectedColor == colorValue;
                return GestureDetector(
                  onTap: () => onColorSelected(colorValue),
                  child: Container(
                    width: 45,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Color(colorValue),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.black12,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected ? const Icon(Icons.check, size: 20) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
