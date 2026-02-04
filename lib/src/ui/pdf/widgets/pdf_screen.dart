import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/models/document_model.dart';
import '../../../core/services/document_storage_service.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/services/subscription_service.dart';
import '../../paywall/paywall_screen.dart';
import '../viewmodel/pdf_viewmodel.dart';

class PdfScreen extends StatefulWidget {
  final SubscriptionService subscriptionService;
  final DocumentModel? document;
  final Function(DocumentModel)? onDocumentUpdated;

  const PdfScreen({
    super.key,
    required this.subscriptionService,
    this.document,
    this.onDocumentUpdated,
  });

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late final PdfViewModel _viewModel;
  late final PageController _pageController;
  bool _isExporting = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _viewModel = PdfViewModel();
    _pageController = PageController();
    _viewModel.addListener(_onViewModelChanged);

    // Если передан документ, загружаем его
    if (widget.document != null) {
      _viewModel.loadDocument(widget.document!);
    }
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

    // Уведомляем родительский экран об изменениях
    if (widget.onDocumentUpdated != null && _viewModel.document != null) {
      widget.onDocumentUpdated!(_viewModel.document!);
    }
  }

  Future<void> _scanDocument() async {
    try {
      await _viewModel.scanDocument();
      await _saveDocument();
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка сканирования'),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  Future<void> _addPages() async {
    try {
      await _viewModel.addPages();
      await _saveDocument();
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка добавления страниц'),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  Future<void> _saveDocument() async {
    if (_viewModel.document != null) {
      try {
        final savedDocument =
            await DocumentStorageService.saveDocument(_viewModel.document!);
        // Обновляем документ в viewModel с новыми путями к файлам
        _viewModel.loadDocument(savedDocument);
      } catch (e) {
        if (mounted) {
          ShadToaster.of(context).show(
            ShadToast.destructive(
              title: const Text('Ошибка сохранения'),
              description: Text('$e'),
            ),
          );
        }
      }
    }
  }

  void _importPhotosFromDevice() async {
    try {
      await _viewModel.importImagesFromDevice();
      await _saveDocument();

      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('✅ Фото добавлены'),
            description: Text(
                'Добавлено ${_viewModel.document?.imagePaths.length ?? 0} фотографий'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка импорта фото'),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  void _importPdfPages() async {
    try {
      await _viewModel.importPdfPages();
      await _saveDocument();

      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('✅ PDF импортирован'),
            description: Text(
                'Добавлено ${_viewModel.document?.imagePaths.length ?? 0} страниц'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка импорта PDF'),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  Future<void> _exportPdf() async {
    if (_viewModel.document == null) return;

    setState(() => _isExporting = true);

    try {
      final pdfPath = await PdfExportService.generatePdf(_viewModel.document!);
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('PDF сохранён'),
            description: Text(pdfPath.split('/').last),
            action: ShadButton.outline(
              child: const Text('Поделиться'),
              onPressed: () {
                ShadToaster.of(context).hide();
                _shareDocument();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка экспорта'),
            description: Text('$e'),
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void _printDocument() {
    if (_viewModel.document == null) return;

    if (widget.subscriptionService.isPremiumUser) {
      _doPrint();
    } else {
      _showPaywallForFeature('print');
    }
  }

  Future<void> _doPrint() async {
    try {
      await PdfExportService.printDocument(_viewModel.document!);
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка печати'),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  void _shareDocument() {
    if (_viewModel.document == null) return;

    if (widget.subscriptionService.isPremiumUser) {
      _doShare();
    } else {
      _showPaywallForFeature('share');
    }
  }

  Future<void> _doShare() async {
    setState(() => _isSharing = true);

    try {
      await ShareService.sharePdf(_viewModel.document!);
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка шаринга'),
            description: Text('$e'),
          ),
        );
      }
    } finally {
      setState(() => _isSharing = false);
    }
  }

  void _showPaywallForFeature(String feature) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaywallScreen(
          source: feature,
          subscriptionService: widget.subscriptionService,
        ),
      ),
    );
  }

  void _showRenameDialog() {
    if (_viewModel.document == null) return;

    final controller = TextEditingController(text: _viewModel.document!.name);

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
                _viewModel.renameDocument(controller.text);
                _saveDocument();
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

  void _deletePage(int index) {
    if (_viewModel.totalPages <= 1) {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Нельзя удалить последнюю страницу'),
        ),
      );
      return;
    }

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Удалить страницу?'),
        description: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Вы уверены, что хотите удалить страницу ${index + 1}?'),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton.destructive(
            onPressed: () {
              _viewModel.removePage(index);
              _saveDocument();
              Navigator.pop(context);

              // Переключаемся на предыдущую страницу, если удалили текущую
              if (_viewModel.currentPageIndex >= _viewModel.totalPages) {
                _viewModel.setCurrentPage(_viewModel.totalPages - 1);
                _pageController.jumpToPage(_viewModel.currentPageIndex);
              }
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showPageManagement() {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _PageManagementSheet(
        viewModel: _viewModel,
        onReorder: (oldIndex, newIndex) {
          _viewModel.movePage(oldIndex, newIndex);
          _saveDocument();
        },
        onDelete: _deletePage,
        onPageTap: (index) {
          Navigator.pop(context);
          _viewModel.setCurrentPage(index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  void _showMoreOptions() {
    final theme = ShadTheme.of(context);
    final isPremium = widget.subscriptionService.isPremiumUser;

    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: const Text('Опции документа'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.image, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _importPhotosFromDevice();
                },
                child: const Text('Добавить фото'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.file, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _importPdfPages();
                },
                child: const Text('Импортировать PDF'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.fileText, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _exportPdf();
                },
                child: const Text('Экспорт в PDF'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.printer,
                      size: 20,
                      color: isPremium ? null : theme.colorScheme.muted),
                ),
                trailing: isPremium
                    ? null
                    : const Icon(LucideIcons.sparkles,
                        size: 16, color: Colors.amber),
                onPressed: () {
                  Navigator.pop(context);
                  _printDocument();
                },
                child: Text('Печать',
                    style: isPremium
                        ? null
                        : TextStyle(color: theme.colorScheme.muted)),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.share2,
                      size: 20,
                      color: isPremium ? null : theme.colorScheme.muted),
                ),
                trailing: isPremium
                    ? null
                    : const Icon(LucideIcons.sparkles,
                        size: 16, color: Colors.amber),
                onPressed: () {
                  Navigator.pop(context);
                  _shareDocument();
                },
                child: Text('Поделиться',
                    style: isPremium
                        ? null
                        : TextStyle(color: theme.colorScheme.muted)),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.pencil, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showRenameDialog();
                },
                child: const Text('Переименовать'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.layoutGrid, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showPageManagement();
                },
                child: const Text('Управление страницами'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        leading: ShadIconButton.ghost(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: _showRenameDialog,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _viewModel.hasImages
                      ? '${_viewModel.document?.name ?? 'Document'} (${_viewModel.currentPageIndex + 1}/${_viewModel.totalPages})'
                      : 'Новый документ',
                  style: theme.textTheme.large,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(LucideIcons.penLine,
                  size: 14, color: theme.colorScheme.mutedForeground),
            ],
          ),
        ),
        actions: [
          if (_viewModel.hasImages) ...[
            if (_isExporting || _isSharing)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else ...[
              ShadIconButton.ghost(
                icon: const Icon(LucideIcons.fileText),
                onPressed: _exportPdf,
              ),
              ShadIconButton.ghost(
                icon: const Icon(LucideIcons.share2),
                onPressed: _shareDocument,
              ),
            ],
            ShadIconButton.ghost(
              icon: const Icon(LucideIcons.ellipsisVertical),
              onPressed: _showMoreOptions,
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
                  child: ShadButton(
                    enabled: !_viewModel.isLoading,
                    onPressed: _scanDocument,
                    leading: _viewModel.isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              _viewModel.hasImages
                                  ? LucideIcons.refreshCw
                                  : LucideIcons.scan,
                              size: 18,
                            ),
                          ),
                    child: Text(_viewModel.isLoading
                        ? 'Сканирование...'
                        : _viewModel.hasImages
                            ? 'Заново'
                            : 'Сканировать документ'),
                  ),
                ),
                if (_viewModel.hasImages) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadButton.outline(
                      enabled: !_viewModel.isLoading,
                      onPressed: _addPages,
                      leading: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(LucideIcons.plus, size: 18),
                      ),
                      child: const Text('Добавить'),
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.scanLine,
                            size: 48, color: theme.colorScheme.mutedForeground),
                        const SizedBox(height: 16),
                        Text(
                          'Нет отсканированных изображений',
                          style: theme.textTheme.muted,
                        ),
                      ],
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: _viewModel.scannedImages.length,
                    onPageChanged: (index) {
                      _viewModel.setCurrentPage(index);
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _viewModel.editImage(
                          context,
                          _viewModel.scannedImages[index],
                          index,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.border),
                            borderRadius: theme.radius,
                          ),
                          child: ClipRRect(
                            borderRadius: theme.radius,
                            child: Stack(
                              children: [
                                _viewModel.buildImageWidget(index),
                                // Кнопки на изображении
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Row(
                                    children: [
                                      if (_viewModel.isImageEdited(index))
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF22C55E),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Icon(
                                            LucideIcons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => _deletePage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.destructive
                                                .withValues(alpha: 0.9),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Icon(
                                            LucideIcons.trash2,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Подсказка "нажмите для редактирования"
                                Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.foreground
                                            .withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(LucideIcons.penTool,
                                              size: 12,
                                              color:
                                                  theme.colorScheme.background),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Нажмите для редактирования',
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.background,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
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

          // Нижний список страниц
          if (_viewModel.hasImages) ...[
            Divider(color: theme.colorScheme.border),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _viewModel.scannedImages.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  _viewModel.movePage(oldIndex, newIndex);
                  _saveDocument();
                },
                proxyDecorator: (child, index, animation) {
                  return Material(
                    elevation: 4,
                    borderRadius: theme.radius,
                    child: child,
                  );
                },
                itemBuilder: (context, index) {
                  final isSelected = index == _viewModel.currentPageIndex;
                  return GestureDetector(
                    key: ValueKey('page_$index'),
                    onTap: () {
                      _viewModel.setCurrentPage(index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: theme.radius,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: theme.radius,
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
                                  color: theme.colorScheme.foreground
                                      .withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: theme.colorScheme.background,
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
                                    color: const Color(0xFF22C55E),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    LucideIcons.check,
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

class _PageManagementSheet extends StatefulWidget {
  final PdfViewModel viewModel;
  final Function(int, int) onReorder;
  final Function(int) onDelete;
  final Function(int) onPageTap;

  const _PageManagementSheet({
    required this.viewModel,
    required this.onReorder,
    required this.onDelete,
    required this.onPageTap,
  });

  @override
  State<_PageManagementSheet> createState() => _PageManagementSheetState();
}

class _PageManagementSheetState extends State<_PageManagementSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Управление страницами',
                      style: theme.textTheme.large
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.gripVertical,
                            size: 14, color: theme.colorScheme.mutedForeground),
                        const SizedBox(width: 4),
                        Text(
                          'Перетащите для изменения порядка',
                          style: theme.textTheme.muted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  scrollController: scrollController,
                  itemCount: widget.viewModel.scannedImages.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    widget.onReorder(oldIndex, newIndex);
                    setState(() {});
                  },
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      elevation: 4,
                      borderRadius: theme.radius,
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      key: ValueKey('manage_page_$index'),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        border: Border.all(color: theme.colorScheme.border),
                        borderRadius: theme.radius,
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: theme.radius,
                            border: Border.all(color: theme.colorScheme.border),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.file(
                            File(widget.viewModel.scannedImages[index]),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              LucideIcons.image,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                        ),
                        title: Text(
                          'Страница ${index + 1}',
                          style: theme.textTheme.p,
                        ),
                        subtitle: widget.viewModel.isImageEdited(index)
                            ? Row(
                                children: [
                                  const Icon(LucideIcons.check,
                                      size: 12, color: Color(0xFF22C55E)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Отредактировано',
                                    style: theme.textTheme.small.copyWith(
                                        color: const Color(0xFF22C55E)),
                                  ),
                                ],
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShadIconButton.ghost(
                              icon: Icon(
                                LucideIcons.trash2,
                                color: widget.viewModel.totalPages > 1
                                    ? theme.colorScheme.destructive
                                    : theme.colorScheme.mutedForeground,
                              ),
                              onPressed: widget.viewModel.totalPages > 1
                                  ? () {
                                      widget.onDelete(index);
                                      setState(() {});
                                    }
                                  : null,
                            ),
                            Icon(LucideIcons.gripVertical,
                                color: theme.colorScheme.mutedForeground),
                          ],
                        ),
                        onTap: () => widget.onPageTap(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
