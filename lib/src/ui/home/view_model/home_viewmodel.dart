import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

import '../../../core/models/document_model.dart';
import '../../../core/repositories/document_scan_repository.dart';
import '../../../core/services/document_storage_service.dart';
import '../../../core/services/pdf_import_service.dart';

class HomeViewModel extends ChangeNotifier {
  final DocumentScanRepository _repository = DocumentScanRepository();

  List<DocumentModel> _documents = [];
  bool _isLoading = false;
  bool _isScanning = false;
  bool _isImporting = false;
  String? _errorMessage;

  List<DocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  bool get isScanning => _isScanning;
  bool get isImporting => _isImporting;
  bool get hasDocuments => _documents.isNotEmpty;
  String? get errorMessage => _errorMessage;

  HomeViewModel() {
    loadDocuments();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setScanning(bool scanning) {
    _isScanning = scanning;
    notifyListeners();
  }

  void _setImporting(bool importing) {
    _isImporting = importing;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Загрузить все сохранённые документы
  Future<void> loadDocuments() async {
    try {
      _setLoading(true);
      _documents = await DocumentStorageService.loadAllDocuments();
      dev.log('Загружено документов: ${_documents.length}');
    } catch (e) {
      dev.log('Ошибка загрузки документов: $e');
      _setError('Ошибка загрузки документов');
    } finally {
      _setLoading(false);
    }
  }

  /// Сканировать новый документ
  Future<DocumentModel?> scanNewDocument() async {
    try {
      _setScanning(true);
      _setError(null);

      final imagePaths = await _repository.scanDocuments();

      if (imagePaths != null && imagePaths.isNotEmpty) {
        final document = DocumentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Документ ${_documents.length + 1}',
          imagePaths: imagePaths,
        );

        // Сохраняем документ
        await DocumentStorageService.saveDocument(document);

        // Перезагружаем список
        await loadDocuments();

        return document;
      }

      return null;
    } catch (e) {
      dev.log('Ошибка сканирования: $e');
      _setError('Ошибка сканирования: $e');
      return null;
    } finally {
      _setScanning(false);
    }
  }

  /// Удалить документ
  Future<void> deleteDocument(String documentId) async {
    try {
      await DocumentStorageService.deleteDocument(documentId);
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка удаления документа: $e');
      _setError('Ошибка удаления документа');
    }
  }

  /// Переименовать документ
  Future<void> renameDocument(String documentId, String newName) async {
    try {
      await DocumentStorageService.renameDocument(documentId, newName);
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка переименования: $e');
      _setError('Ошибка переименования');
    }
  }

  /// Обновить документ после изменений
  Future<void> updateDocument(DocumentModel document) async {
    try {
      await DocumentStorageService.updateDocument(document);
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка обновления документа: $e');
      _setError('Ошибка обновления документа');
    }
  }

  /// Импортировать PDF с устройства
  Future<DocumentModel?> importPdfFromDevice() async {
    try {
      _setImporting(true);
      _setError(null);

      final document = await PdfImportService.importPdfFromDevice();

      if (document != null) {
        // Сохраняем документ
        await DocumentStorageService.saveDocument(document);
        // Перезагружаем список
        await loadDocuments();
        return document;
      }

      return null;
    } catch (e) {
      dev.log('Ошибка импорта PDF: $e');
      _setError('Ошибка импорта PDF: $e');
      return null;
    } finally {
      _setImporting(false);
    }
  }

  /// Импортировать изображения с устройства
  Future<DocumentModel?> importImagesFromDevice() async {
    try {
      _setImporting(true);
      _setError(null);

      final document = await PdfImportService.importImagesFromDevice();

      if (document != null) {
        await DocumentStorageService.saveDocument(document);
        await loadDocuments();
        return document;
      }

      return null;
    } catch (e) {
      dev.log('Ошибка импорта изображений: $e');
      _setError('Ошибка импорта изображений: $e');
      return null;
    } finally {
      _setImporting(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}
