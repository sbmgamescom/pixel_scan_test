import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/config/images.dart';
import '../../../core/models/document_model.dart';
import '../../../core/router/app_navigator.dart';
import '../../../core/services/subscription_service.dart';
import '../../paywall/paywall_screen.dart';
import '../../pdf/widgets/pdf_screen.dart';
import '../view_model/home_viewmodel.dart';

class MainScreen extends StatefulWidget {
  final SubscriptionService subscriptionService;
  final AppNavigator appNavigator;

  const MainScreen({
    super.key,
    required this.subscriptionService,
    required this.appNavigator,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _scanDocument() async {
    final document = await _viewModel.scanNewDocument();
    if (document != null && mounted) {
      // Открываем экран редактирования PDF
      _openDocument(document);
    }
  }

  Future<void> _importPdf() async {
    final document = await _viewModel.importPdfFromDevice();
    if (document != null && mounted) {
      _openDocument(document);
    }
  }

  Future<void> _importImages() async {
    final document = await _viewModel.importImagesFromDevice();
    if (document != null && mounted) {
      _openDocument(document);
    }
  }

  void _showImportOptions() {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: const Text('Добавить документ'),
        description: const Text('Выберите способ добавления документа'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.camera, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _scanDocument();
                },
                child: const Text('Сканировать камерой'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.fileText, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _importPdf();
                },
                child: const Text('Импорт PDF'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.image, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _importImages();
                },
                child: const Text('Импорт изображений'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDocument(DocumentModel document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfScreen(
          subscriptionService: widget.subscriptionService,
          document: document,
          onDocumentUpdated: (updatedDoc) {
            _viewModel.updateDocument(updatedDoc);
          },
        ),
      ),
    ).then((_) {
      // Обновляем список при возврате
      _viewModel.loadDocuments();
    });
  }

  void _showDocumentOptions(DocumentModel document) {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: Text(document.name),
        description:
            Text('${document.pageCount} страниц • ${document.formattedDate}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.externalLink, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _openDocument(document);
                },
                child: const Text('Открыть'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.pencil, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showRenameDialog(document);
                },
                child: const Text('Переименовать'),
              ),
              const SizedBox(height: 12),
              ShadButton.destructive(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.trash2, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(document);
                },
                child: const Text('Удалить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(DocumentModel document) {
    final controller = TextEditingController(text: document.name);

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Переименовать документ'),
        description: const Text('Введите новое название документа'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _viewModel.renameDocument(document.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ShadInput(
            controller: controller,
            placeholder: const Text('Название документа'),
            autofocus: true,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(DocumentModel document) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Удалить документ?'),
        description: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Вы уверены, что хотите удалить "${document.name}"?\nЭто действие нельзя отменить.',
          ),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton.destructive(
            onPressed: () {
              _viewModel.deleteDocument(document.id);
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Image.asset(AppImages.logoSmall),
                      ),
                      // Кнопка Premium (если не подписчик)
                      if (!widget.subscriptionService.isPremiumUser)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaywallScreen(
                                  source: 'home',
                                  subscriptionService:
                                      widget.subscriptionService,
                                ),
                              ),
                            );
                          },
                          child: ShadBadge(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.sparkles,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                const Text('Premium'),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  // Контент - список документов или пустое состояние
                  Expanded(
                    child: _viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _viewModel.hasDocuments
                            ? _buildDocumentsList()
                            : _buildEmptyState(),
                  ),
                ],
              ),
            ),

            // Кнопка сканирования
            Positioned(
              bottom: 10,
              right: 64,
              left: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 68,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14343434),
                          offset: Offset(0, 0),
                          blurRadius: 24,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(88),
                    ),
                  ),
                  GestureDetector(
                    onTap: (_viewModel.isScanning || _viewModel.isImporting)
                        ? null
                        : _showImportOptions,
                    child: (_viewModel.isScanning || _viewModel.isImporting)
                        ? const SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 100,
                            child: Image.asset(AppImages.buttonScanner),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ShadCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 180,
                    child: Image.asset(AppImages.documents),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'No documents found',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the button below to scan\nor convert to PDF',
                  style: ShadTheme.of(context).textTheme.muted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Мои документы',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_viewModel.documents.length} документов',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: _viewModel.documents.length,
            itemBuilder: (context, index) {
              final document = _viewModel.documents[index];
              return _DocumentCard(
                document: document,
                onTap: () => _openDocument(document),
                onLongPress: () => _showDocumentOptions(document),
                onMoreTap: () => _showDocumentOptions(document),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMoreTap;

  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.onLongPress,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: theme.radius,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Превью первой страницы
                Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: document.imagePaths.isNotEmpty
                      ? Image.file(
                          File(document.imagePaths.first),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            LucideIcons.fileText,
                            size: 30,
                            color: theme.colorScheme.muted,
                          ),
                        )
                      : Icon(
                          LucideIcons.fileText,
                          size: 30,
                          color: theme.colorScheme.muted,
                        ),
                ),
                const SizedBox(width: 12),

                // Информация о документе
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
                        style: theme.textTheme.p.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${document.pageCount} страниц • ${document.formattedDate}',
                        style: theme.textTheme.muted,
                      ),
                    ],
                  ),
                ),

                // Кнопка опций
                ShadIconButton.ghost(
                  icon: const Icon(LucideIcons.ellipsisVertical, size: 20),
                  onPressed: onMoreTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
