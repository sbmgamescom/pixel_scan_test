import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/document_model.dart';
import '../models/folder_model.dart';

class DocumentStorageService {
  static const String _documentsKey = 'saved_documents';
  static const String _foldersKey = 'saved_folders';

  /// Получить директорию для хранения изображений документов
  static Future<Directory> _getDocumentsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final docsDir = Directory('${appDir.path}/scanned_documents');
    if (!await docsDir.exists()) {
      await docsDir.create(recursive: true);
    }
    return docsDir;
  }

  /// Сохранить документ
  static Future<DocumentModel> saveDocument(DocumentModel document) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docsDir = await _getDocumentsDirectory();

      // Создаём папку для документа
      final docDir = Directory('${docsDir.path}/${document.id}');
      if (!await docDir.exists()) {
        await docDir.create(recursive: true);
      }

      // Копируем изображения в постоянное хранилище
      final List<String> savedImagePaths = [];
      dev.log(
          'Сохранение документа ${document.id}: ${document.imagePaths.length} изображений');
      for (int i = 0; i < document.imagePaths.length; i++) {
        final originalPath = document.imagePaths[i];
        final originalFile = File(originalPath);

        final exists = await originalFile.exists();
        dev.log('Изображение $i: $originalPath, существует: $exists');
        if (exists) {
          final newPath = '${docDir.path}/page_$i.jpg';

          // Проверяем, не пытаемся ли мы скопировать файл сам в себя
          if (originalPath != newPath) {
            await originalFile.copy(newPath);
            dev.log('Скопировано в: $newPath');
          } else {
            dev.log('Файл уже находится в нужном месте: $newPath');
          }

          savedImagePaths.add(newPath);

          // Сохраняем отредактированные изображения
          final editedBytes = document.editedImages[i];
          if (editedBytes != null) {
            final editedPath = '${docDir.path}/page_${i}_edited.jpg';
            await File(editedPath).writeAsBytes(editedBytes);
          }
        } else {
          savedImagePaths.add(originalPath);
        }
      }

      // Создаём обновлённую модель с новыми путями
      final savedDocument = document.copyWith(imagePaths: savedImagePaths);

      // Загружаем существующие документы
      final documents = await loadAllDocuments();

      // Обновляем или добавляем документ
      final existingIndex = documents.indexWhere((d) => d.id == document.id);
      if (existingIndex != -1) {
        documents[existingIndex] = savedDocument;
      } else {
        documents.add(savedDocument);
      }

      // Сохраняем список документов в SharedPreferences
      final documentsJson = documents.map((d) => d.toJson()).toList();
      await prefs.setString(_documentsKey, jsonEncode(documentsJson));

      dev.log('Документ сохранён: ${document.id}');
      return savedDocument;
    } catch (e) {
      dev.log('Ошибка сохранения документа: $e');
      rethrow;
    }
  }

  /// Загрузить все документы
  static Future<List<DocumentModel>> loadAllDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_documentsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> documentsJson = jsonDecode(jsonString);
      final documents = documentsJson
          .map((json) => DocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Фильтруем документы, у которых ещё существуют файлы
      final validDocuments = <DocumentModel>[];
      for (final doc in documents) {
        if (doc.imagePaths.isNotEmpty) {
          final firstImageExists = await File(doc.imagePaths.first).exists();
          if (firstImageExists) {
            validDocuments.add(doc);
          }
        }
      }

      // Сортируем по дате создания (новые первые)
      validDocuments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return validDocuments;
    } catch (e) {
      dev.log('Ошибка загрузки документов: $e');
      return [];
    }
  }

  /// Загрузить один документ по ID
  static Future<DocumentModel?> loadDocument(String documentId) async {
    final documents = await loadAllDocuments();
    try {
      return documents.firstWhere((d) => d.id == documentId);
    } catch (e) {
      return null;
    }
  }

  /// Удалить документ
  static Future<void> deleteDocument(String documentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docsDir = await _getDocumentsDirectory();

      // Удаляем папку с файлами документа
      final docDir = Directory('${docsDir.path}/$documentId');
      if (await docDir.exists()) {
        await docDir.delete(recursive: true);
      }

      // Удаляем из списка
      final documents = await loadAllDocuments();
      documents.removeWhere((d) => d.id == documentId);

      final documentsJson = documents.map((d) => d.toJson()).toList();
      await prefs.setString(_documentsKey, jsonEncode(documentsJson));

      dev.log('Документ удалён: $documentId');
    } catch (e) {
      dev.log('Ошибка удаления документа: $e');
      rethrow;
    }
  }

  /// Переименовать документ
  static Future<void> renameDocument(String documentId, String newName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documents = await loadAllDocuments();

      final index = documents.indexWhere((d) => d.id == documentId);
      if (index != -1) {
        documents[index] = documents[index].copyWith(name: newName);

        final documentsJson = documents.map((d) => d.toJson()).toList();
        await prefs.setString(_documentsKey, jsonEncode(documentsJson));

        dev.log('Документ переименован: $newName');
      }
    } catch (e) {
      dev.log('Ошибка переименования документа: $e');
      rethrow;
    }
  }

  /// Обновить документ (после редактирования страниц)
  static Future<DocumentModel> updateDocument(DocumentModel document) async {
    return await saveDocument(document);
  }

  /// Получить путь к PDF файлу документа (если существует)
  static Future<String?> getPdfPath(String documentId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${appDir.path}/pdfs');

    if (await pdfDir.exists()) {
      final files = await pdfDir.list().toList();
      for (final file in files) {
        if (file.path.contains(documentId) && file.path.endsWith('.pdf')) {
          return file.path;
        }
      }
    }
    return null;
  }

  // --- УПРАВЛЕНИЕ ПАПКАМИ ---

  /// Сохранить (или обновить) папку
  static Future<FolderModel> saveFolder(FolderModel folder) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final folders = await loadAllFolders();

      final existingIndex = folders.indexWhere((f) => f.id == folder.id);
      if (existingIndex != -1) {
        folders[existingIndex] = folder;
      } else {
        folders.add(folder);
      }

      final foldersJson = folders.map((f) => f.toJson()).toList();
      await prefs.setString(_foldersKey, jsonEncode(foldersJson));

      return folder;
    } catch (e) {
      dev.log('Ошибка сохранения папки: $e');
      rethrow;
    }
  }

  /// Загрузить все папки
  static Future<List<FolderModel>> loadAllFolders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_foldersKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> foldersJson = jsonDecode(jsonString);
      final folders = foldersJson
          .map((json) => FolderModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Сортируем (например, по алфавиту)
      folders
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return folders;
    } catch (e) {
      dev.log('Ошибка загрузки папок: $e');
      return [];
    }
  }

  /// Удалить папку (документы из неё перемещаются в корень, то есть folderId = null)
  static Future<void> deleteFolder(String folderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Удаляем саму папку
      final folders = await loadAllFolders();
      folders.removeWhere((f) => f.id == folderId);
      final foldersJson = folders.map((f) => f.toJson()).toList();
      await prefs.setString(_foldersKey, jsonEncode(foldersJson));

      // Отвязываем документы от этой папки
      final documents = await loadAllDocuments();
      bool hasChanges = false;
      for (int i = 0; i < documents.length; i++) {
        if (documents[i].folderId == folderId) {
          documents[i] = documents[i].copyWith(clearFolderId: true);
          hasChanges = true;
        }
      }

      if (hasChanges) {
        final docsJson = documents.map((d) => d.toJson()).toList();
        await prefs.setString(_documentsKey, jsonEncode(docsJson));
      }

      dev.log('Папка удалена: $folderId');
    } catch (e) {
      dev.log('Ошибка удаления папки: $e');
      rethrow;
    }
  }
}
