import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_scan_test/src/core/models/document_model.dart';
import 'package:pixel_scan_test/src/core/models/folder_model.dart';
import 'package:pixel_scan_test/src/core/services/document_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '.';
    });

    SharedPreferences.setMockInitialValues({});
  });

  group('DocumentStorageService', () {
    test('saveFolder and loadAllFolders should work correctly', () async {
      final folder = FolderModel(id: '1', name: 'Work');
      await DocumentStorageService.saveFolder(folder);

      final folders = await DocumentStorageService.loadAllFolders();
      expect(folders.length, 1);
      expect(folders.first.id, '1');
      expect(folders.first.name, 'Work');
    });

    test('deleteFolder should remove folder and update documents', () async {
      // 1. Create a folder
      final folder = FolderModel(id: 'f1', name: 'To Delete');
      await DocumentStorageService.saveFolder(folder);

      final tempDir = Directory.systemTemp.createTempSync();
      final dummyFile = File('${tempDir.path}/dummy.jpg')..createSync();

      // 2. Create documents, one in folder, one outside
      final doc1 = DocumentModel(
          id: 'd1',
          name: 'Doc 1',
          createdAt: DateTime.now(),
          imagePaths: [dummyFile.path],
          folderId: 'f1');
      final doc2 = DocumentModel(
          id: 'd2',
          name: 'Doc 2',
          createdAt: DateTime.now(),
          imagePaths: [dummyFile.path]);
      await DocumentStorageService.saveDocument(doc1);
      await DocumentStorageService.saveDocument(doc2);

      // 3. Delete the folder
      await DocumentStorageService.deleteFolder('f1');

      // 4. Verify folder is deleted
      final folders = await DocumentStorageService.loadAllFolders();
      expect(folders.isEmpty, true);

      // 5. Verify document's folderId is nullified
      final docs = await DocumentStorageService.loadAllDocuments();
      expect(docs.length, 2);
      final updatedDoc1 = docs.firstWhere((d) => d.id == 'd1');
      expect(updatedDoc1.folderId, null);
    });
  });
}
