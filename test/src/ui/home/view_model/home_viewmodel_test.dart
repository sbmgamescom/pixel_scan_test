import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_scan_test/src/core/models/document_model.dart';
import 'package:pixel_scan_test/src/core/services/document_storage_service.dart';
import 'package:pixel_scan_test/src/ui/home/view_model/home_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late HomeViewModel viewModel;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '.';
    });

    SharedPreferences.setMockInitialValues({});
    viewModel = HomeViewModel();
    // Wait for async init in constructor if any
    await Future.delayed(Duration.zero);
  });

  tearDown(() async {
    final docs = await DocumentStorageService.loadAllDocuments();
    for (var doc in docs) {
      await DocumentStorageService.deleteDocument(doc.id);
    }
    final folders = await DocumentStorageService.loadAllFolders();
    for (var folder in folders) {
      await DocumentStorageService.deleteFolder(folder.id);
    }
  });

  group('HomeViewModel - Logic Tests', () {
    test('Initial state should be empty', () {
      expect(viewModel.documents.isEmpty, true);
      expect(viewModel.folders.isEmpty, true);
      expect(viewModel.selectedFolderId, null);
      expect(viewModel.isSelectionMode, false);
      expect(viewModel.selectedDocumentIds.isEmpty, true);
    });

    test('createFolder adds a folder', () async {
      await viewModel.createFolder('New Folder');
      expect(viewModel.folders.length, 1);
      expect(viewModel.folders.first.name, 'New Folder');
    });

    test('multi-select logic works properly', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final dummyFile = File('${tempDir.path}/dummy.jpg')..createSync();

      // Create some docs
      final doc1 = DocumentModel(
          id: '1',
          name: 'd1',
          createdAt: DateTime.now(),
          imagePaths: [dummyFile.path]);
      final doc2 = DocumentModel(
          id: '2',
          name: 'd2',
          createdAt: DateTime.now(),
          imagePaths: [dummyFile.path]);
      await DocumentStorageService.saveDocument(doc1);
      await DocumentStorageService.saveDocument(doc2);

      await viewModel.loadDocuments();
      expect(viewModel.documents.length, 2);

      viewModel.toggleSelectionMode();
      expect(viewModel.isSelectionMode, true);

      viewModel.toggleDocumentSelection('1');
      expect(viewModel.isDocumentSelected('1'), true);
      expect(viewModel.selectedDocumentIds.length, 1);

      viewModel.selectAll();
      expect(viewModel.selectedDocumentIds.length, 2);

      await viewModel.deleteSelectedDocuments();
      expect(viewModel.documents.isEmpty, true);
      expect(viewModel.isSelectionMode, false);
    });
  });
}
