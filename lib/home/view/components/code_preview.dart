import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodePreview extends StatelessWidget {
  const CodePreview({super.key, required this.jsonData, this.title});

  final List<Map<String, dynamic>> jsonData;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = BorderRadius.circular(10.0);
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);
    final lines = jsonString.split('\n');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: defaultBorderRadius,
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF21262D),
              borderRadius: BorderRadius.only(
                topLeft: defaultBorderRadius.topLeft,
                topRight: defaultBorderRadius.topRight,
              ),
              border: Border(bottom: BorderSide(color: const Color(0xFF30363D))),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, size: 16, color: Color(0xFF8B949E)),
                const SizedBox(width: 8),
                Text(
                  '${title ?? 'output'}.json',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE6EDF3),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async => copyToClipboard(jsonString, context: context, showText: false),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF30363D),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: const Icon(Icons.copy, size: 14, color: Color(0xFF8B949E)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      color: const Color(0xFF0D1117),
                      child: Column(
                        children: List.generate(
                          lines.length,
                          (index) => Container(
                            height: 20,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'JetBrainsMono',
                                color: Color(0xFF656D76),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: const Color(0xFF30363D)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              lines.length,
                              (index) => Container(
                                height: 20,
                                alignment: Alignment.centerLeft,
                                child: _buildSyntaxHighlightedText(lines[index], true),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyntaxHighlightedText(String line, bool isDark) {
    final spans = <TextSpan>[];
    final regex = RegExp(
      r'(".*?")|(\{|\}|\[|\])|(\btrue\b|\bfalse\b|\bnull\b)|(\d+\.?\d*)|(:)|(,)',
    );

    int lastMatch = 0;
    for (final match in regex.allMatches(line)) {
      if (match.start > lastMatch) {
        spans.add(
          TextSpan(
            text: line.substring(lastMatch, match.start),
            style: TextStyle(color: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292F)),
          ),
        );
      }

      final matchText = match.group(0)!;
      Color color;

      if (match.group(1) != null) {
        color = isDark ? const Color(0xFF7EE787) : const Color(0xFF0A3069);
      } else if (match.group(2) != null) {
        color = isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292F);
      } else if (match.group(3) != null) {
        color = isDark ? const Color(0xFF79C0FF) : const Color(0xFF0550AE);
      } else if (match.group(4) != null) {
        color = isDark ? const Color(0xFF79C0FF) : const Color(0xFF0550AE);
      } else if (match.group(5) != null) {
        color = isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292F);
      } else {
        color = isDark ? const Color(0xFF8B949E) : const Color(0xFF656D76);
      }

      spans.add(
        TextSpan(
          text: matchText,
          style: TextStyle(color: color),
        ),
      );

      lastMatch = match.end;
    }

    if (lastMatch < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(lastMatch),
          style: TextStyle(color: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292F)),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, fontFamily: 'JetBrainsMono', height: 1.2),
        children: spans,
      ),
    );
  }
}

Future<void> copyToClipboard(String text, {BuildContext? context, bool showText = true}) async {
  await Clipboard.setData(ClipboardData(text: text)).then((_) {
    if (context == null) return;
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(showText ? 'Copied to clipboard! [$text]' : 'Copied to clipboard!')),
    );
  });
}

Future<String> getClipboardData() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text ?? '';
}
