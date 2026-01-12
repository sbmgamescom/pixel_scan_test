import 'dart:developer' as dev;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../models/document_model.dart';

class PdfImportService {
  /// Открыть диалог выбора PDF файла и импортировать его
  static Future<DocumentModel?> importPdfFromDevice() async {
    try {
      // Открываем диалог выбора файла
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.first;
      if (file.path == null) {
        throw Exception('Не удалось получить путь к файлу');
      }

      // Конвертируем PDF в изображения
      final imagePaths = await _convertPdfToImages(file.path!, file.name);

      if (imagePaths.isEmpty) {
        throw Exception('Не удалось извлечь страницы из PDF');
      }

      // Создаём документ
      final document = DocumentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: file.name.replaceAll('.pdf', ''),
        imagePaths: imagePaths,
      );

      dev.log('PDF импортирован: ${file.name}, ${imagePaths.length} страниц');
      return document;
    } catch (e) {
      dev.log('Ошибка импорта PDF: $e');
      rethrow;
    }
  }

  /// Конвертировать PDF файл в список изображений
  static Future<List<String>> _convertPdfToImages(
    String pdfPath,
    String fileName,
  ) async {
    final List<String> imagePaths = [];

    try {
      // Открываем PDF документ
      final document = await PdfDocument.openFile(pdfPath);
      final pageCount = document.pagesCount;

      // Получаем директорию для сохранения
      final appDir = await getApplicationDocumentsDirectory();
      final docId = DateTime.now().millisecondsSinceEpoch.toString();
      final imagesDir = Directory('${appDir.path}/imported_pdfs/$docId');

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Конвертируем каждую страницу
      for (int i = 1; i <= pageCount; i++) {
        final page = await document.getPage(i);

        // Рендерим страницу в изображение
        final pageImage = await page.render(
          width: page.width * 2, // 2x для лучшего качества
          height: page.height * 2,
          format: PdfPageImageFormat.jpeg,
          quality: 90,
        );

        if (pageImage != null) {
          final imagePath = '${imagesDir.path}/page_$i.jpg';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(pageImage.bytes);
          imagePaths.add(imagePath);
        }

        await page.close();
      }

      await document.close();

      dev.log('Конвертировано $pageCount страниц из PDF');
      return imagePaths;
    } catch (e) {
      dev.log('Ошибка конвертации PDF: $e');
      rethrow;
    }
  }

  /// Импортировать изображения с устройства
  static Future<DocumentModel?> importImagesFromDevice() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      // Получаем директорию для сохранения
      final appDir = await getApplicationDocumentsDirectory();
      final docId = DateTime.now().millisecondsSinceEpoch.toString();
      final imagesDir = Directory('${appDir.path}/imported_images/$docId');

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final List<String> imagePaths = [];

      // Копируем изображения в постоянное хранилище
      for (int i = 0; i < result.files.length; i++) {
        final file = result.files[i];
        if (file.path != null) {
          final newPath = '${imagesDir.path}/page_${i + 1}.jpg';
          await File(file.path!).copy(newPath);
          imagePaths.add(newPath);
        }
      }

      if (imagePaths.isEmpty) {
        return null;
      }

      final document = DocumentModel(
        id: docId,
        name: 'Импорт ${DateTime.now().day}.${DateTime.now().month}',
        imagePaths: imagePaths,
      );

      dev.log('Импортировано ${imagePaths.length} изображений');
      return document;
    } catch (e) {
      dev.log('Ошибка импорта изображений: $e');
      rethrow;
    }
  }
}
