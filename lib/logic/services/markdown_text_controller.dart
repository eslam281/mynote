import 'package:flutter/material.dart';

class MarkdownTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    
    // Regular expressions for markdown patterns
    // We use non-capturing groups for the markers but capturing for the content
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final italicRegex = RegExp(r'\*(.*?)\*');
    final bulletRegex = RegExp(r'^•\s.*', multiLine: true);

    // Combine them into one regex for splitMapJoin
    // We need to be careful with overlapping matches (like bold containing italic)
    // Here we prioritize Bold then Italic
    final combinedRegex = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*|^•\s.*', multiLine: true);

    text.splitMapJoin(
      combinedRegex,
      onMatch: (Match match) {
        final matchText = match[0]!;
        
        // Group 1 is Bold content, Group 2 is Italic content
        if (matchText.startsWith('**') && matchText.endsWith('**')) {
          final content = match.group(1) ?? '';
          _addStyled(children, '**', content, '**', style?.copyWith(fontWeight: FontWeight.bold));
        } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
          final content = match.group(2) ?? match.group(0)?.replaceAll('*', '') ?? '';
          _addStyled(children, '*', content, '*', style?.copyWith(fontStyle: FontStyle.italic));
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
    // Hide markers by making them nearly invisible
    children.add(TextSpan(
      text: pre,
      style: style?.copyWith(color: Colors.transparent, fontSize: 0.1),
    ));
    children.add(TextSpan(
      text: content,
      style: style,
    ));
    children.add(TextSpan(
      text: post,
      style: style?.copyWith(color: Colors.transparent, fontSize: 0.1),
    ));
  }
}
