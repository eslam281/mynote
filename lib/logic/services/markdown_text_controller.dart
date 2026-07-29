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
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final italicRegex = RegExp(r'\*(.*?)\*');
    final bulletRegex = RegExp(r'^•\s.*', multiLine: true);

    text.splitMapJoin(
      RegExp('${boldRegex.pattern}|${italicRegex.pattern}|${bulletRegex.pattern}'),
      onMatch: (Match match) {
        final matchText = match[0]!;
        if (boldRegex.hasMatch(matchText)) {
          children.add(TextSpan(
            text: matchText,
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ));
        } else if (italicRegex.hasMatch(matchText)) {
          children.add(TextSpan(
            text: matchText,
            style: style?.copyWith(fontStyle: FontStyle.italic),
          ));
        } else if (bulletRegex.hasMatch(matchText)) {
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
}
