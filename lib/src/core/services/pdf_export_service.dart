import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/document_model.dart';

class PdfExportService {
  /// Генерирует PDF из документа и возвращает путь к файлу
  static Future<String> generatePdf(DocumentModel document) async {
    try {
      final pdf = pw.Document();

      for (int i = 0; i < document.imagePaths.length; i++) {
        final imagePath = document.imagePaths[i];
        final editedBytes = document.editedImages[i];

        Uint8List imageBytes;
        if (editedBytes != null) {
          imageBytes = editedBytes;
        } else {
          final file = File(imagePath);
          imageBytes = await file.readAsBytes();
        }

        final image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  image,
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      // Сохраняем PDF в директорию документов
      final outputDir = await getApplicationDocumentsDirectory();
      final pdfDir = Directory('${outputDir.path}/pdfs');
      if (!await pdfDir.exists()) {
        await pdfDir.create(recursive: true);
      }

      final sanitizedName = document.name.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final pdfPath = '${pdfDir.path}/${sanitizedName}_${document.id}.pdf';
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());

      dev.log('PDF создан: $pdfPath');
      return pdfPath;
    } catch (e) {
      dev.log('Ошибка создания PDF: $e');
      rethrow;
    }
  }

  /// Генерирует PDF и возвращает байты (для шаринга без сохранения)
  static Future<Uint8List> generatePdfBytes(DocumentModel document) async {
    try {
      final pdf = pw.Document();

      for (int i = 0; i < document.imagePaths.length; i++) {
        final imagePath = document.imagePaths[i];
        final editedBytes = document.editedImages[i];

        Uint8List imageBytes;
        if (editedBytes != null) {
          imageBytes = editedBytes;
        } else {
          final file = File(imagePath);
          imageBytes = await file.readAsBytes();
        }

        final image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  image,
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      return pdf.save();
    } catch (e) {
      dev.log('Ошибка генерации PDF байтов: $e');
      rethrow;
    }
  }

  /// Печать документа
  static Future<void> printDocument(DocumentModel document) async {
    try {
      final pdfBytes = await generatePdfBytes(document);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: document.name,
      );
    } catch (e) {
      dev.log('Ошибка печати: $e');
      rethrow;
    }
  }

  /// Предпросмотр PDF перед печатью
  static Future<void> previewAndPrint(DocumentModel document) async {
    try {
      final pdfBytes = await generatePdfBytes(document);
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '${document.name}.pdf',
      );
    } catch (e) {
      dev.log('Ошибка предпросмотра: $e');
      rethrow;
    }
  }
}
