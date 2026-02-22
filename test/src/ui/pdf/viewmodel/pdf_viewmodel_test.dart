import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_scan_test/src/core/models/document_model.dart';
import 'package:pixel_scan_test/src/ui/pdf/viewmodel/pdf_viewmodel.dart';

void main() {
  group('PdfViewModel Multi-select Tests', () {
    late PdfViewModel viewModel;

    setUp(() {
      viewModel = PdfViewModel();
    });

    test('Initial selection mode is false and no pages selected', () {
      expect(viewModel.isSelectionMode, isFalse);
      expect(viewModel.selectedPages.isEmpty, isTrue);
    });

    test(
        'toggleSelectionMode changes mode and clears selection when turning off',
        () {
      viewModel.toggleSelectionMode();
      expect(viewModel.isSelectionMode, isTrue);

      // Add a selection
      viewModel.togglePageSelection(0);
      expect(viewModel.selectedPages.contains(0), isTrue);

      viewModel.toggleSelectionMode();
      expect(viewModel.isSelectionMode, isFalse);
      expect(viewModel.selectedPages.isEmpty, isTrue);
    });

    test('togglePageSelection adds and removes index', () {
      viewModel.toggleSelectionMode(); // enter mode

      viewModel.togglePageSelection(1);
      expect(viewModel.selectedPages.contains(1), isTrue);

      viewModel.togglePageSelection(1);
      expect(viewModel.selectedPages.contains(1), isFalse);
    });

    test('deleteSelectedPages removes selected pages and clears mode', () {
      // Mock document with 4 pages
      final document = DocumentModel(
        id: 'doc1',
        name: 'Test Doc',
        folderId: 'folder1',
        createdAt: DateTime.now(),
        imagePaths: ['page1.jpg', 'page2.jpg', 'page3.jpg', 'page4.jpg'],
      );

      viewModel.loadDocument(document);

      viewModel.toggleSelectionMode();
      viewModel.togglePageSelection(1); // Select 'page2.jpg'
      viewModel.togglePageSelection(3); // Select 'page4.jpg'

      viewModel.deleteSelectedPages();

      expect(viewModel.document!.imagePaths.length, equals(2));
      expect(viewModel.document!.imagePaths.contains('page1.jpg'), isTrue);
      expect(viewModel.document!.imagePaths.contains('page3.jpg'), isTrue);

      expect(viewModel.isSelectionMode, isFalse);
      expect(viewModel.selectedPages.isEmpty, isTrue);
    });

    test('deleteSelectedPages does not delete if all pages are selected', () {
      final document = DocumentModel(
        id: 'doc1',
        name: 'Test Doc',
        folderId: 'folder1',
        createdAt: DateTime.now(),
        imagePaths: ['page1.jpg', 'page2.jpg'],
      );

      viewModel.loadDocument(document);

      viewModel.toggleSelectionMode();
      viewModel.selectAllPages();

      expect(viewModel.selectedPages.length, equals(2));

      viewModel.deleteSelectedPages();

      // Document should still have 2 pages
      expect(viewModel.document!.imagePaths.length, equals(2));
      expect(viewModel.isSelectionMode,
          isTrue); // Should not exit mode if deletion prevented
    });
  });
}
