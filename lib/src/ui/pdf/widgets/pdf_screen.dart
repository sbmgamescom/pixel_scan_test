import 'package:flutter/material.dart';

import '../viewmodel/pdf_viewmodel.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late final PdfViewModel _viewModel;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _viewModel = PdfViewModel();
    _pageController = PageController();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  Future<void> _scanDocument() async {
    try {
      await _viewModel.scanDocument();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сканирования: $e')),
        );
      }
    }
  }

  Future<void> _addPages() async {
    try {
      await _viewModel.addPages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка добавления страниц: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_viewModel.hasImages
            ? 'Document 1 (${_viewModel.currentPageIndex + 1}/${_viewModel.totalPages})'
            : 'Document 1'),
        actions: [
          if (_viewModel.hasImages) ...[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _viewModel.isLoading ? null : _addPages,
              tooltip: 'Добавить страницы',
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _viewModel.editImage(
                context,
                _viewModel.scannedImages[_viewModel.currentPageIndex],
                _viewModel.currentPageIndex,
              ),
              tooltip: 'Редактировать страницу',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Кнопки сканирования и добавления
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading ? null : _scanDocument,
                    child: _viewModel.isLoading
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text("Сканирование..."),
                            ],
                          )
                        : Text(_viewModel.hasImages
                            ? "Пересканировать"
                            : "Сканировать документ"),
                  ),
                ),
                if (_viewModel.hasImages) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _viewModel.isLoading ? null : _addPages,
                      icon: const Icon(Icons.add),
                      label: const Text("Добавить страницы"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Основная область просмотра
          Expanded(
            flex: 3,
            child: !_viewModel.hasImages
                ? const Center(
                    child: Text(
                      'Нет отсканированных изображений',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: _viewModel.scannedImages.length,
                    onPageChanged: (index) {
                      _viewModel.setCurrentPage(index);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              _viewModel.buildImageWidget(index),
                              if (_viewModel.isImageEdited(index))
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Нижний список страниц
          if (_viewModel.hasImages) ...[
            const Divider(),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _viewModel.scannedImages.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _viewModel.currentPageIndex;
                  return GestureDetector(
                    onTap: () {
                      _viewModel.setCurrentPage(index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 100,
                              child: _viewModel.buildImageWidget(index),
                            ),
                            // Номер страницы
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // Индикатор редактирования
                            if (_viewModel.isImageEdited(index))
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
