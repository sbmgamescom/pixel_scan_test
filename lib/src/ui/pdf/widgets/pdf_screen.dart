import 'package:flutter/material.dart';

import '../viewmodel/pdf_viewmodel.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late final PdfViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PdfViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Document 1'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _viewModel.isLoading ? null : _scanDocument,
            child: _viewModel.isLoading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text("Сканирование..."),
                    ],
                  )
                : Text("Сканировать документ"),
          ),
          SizedBox(height: 16),
          Expanded(
            child: !_viewModel.hasImages
                ? Center(
                    child: Text(
                      'Нет отсканированных изображений',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _viewModel.scannedImages.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Страница ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (_viewModel.isImageEdited(index))
                                        Icon(Icons.edit,
                                            color: Colors.green, size: 20),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _viewModel.editImage(
                                            context,
                                            _viewModel.scannedImages[index],
                                            index),
                                        child: Text('Edit'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 300,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              child: _viewModel.buildImageWidget(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
