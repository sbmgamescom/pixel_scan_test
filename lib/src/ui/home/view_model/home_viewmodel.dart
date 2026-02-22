import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/document_model.dart';
import '../../../core/models/folder_model.dart';
import '../../../core/models/sort_mode.dart';
import '../../../core/models/view_mode.dart';
import '../../../core/repositories/document_scan_repository.dart';
import '../../../core/services/document_storage_service.dart';
import '../../../core/services/pdf_import_service.dart';

class HomeViewModel extends ChangeNotifier {
  final DocumentScanRepository _repository = DocumentScanRepository();

  List<DocumentModel> _documents = [];
  List<FolderModel> _folders = [];
  bool _isLoading = false;
  bool _isScanning = false;
  bool _isImporting = false;
  String? _errorMessage;
  String _searchQuery = '';
  DocumentSortMode _sortMode = DocumentSortMode.dateNewest;
  DocumentViewMode _viewMode = DocumentViewMode.list;
  String? _selectedFolderId;

  bool _isSelectionMode = false;
  final Set<String> _selectedDocumentIds = {};

  List<DocumentModel> get documents => _documents;
  List<FolderModel> get folders => _folders;
  bool get isLoading => _isLoading;
  bool get isScanning => _isScanning;
  bool get isImporting => _isImporting;
  bool get hasDocuments => _documents.isNotEmpty;
  String? get errorMessage => _errorMessage;
  DocumentSortMode get sortMode => _sortMode;
  DocumentViewMode get viewMode => _viewMode;
  String? get selectedFolderId => _selectedFolderId;

  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedDocumentIds => _selectedDocumentIds;
  bool isDocumentSelected(String id) => _selectedDocumentIds.contains(id);

