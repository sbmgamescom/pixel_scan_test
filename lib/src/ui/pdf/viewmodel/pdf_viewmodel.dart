import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

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
  bool _isSelectionMode = false;
  final Set<int> _selectedPages = {};

  DocumentModel? get document => _document;
  List<String> get scannedImages => _document?.imagePaths ?? [];
  Map<int, Uint8List?> get editedImages => _document?.editedImages ?? {};
  bool get isLoading => _isLoading;
  bool get hasImages => _document?.hasImages ?? false;
  int get currentPageIndex => _currentPageIndex;
  int get totalPages => scannedImages.length;
  bool get isSelectionMode => _isSelectionMode;
  Set<int> get selectedPages => _selectedPages;

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

  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedPages.clear();
    }
    notifyListeners();
  }

  void togglePageSelection(int index) {
    if (_selectedPages.contains(index)) {
      _selectedPages.remove(index);
    } else {
      _selectedPages.add(index);
    }
    notifyListeners();
  }

  void selectAllPages() {
    if (_document != null) {
      _selectedPages.addAll(List.generate(totalPages, (i) => i));
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedPages.clear();
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

  /// Быстрый поворот страницы (на 90 градусов по часовой стрелке)
  Future<void> rotatePage(int index) async {
    if (_document == null ||
        index < 0 ||
        index >= _document!.imagePaths.length) {
      return;
    }

    try {
      _setLoading(true);

      Uint8List sourceBytes;
      if (_document!.editedImages.containsKey(index) &&
          _document!.editedImages[index] != null) {
        sourceBytes = _document!.editedImages[index]!;
      } else {
        sourceBytes = await File(_document!.imagePaths[index]).readAsBytes();
      }

      // Выполняем поворот в отдельном изоляте, чтобы не блокировать UI
      final rotatedBytes = await compute(_rotateImageBytes, sourceBytes);

      await _saveEditedImage(_document!.imagePaths[index], index, rotatedBytes);
    } catch (e) {
      debugPrint('Ошибка поворота изображения: $e');
    } finally {
      if (!isDisposed) {
        _setLoading(false);
      }
    }
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

      // Очищаем выделение, так как индексы сместились
      _selectedPages.clear();

      // Корректируем текущий индекс
      if (_currentPageIndex >= _document!.pageCount) {
        _currentPageIndex = _document!.pageCount - 1;
      }

      notifyListeners();
    }
  }

  /// Удалить выбранные страницы
  void deleteSelectedPages() {
    if (_document != null && _selectedPages.isNotEmpty) {
      // Если пытаются удалить все страницы, оставляем хотя бы одну (или удаляем документ целиком?)
      // Для безопасности лучше запретить удаление последней страницы
      if (_selectedPages.length >= _document!.pageCount) {
        return; // Нельзя удалить все страницы
      }

      // Сортируем индексы по убыванию, чтобы удаление не смещало оставшиеся индексы
      final sortedIndices = _selectedPages.toList()
        ..sort((a, b) => b.compareTo(a));
      var tempDoc = _document!;
      for (final index in sortedIndices) {
        tempDoc = tempDoc.removePage(index);
      }
      _document = tempDoc;

      _selectedPages.clear();
      _isSelectionMode = false;

      // Сброс индекса
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

      _selectedPages.clear(); // Сбрасываем выбор при перемещении

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

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}

/// Выполняется в изоляте (должна быть глобальной или статической функцией)
Uint8List _rotateImageBytes(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) return bytes;
  final rotated = img.copyRotate(image, angle: 90);
  return Uint8List.fromList(img.encodeJpg(rotated, quality: 90));
}
