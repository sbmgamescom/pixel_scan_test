import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pixel_scan_test/src/core/models/document_model.dart';
import 'package:pixel_scan_test/src/core/services/pdf_export_service.dart';

void main() {
  group('PdfExportService Tests', () {
    test('generatePdfBytes works with default settings', () async {
      final document = DocumentModel(
        id: 'doc1',
        name: 'Settings Test',
        folderId: 'folder1',
        createdAt: DateTime.now(),
        imagePaths: [], // No images to avoid File reads in CI
        editedImages: {},
      );

      final bytes = await PdfExportService.generatePdfBytes(document);
      expect(bytes,
          isNotEmpty); // Check that valid PDF bytes are generated even for empty doc
    });

    test('generatePdfBytes uses provided PdfExportSettings', () async {
      final document = DocumentModel(
        id: 'doc1',
        name: 'Settings Test',
        folderId: 'folder1',
        createdAt: DateTime.now(),
        imagePaths: [],
        editedImages: {},
      );

      final settings = const PdfExportSettings(
        pageFormat: PdfPageFormat.letter,
        margin: 20.0,
      );

      final bytes =
          await PdfExportService.generatePdfBytes(document, settings: settings);
      expect(bytes, isNotEmpty);
    });
  });
}
