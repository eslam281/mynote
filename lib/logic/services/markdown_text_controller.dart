import 'package:flutter/material.dart';

class MarkdownTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    
    // Regular expression that matches Bold+Italic (***), Bold (**), or Italic (*)
    // The order matters: match longest first.
    final combinedRegex = RegExp(r'(\*\*\*(.*?)\*\*\*)|(\*\*(.*?)\*\*)|(\*(.*?)\*)|(^•\s.*)', multiLine: true);

    text.splitMapJoin(
      combinedRegex,
      onMatch: (Match match) {
        final matchText = match[0]!;
        
        if (matchText.startsWith('***') && matchText.endsWith('***')) {
          // Bold + Italic
          final content = match.group(2) ?? '';
          _addStyled(children, '***', content, '***', 
            style?.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic));
        } else if (matchText.startsWith('**') && matchText.endsWith('**')) {
          // Bold
          final content = match.group(4) ?? '';
          _addStyled(children, '**', content, '**', 
            style?.copyWith(fontWeight: FontWeight.bold));
        } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
          // Italic
          final content = match.group(6) ?? '';
          _addStyled(children, '*', content, '*', 
            style?.copyWith(fontStyle: FontStyle.italic));
        } else if (matchText.startsWith('•')) {
          children.add(TextSpan(
            text: matchText,
            style: style?.copyWith(color: const Color(0xFF0061A4), fontWeight: FontWeight.w600),
          ));
        }
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return TextSpan(style: style, children: children);
  }

  void _addStyled(List<TextSpan> children, String pre, String content, String post, TextStyle? style) {
    // Hide markers by making them nearly invisible and zero-sized
    // We use a very small font size to prevent them from taking up space
    children.add(TextSpan(
      text: pre,
      style: style?.copyWith(color: Colors.transparent, fontSize: 0.01),
    ));
    children.add(TextSpan(
      text: content,
      style: style,
    ));
    children.add(TextSpan(
      text: post,
      style: style?.copyWith(color: Colors.transparent, fontSize: 0.01),
    ));
  }
}
