import 'package:baas_db_downloader/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../textfield_tags/controller.dart';
import '../../../textfield_tags/textfield_tags.dart';
import '../../provider/pocketbase.p.dart';
import 'code_preview.dart';

class PocketbaseSection extends ConsumerWidget {
  const PocketbaseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pocketbaseProvider);
    final notifier = ref.read(pocketbaseProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        child: Form(
          key: notifier.formKey,
          child: Column(
            spacing: 16.0,
            children: [
              TextFormField(
                controller: notifier.urlController,
                decoration: const InputDecoration(
                  labelText: 'Pocketbase URL',
                  hintText: 'Enter your Pocketbase URL',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PocketBase URL';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: notifier.tableController,
                decoration: const InputDecoration(
                  labelText: 'Table Name',
                  hintText: 'Enter the name of the table to download',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a table name';
                  }
                  return null;
                },
              ),
              TextFieldTags<String>(
                textfieldTagsController: notifier.columnsController,
                initialTags: notifier.columns,
                textSeparators: const [',', ' '],
                letterCase: LetterCase.normal,
                inputFieldBuilder: (context, inputFieldValues) {
                  return TextFormField(
                    controller: inputFieldValues.textEditingController,
                    focusNode: inputFieldValues.focusNode,
                    decoration: InputDecoration(
                      hintText: 'Add column and press Enter',
                      border: const OutlineInputBorder(),
                      prefixIcon: notifier.columns.isNotEmpty
                          ? SingleChildScrollView(
                              controller: inputFieldValues.tagScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: notifier.columns.map((barcode) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Chip(
                                      label: Text(
                                        barcode,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      visualDensity: const VisualDensity(
                                        horizontal: -2,
                                        vertical: -2,
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: kPrimaryColor,
                                      deleteIconColor: Colors.white,
                                      onDeleted: () => notifier.removeColumn(barcode),
                                      deleteButtonTooltipMessage: '',
                                      deleteIcon: const Icon(Icons.close, size: 17),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : null,
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && (v.endsWith(',') || v.endsWith(' '))) {
                        final tag = v.substring(0, v.length - 1).trim();
                        if (tag.isNotEmpty) {
                          notifier.addColumn(tag);
                          inputFieldValues.textEditingController.clear();
                        }
                      }
                    },
                    validator: (_) => null,
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        notifier.addColumn(value);
                        inputFieldValues.textEditingController.clear();
                      }
                    },
                  );
                },
              ),
              Row(
                spacing: 16.0,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Download functionality coming soon!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      label: const Text('Download Data', style: TextStyle(fontSize: 16)),
                      icon: const Icon(Icons.download, size: 20),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async => await notifier.submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      label: const Text('Show Data', style: TextStyle(fontSize: 16)),
                      icon: const Icon(Icons.visibility, size: 20),
                    ),
                  ),
                ],
              ),
              if (notifier.jsonData.isNotEmpty) CodePreview(jsonData: {'data': notifier.jsonData}),
            ],
          ),
        ),
      ),
    );
  }
}
