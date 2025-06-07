import 'dart:io';
import 'dart:typed_data';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class DocumentScanRepository {
  Future<List<String>?> scanDocuments() async {
    try {
      return await CunningDocumentScanner.getPictures();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveEditedImage(String imagePath, Uint8List bytes) async {
    try {
      final file = File(imagePath);
      await file.writeAsBytes(bytes);
    } catch (e) {
      rethrow;
    }
  }
}
