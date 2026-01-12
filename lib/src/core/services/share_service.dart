import 'dart:developer' as dev;
import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../models/document_model.dart';
import 'pdf_export_service.dart';

class ShareService {
  /// Поделиться документом как PDF
  static Future<void> sharePdf(DocumentModel document) async {
    try {
      // Генерируем PDF
      final pdfPath = await PdfExportService.generatePdf(document);
      final pdfFile = XFile(pdfPath);

      // Шарим файл
      await Share.shareXFiles(
        [pdfFile],
        text: document.name,
        subject: document.name,
      );

      dev.log('PDF отправлен на шаринг: ${document.name}');
    } catch (e) {
      dev.log('Ошибка шаринга PDF: $e');
      rethrow;
    }
  }

  /// Поделиться отдельными изображениями
  static Future<void> shareImages(DocumentModel document) async {
    try {
      final List<XFile> files = [];

      for (int i = 0; i < document.imagePaths.length; i++) {
        final imagePath = document.imagePaths[i];
        final file = File(imagePath);

        if (await file.exists()) {
          files.add(XFile(imagePath));
        }
      }

      if (files.isNotEmpty) {
        await Share.shareXFiles(
          files,
          text: '${document.name} - ${document.pageCount} страниц',
        );
      }

      dev.log('Изображения отправлены на шаринг: ${files.length} файлов');
    } catch (e) {
      dev.log('Ошибка шаринга изображений: $e');
      rethrow;
    }
  }

  /// Поделиться одной страницей
  static Future<void> shareSinglePage(
    DocumentModel document,
    int pageIndex,
  ) async {
    try {
      if (pageIndex < 0 || pageIndex >= document.imagePaths.length) {
        throw Exception('Неверный индекс страницы');
      }

      final imagePath = document.imagePaths[pageIndex];
      final file = File(imagePath);

      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: '${document.name} - Страница ${pageIndex + 1}',
        );
      }
    } catch (e) {
      dev.log('Ошибка шаринга страницы: $e');
      rethrow;
    }
  }
}
