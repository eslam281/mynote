import 'package:flutter/material.dart';

class EditorBottomPanel extends StatelessWidget {
  final int selectedColor;
  final List<int> colors;
  final Function(int) onColorSelected;
  final VoidCallback onPickImage;
  final VoidCallback onPickFile;
  final Color contentColor;

  const EditorBottomPanel({
    super.key,
    required this.selectedColor,
    required this.colors,
    required this.onColorSelected,
    required this.onPickImage,
    required this.onPickFile,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: contentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: contentColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            _actionButton(Icons.image_outlined, onPickImage),
            _actionButton(Icons.attach_file_rounded, onPickFile),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final colorValue = colors[index];
                    final isSelected = selectedColor == colorValue;
                    return GestureDetector(
                      onTap: () => onColorSelected(colorValue),
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Color(colorValue),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? contentColor : Colors.black12,
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                          ] : null,
                        ),
                        child: isSelected 
                          ? Icon(Icons.check, size: 14, color: contentColor) 
                          : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: contentColor.withValues(alpha: 0.7), size: 20),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
