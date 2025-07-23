import 'dart:convert';

import "package:universal_html/html.dart" as html;

void webDownload(List<int> bytes, [String? name]) {
  // Encode our file in base64
  final base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
    ..target = 'blank';
  // add the name
  if (name != null) anchor.download = name;

  // trigger download
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}

  // final blob = html.Blob([pdfInBytes], 'application/pdf');
  // final url = html.Url.createObjectUrlFromBlob(blob);
  // final anchor = html.document.createElement('a') as html.AnchorElement
  //   ..href = url
  //   ..style.display = 'none'
  //   ..download = '$name.pdf';
  // html.document.body?.children.add(anchor);
  // anchor.click();