  List<DocumentModel> get filteredDocuments {
    List<DocumentModel> result = _documents;

    // Filter by Folder
    if (_selectedFolderId != null) {
      result =
          result.where((doc) => doc.folderId == _selectedFolderId).toList();
    } else {
      // Исключаем документы, лежащие в папках (если мы на главном экране "Все документы")
      // ИЛИ показываем все? Обычно если выбрана "Все документы", показываются все.
      // Давайте показывать те, что без папки или с любой папкой. По умолчанию - все.
      // Если хотим показывать только "Вне папок", то нужно проверять folderId == null.
      // Оставим показ всех документов, если папка не выбрана.
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result.where((doc) {
        return doc.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    } else {
      result = List.from(result); // Create a copy to sort safely
    }

    // Sort
    result.sort((a, b) {
      switch (_sortMode) {
        case DocumentSortMode.dateNewest:
          return b.createdAt.compareTo(a.createdAt);
        case DocumentSortMode.dateOldest:
          return a.createdAt.compareTo(b.createdAt);
        case DocumentSortMode.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case DocumentSortMode.nameDesc:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      }
    });

    return result;
  }

  HomeViewModel() {
    _initSettings();
    loadDocuments();
  }

  Future<void> _initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final sortModeIndex = prefs.getInt('document_sort_mode') ?? 0;
    if (sortModeIndex >= 0 && sortModeIndex < DocumentSortMode.values.length) {
      _sortMode = DocumentSortMode.values[sortModeIndex];
    }
    final viewModeIndex = prefs.getInt('document_view_mode') ?? 0;
    if (viewModeIndex >= 0 && viewModeIndex < DocumentViewMode.values.length) {
      _viewMode = DocumentViewMode.values[viewModeIndex];
    }
    notifyListeners();
  }

  Future<void> setSortMode(DocumentSortMode mode) async {
    if (_sortMode != mode) {
      _sortMode = mode;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('document_sort_mode', mode.index);
    }
  }

  Future<void> setViewMode(DocumentViewMode mode) async {
    if (_viewMode != mode) {
      _viewMode = mode;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('document_view_mode', mode.index);
    }
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Загрузить все сохранённые документы
  Future<void> loadDocuments() async {
    try {
      _setLoading(true);
      _documents = await DocumentStorageService.loadAllDocuments();
      _folders = await DocumentStorageService.loadAllFolders();
      dev.log(
          'Загружено документов: ${_documents.length}, папок: ${_folders.length}');
    } catch (e) {
      dev.log('Ошибка загрузки документов: $e');
      _setError('Ошибка загрузки документов');
    } finally {
      _setLoading(false);
    }
  }

  void selectFolder(String? folderId) {
    _selectedFolderId = folderId;
    notifyListeners();
  }

  Future<void> createFolder(String name) async {
    try {
      final folder = FolderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
      );
      await DocumentStorageService.saveFolder(folder);
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка создания папки: $e');
      _setError('Ошибка создания папки');
    }
  }

  Future<void> deleteFolder(String folderId) async {
    try {
      await DocumentStorageService.deleteFolder(folderId);
      if (_selectedFolderId == folderId) {
        _selectedFolderId = null;
      }
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка удаления папки: $e');
      _setError('Ошибка удаления папки');
    }
  }

  Future<void> moveToFolder(String documentId, String? folderId) async {
    try {
      final idx = _documents.indexWhere((d) => d.id == documentId);
      if (idx != -1) {
        DocumentModel doc = _documents[idx];
        doc = doc.copyWith(
          folderId: folderId,
          clearFolderId: folderId == null,
        );
        await DocumentStorageService.saveDocument(doc);
        await loadDocuments();
      }
    } catch (e) {
      dev.log('Ошибка перемещения документа: $e');
      _setError('Ошибка перемещения документа');
    }
  }

  // --- MULTI-SELECT LOGIC ---

  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedDocumentIds.clear();
    }
    notifyListeners();
  }

  void toggleDocumentSelection(String documentId) {
    if (_selectedDocumentIds.contains(documentId)) {
      _selectedDocumentIds.remove(documentId);
    } else {
      _selectedDocumentIds.add(documentId);
    }
    notifyListeners();
  }

  void selectAll() {
    final docs = filteredDocuments;
    if (_selectedDocumentIds.length == docs.length) {
      _selectedDocumentIds.clear();
    } else {
      _selectedDocumentIds.addAll(docs.map((d) => d.id));
    }
    notifyListeners();
  }

  Future<void> deleteSelectedDocuments() async {
    try {
      _setLoading(true);
      for (final id in _selectedDocumentIds) {
        await DocumentStorageService.deleteDocument(id);
      }
      _selectedDocumentIds.clear();
      _isSelectionMode = false;
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка удаления выбранных: $e');
      _setError('Ошибка удаления выбранных документов');
      _setLoading(false);
    }
  }

  Future<void> moveSelectedToFolder(String? folderId) async {
    try {
      _setLoading(true);
      for (final id in _selectedDocumentIds) {
        final idx = _documents.indexWhere((d) => d.id == id);
        if (idx != -1) {
          DocumentModel doc = _documents[idx];
          doc = doc.copyWith(
            folderId: folderId,
            clearFolderId: folderId == null,
          );
          await DocumentStorageService.saveDocument(doc);
        }
      }
      _selectedDocumentIds.clear();
      _isSelectionMode = false;
      await loadDocuments();
    } catch (e) {
      dev.log('Ошибка перемещения выбранных: $e');
      _setError('Ошибка перемещения выбранных документов');
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
          folderId: _selectedFolderId,
        );

        // Сохраняем документ
        final savedDocument =
            await DocumentStorageService.saveDocument(document);

        // Перезагружаем список
        await loadDocuments();

        return savedDocument;
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
        final savedDocument =
            await DocumentStorageService.saveDocument(document);
        // Перезагружаем список
        await loadDocuments();
        return savedDocument;
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
        final savedDocument =
            await DocumentStorageService.saveDocument(document);
        await loadDocuments();
        return savedDocument;
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
