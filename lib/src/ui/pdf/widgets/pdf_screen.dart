import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  List<String> scannedImages = [];

  Future<void> _editImage(String imagePath, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.file(
          File(imagePath),
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (bytes) async {
              // Сохраняем отредактированное изображение
              final file = File(imagePath);
              await file.writeAsBytes(bytes);

              // Обновляем UI после сохранения
              setState(() {
                // Это заставит виджет Image.file перезагрузить изображение
              });

              // Возвращаемся назад
              Navigator.pop(context, true);
            },
            onCloseEditor: () {
              // Просто закрываем редактор без сохранения
              Navigator.pop(context, false);
            },
          ),
        ),
      ),
    );

    // Если результат редактирования успешный, обновляем UI (может быть избыточным, если setState выше уже сработал)
    if (result == true) {
      setState(() {
        // Обновляем UI для отображения изменений
      });
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
            onPressed: () async {
              try {
                final imagesPath = await CunningDocumentScanner.getPictures();
                if (imagesPath != null && imagesPath.isNotEmpty) {
                  setState(() {
                    scannedImages = imagesPath;
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка сканирования: $e')),
                );
              }
            },
            child: Text("Сканировать документ"),
          ),
          SizedBox(height: 16),
          Expanded(
            child: scannedImages.isEmpty
                ? Center(
                    child: Text(
                      'Нет отсканированных изображений',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: scannedImages.length,
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
                                  ElevatedButton(
                                    onPressed: () =>
                                        _editImage(scannedImages[index], index),
                                    child: Text('Edit'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 300,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              child: Image.file(
                                File(scannedImages[index]),
                                fit: BoxFit.contain,
                              ),
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
