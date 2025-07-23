import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'animated_popup.dart';

Future<void> showDocumentGeneratePopup(BuildContext context) async => await showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => DocumentGeneratePopup(),
);

class DocumentGeneratePopup extends ConsumerWidget {
  const DocumentGeneratePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedPopup(
      child: AlertDialog(
        scrollable: true,
        title: Text('Excel Statement'),
        content: SizedBox(
          width: min(500, size.width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Your',
                  style: Theme.of(context).textTheme.labelLarge,
                  children: [
                    TextSpan(
                      text: ' Excel ',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: 'file has been generated successfully.',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).dividerColor.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
