import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/models/document_model.dart';
import '../../../core/repositories/document_scan_repository.dart';
import '../../../core/services/image_editing_service.dart';

class PdfViewModel extends ChangeNotifier {
  final DocumentScanRepository _repository = DocumentScanRepository();

  DocumentModel? _document;
  bool _isLoading = false;

  DocumentModel? get document => _document;
  List<String> get scannedImages => _document?.imagePaths ?? [];
  Map<int, Uint8List?> get editedImages => _document?.editedImages ?? {};
  bool get isLoading => _isLoading;
  bool get hasImages => _document?.hasImages ?? false;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> scanDocument() async {
    try {
      _setLoading(true);
      final imagesPath = await _repository.scanDocuments();
      if (imagesPath != null && imagesPath.isNotEmpty) {
        _document = DocumentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Document ${DateTime.now().day}/${DateTime.now().month}',
          imagePaths: imagesPath,
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow; // Пробрасываем ошибку для обработки в UI
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editImage(
      BuildContext context, String imagePath, int index) async {
    final editedBytes =
        await ImageEditingService.openImageEditor(context, imagePath);

    if (editedBytes != null) {
      await _saveEditedImage(imagePath, index, editedBytes);
    }
  }

  Future<void> _saveEditedImage(
      String imagePath, int index, Uint8List bytes) async {
    try {
      // Сохраняем отредактированное изображение в файл
      await _repository.saveEditedImage(imagePath, bytes);

      // Обновляем модель документа
      if (_document != null) {
        final updatedEditedImages =
            Map<int, Uint8List?>.from(_document!.editedImages);
        updatedEditedImages[index] = bytes;

        _document = _document!.copyWith(editedImages: updatedEditedImages);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  bool isImageEdited(int index) {
    return _document?.isImageEdited(index) ?? false;
  }

  Widget buildImageWidget(int index) {
    if (_document == null || index >= _document!.imagePaths.length) {
      return const Center(child: Text('Изображение не найдено'));
    }

    return ImageEditingService.buildImageWidget(
      imagePath: _document!.imagePaths[index],
      index: index,
      editedImageBytes: _document!.editedImages[index],
    );
  }
}
