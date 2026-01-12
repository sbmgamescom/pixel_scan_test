import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/models/document_model.dart';
import '../../../core/repositories/document_scan_repository.dart';
import '../../../core/services/document_storage_service.dart';
import '../../../core/services/image_editing_service.dart';
import '../../../core/services/pdf_import_service.dart';

class PdfViewModel extends ChangeNotifier {
  final DocumentScanRepository _repository = DocumentScanRepository();

  DocumentModel? _document;
  bool _isLoading = false;
  int _currentPageIndex = 0;

  DocumentModel? get document => _document;
  List<String> get scannedImages => _document?.imagePaths ?? [];
  Map<int, Uint8List?> get editedImages => _document?.editedImages ?? {};
  bool get isLoading => _isLoading;
  bool get hasImages => _document?.hasImages ?? false;
  int get currentPageIndex => _currentPageIndex;
  int get totalPages => scannedImages.length;

  /// Загрузить существующий документ
  void loadDocument(DocumentModel document) {
    _document = document;
    _currentPageIndex = 0;
    notifyListeners();
  }

  void setCurrentPage(int index) {
    if (index >= 0 && index < totalPages) {
      _currentPageIndex = index;
      notifyListeners();
    }
  }

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
          name: 'Документ ${DateTime.now().day}.${DateTime.now().month}',
          imagePaths: imagesPath,
        );
        _currentPageIndex = 0;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
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
      await _repository.saveEditedImage(imagePath, bytes);

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

  Future<void> addPages() async {
    try {
      _setLoading(true);
      final newImagesPath = await _repository.scanDocuments();
      if (newImagesPath != null && newImagesPath.isNotEmpty) {
        if (_document != null) {
          final updatedImagePaths = [
            ..._document!.imagePaths,
            ...newImagesPath
          ];
          _document = _document!.copyWith(imagePaths: updatedImagePaths);
        } else {
          _document = DocumentModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'Документ ${DateTime.now().day}.${DateTime.now().month}',
            imagePaths: newImagesPath,
          );
          _currentPageIndex = 0;
        }
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Удалить страницу
  void removePage(int index) {
    if (_document != null && _document!.pageCount > 1) {
      _document = _document!.removePage(index);

      // Корректируем текущий индекс
      if (_currentPageIndex >= _document!.pageCount) {
        _currentPageIndex = _document!.pageCount - 1;
      }

      notifyListeners();
    }
  }

  /// Переместить страницу
  void movePage(int oldIndex, int newIndex) {
    if (_document != null) {
      _document = _document!.movePage(oldIndex, newIndex);

      // Корректируем текущий индекс
      if (_currentPageIndex == oldIndex) {
        _currentPageIndex = newIndex;
      } else if (oldIndex < _currentPageIndex &&
          newIndex >= _currentPageIndex) {
        _currentPageIndex--;
      } else if (oldIndex > _currentPageIndex &&
          newIndex <= _currentPageIndex) {
        _currentPageIndex++;
      }

      notifyListeners();
    }
  }

  /// Переименовать документ
  void renameDocument(String newName) {
    if (_document != null) {
      _document = _document!.copyWith(name: newName);
      notifyListeners();
    }
  }

  /// Добавить страницы из существующего документа
  Future<void> addPagesFromDocument(DocumentModel sourceDocument) async {
    try {
      _setLoading(true);
      if (_document != null) {
        final updatedImagePaths = [
          ..._document!.imagePaths,
          ...sourceDocument.imagePaths
        ];
        _document = _document!.copyWith(imagePaths: updatedImagePaths);
      } else {
        // Если документа нет, копируем исходный
        _document = sourceDocument.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        _currentPageIndex = 0;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Импортировать изображения с устройства
  Future<void> importImagesFromDevice() async {
    try {
      _setLoading(true);
      final importedDocument = await PdfImportService.importImagesFromDevice();
      if (importedDocument != null) {
        if (_document != null) {
          final updatedImagePaths = [
            ..._document!.imagePaths,
            ...importedDocument.imagePaths
          ];
          _document = _document!.copyWith(imagePaths: updatedImagePaths);
        } else {
          _document = importedDocument.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          _currentPageIndex = 0;
        }
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Импортировать PDF и добавить страницы
  Future<void> importPdfPages() async {
    try {
      _setLoading(true);
      final convertedDocument = await PdfImportService.importPdfFromDevice();
      if (convertedDocument != null) {
        if (_document != null) {
          final updatedImagePaths = [
            ..._document!.imagePaths,
            ...convertedDocument.imagePaths
          ];
          _document = _document!.copyWith(imagePaths: updatedImagePaths);
        } else {
          _document = convertedDocument.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          _currentPageIndex = 0;
        }
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Получить список сохранённых документов
  Future<List<DocumentModel>> getSavedDocuments() async {
    try {
      return await DocumentStorageService.loadAllDocuments();
    } catch (e) {
      rethrow;
    }
  }
}
