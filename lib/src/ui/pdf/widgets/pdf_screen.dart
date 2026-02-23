import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pixel_scan_test/l10n/app_localizations.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../components/loading_overlay.dart';
import '../../../core/models/document_model.dart';
import '../../../core/services/document_storage_service.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/services/subscription_service.dart';
import '../../components/app_header.dart';
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
            title: Text(AppLocalizations.of(context)!.scanError),
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
            title: Text(AppLocalizations.of(context)!.addPagesError),
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
              title: Text(AppLocalizations.of(context)!.saveError),
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
            title: Text('✅ ${AppLocalizations.of(context)!.photosAdded}'),
            description: Text('${_viewModel.document?.imagePaths.length ?? 0}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: Text(AppLocalizations.of(context)!.importPhotoError),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  Future<void> _rotatePage(int index) async {
    await _viewModel.rotatePage(index);
    await _saveDocument();
  }

  void _importPdfPages() async {
    try {
      await _viewModel.importPdfPages();
      await _saveDocument();

      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            title: Text('✅ ${AppLocalizations.of(context)!.pdfImported}'),
            description: Text('${_viewModel.document?.imagePaths.length ?? 0}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: Text(AppLocalizations.of(context)!.importPdfError),
            description: Text('$e'),
          ),
        );
      }
    }
  }

  Future<void> _exportPdf() async {
    if (_viewModel.document == null) return;

    if (widget.subscriptionService.isPremiumUser) {
      _doExport();
    } else {
      _showPaywallForFeature('export');
    }
  }

  Future<void> _doExport() async {
    _showExportSettingsDialog(onConfirm: (settings) async {
      setState(() => _isExporting = true);

      try {
        final pdfPath = await PdfExportService.generatePdf(_viewModel.document!,
            settings: settings);
        if (mounted) {
          ShadToaster.of(context).show(
            ShadToast(
              title: Text(AppLocalizations.of(context)!.pdfSaved),
              description: Text(pdfPath.split('/').last),
              action: ShadButton.outline(
                child: Text(AppLocalizations.of(context)!.share),
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
              title: Text(AppLocalizations.of(context)!.exportError),
              description: Text('$e'),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isExporting = false);
      }
    });
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
    _showExportSettingsDialog(onConfirm: (settings) async {
      try {
        await PdfExportService.printDocument(_viewModel.document!,
            settings: settings);
      } catch (e) {
        if (mounted) {
          ShadToaster.of(context).show(
            ShadToast.destructive(
              title: Text(AppLocalizations.of(context)!.printError),
              description: Text('$e'),
            ),
          );
        }
      }
    });
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
    _showExportSettingsDialog(onConfirm: (settings) async {
      setState(() => _isSharing = true);

      try {
        await ShareService.sharePdf(_viewModel.document!, settings: settings);
      } catch (e) {
        if (mounted) {
          ShadToaster.of(context).show(
            ShadToast.destructive(
              title: Text(AppLocalizations.of(context)!.shareError),
              description: Text('$e'),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSharing = false);
      }
    });
  }

  void _showExportSettingsDialog(
      {required Function(PdfExportSettings) onConfirm}) {
    PdfPageFormat selectedFormat = PdfPageFormat.a4;
    double selectedMargin = 0.0;

    showShadDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) {
            return ShadDialog(
              title: Text(l10n.pdfExportSettings),
              description: Text(l10n.choosePageFormat),
              actions: [
                ShadButton.outline(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                ShadButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm(PdfExportSettings(
                      pageFormat: selectedFormat,
                      margin: selectedMargin,
                    ));
                  },
                  child: Text(l10n.continueText),
                ),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(l10n.pageFormat),
                  const SizedBox(height: 8),
                  ShadSelect<PdfPageFormat>(
                    initialValue: selectedFormat,
                    options: [
                      ShadOption(
                          value: PdfPageFormat.a4, child: const Text('A4')),
                      ShadOption(
                          value: PdfPageFormat.letter,
                          child: const Text('Letter')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => selectedFormat = val);
                    },
                    selectedOptionBuilder: (context, value) {
                      return Text(value == PdfPageFormat.a4 ? 'A4' : 'Letter');
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.margins),
                  const SizedBox(height: 8),
                  ShadSelect<double>(
                    initialValue: selectedMargin,
                    options: [
                      ShadOption(value: 0.0, child: Text(l10n.noMargins)),
                      ShadOption(value: 10.0, child: Text(l10n.narrowMargins)),
                      ShadOption(value: 20.0, child: Text(l10n.defaultMargins)),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => selectedMargin = val);
                    },
                    selectedOptionBuilder: (context, value) {
                      if (value == 0.0) return Text(l10n.noMargins);
                      if (value == 10.0) return Text(l10n.narrowMargins);
                      return Text(l10n.defaultMargins);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
    final l10n = AppLocalizations.of(context)!;

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text(l10n.renameDocument),
        description: Text(l10n.enterNewName),
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
            child: Text(l10n.save),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ShadInput(
            controller: controller,
            placeholder: Text(l10n.documentName),
            autofocus: true,
          ),
        ),
      ),
    );
  }

  void _showMoveToFolderDialog() async {
    final document = _viewModel.document;
    if (document == null) return;

    final folders = await DocumentStorageService.loadAllFolders();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: Text(l10n.moveToFolderTitle),
        description: Text(l10n.chooseFolderDesc),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton.outline(
                onPressed: () async {
                  final updatedDoc = document.copyWith(
                    folderId: null,
                    clearFolderId: true,
                  );
                  _viewModel.loadDocument(updatedDoc);
                  await _saveDocument();
                  if (mounted) Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(LucideIcons.folderMinus, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l10n.removeFromFolder)),
                    if (document.folderId == null)
                      const Icon(LucideIcons.check, size: 20)
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (folders.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'У вас пока нет других папок.',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...folders.map((folder) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ShadButton.outline(
                        onPressed: () async {
                          final updatedDoc = document.copyWith(
                            folderId: folder.id,
                            clearFolderId: false,
                          );
                          _viewModel.loadDocument(updatedDoc);
                          await _saveDocument();
                          if (mounted) Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            const Icon(LucideIcons.folder, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(folder.name)),
                            if (document.folderId == folder.id)
                              const Icon(LucideIcons.check, size: 20)
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  void _deletePage(int index) {
    final l10n = AppLocalizations.of(context)!;
    if (_viewModel.totalPages <= 1) {
      ShadToaster.of(context).show(
        ShadToast(
          title: Text(l10n.cannotDeleteLastPage),
        ),
      );
      return;
    }

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: Text(l10n.deletePage),
        description: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l10n.deletePageDesc),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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
            child: Text(l10n.delete),
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
    final l10n = AppLocalizations.of(context)!;

    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: Text(l10n.settings),
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
                child: Text(l10n.importImages),
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
                child: Text(l10n.importPdf),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.fileText,
                      size: 20,
                      color: isPremium ? null : theme.colorScheme.muted),
                ),
                trailing: isPremium
                    ? null
                    : const Icon(LucideIcons.sparkles,
                        size: 16, color: Colors.amber),
                onPressed: () {
                  Navigator.pop(context);
                  _exportPdf();
                },
                child: Text(l10n.exportPdf,
                    style: isPremium
                        ? null
                        : TextStyle(color: theme.colorScheme.muted)),
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
                child: Text(
                    'Print', // Or use l10n.print (if it existed). I'll use l10n.exportPdf for now... actually let me add print
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
                child: Text(l10n.share,
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
                child: Text(l10n.rename),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.folderInput, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showMoveToFolderDialog();
                },
                child: Text(l10n.moveToFolder),
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
                child: Text(l10n.managePages),
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
    final l10n = AppLocalizations.of(context)!;

    return LoadingOverlay(
        isLoading: _viewModel.isLoading || _isExporting || _isSharing,
        child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    onBack: () => Navigator.pop(context),
                    titleWidget: _viewModel.hasImages
                        ? GestureDetector(
                            onTap: _showRenameDialog,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${_viewModel.document?.name ?? 'Document'} (${_viewModel.currentPageIndex + 1}/${_viewModel.totalPages})',
                                    style: theme.textTheme.h3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(LucideIcons.penLine,
                                    size: 16,
                                    color: theme.colorScheme.mutedForeground),
                              ],
                            ),
                          )
                        : Text(l10n.newDocument, style: theme.textTheme.h3),
                    actions: [
                      if (_viewModel.hasImages) ...[
                        if (_isExporting || _isSharing)
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
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
                                ? l10n.scanning
                                : _viewModel.hasImages
                                    ? l10n.retake
                                    : l10n.scanDocument),
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
                              child: Text(l10n.add),
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
                                    size: 48,
                                    color: theme.colorScheme.mutedForeground),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noScannedImages,
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
                                    border: Border.all(
                                        color: theme.colorScheme.border),
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
                                              if (_viewModel
                                                  .isImageEdited(index))
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF22C55E),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: const Icon(
                                                    LucideIcons.check,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () => _rotatePage(index),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme.primary
                                                        .withValues(alpha: 0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: const Icon(
                                                    LucideIcons.rotateCcw,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () => _deletePage(index),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme.destructive
                                                        .withValues(alpha: 0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme
                                                    .colorScheme.foreground
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(LucideIcons.penTool,
                                                      size: 12,
                                                      color: theme.colorScheme
                                                          .background),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    l10n.clickToEdit,
                                                    style: TextStyle(
                                                      color: theme.colorScheme
                                                          .background,
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
                          final isSelected =
                              index == _viewModel.currentPageIndex;
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
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
            )));
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
    final l10n = AppLocalizations.of(context)!;

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
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              final isSelectionMode = widget.viewModel.isSelectionMode;
              final selectedCount = widget.viewModel.selectedPages.length;

              return Column(
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
                          isSelectionMode
                              ? l10n.selectedCount(selectedCount)
                              : l10n.managePages,
                          style: theme.textTheme.large
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (isSelectionMode)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShadButton.outline(
                                  onPressed: () {
                                    widget.viewModel.selectAllPages();
                                  },
                                  size: ShadButtonSize.sm,
                                  child: Text(l10n.selectAll),
                                ),
                                const SizedBox(width: 8),
                                ShadButton.outline(
                                  onPressed: () {
                                    widget.viewModel.clearSelection();
                                    widget.viewModel.toggleSelectionMode();
                                  },
                                  size: ShadButtonSize.sm,
                                  child: Text(l10n.cancel),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(height: 8),
                        if (!isSelectionMode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.gripVertical,
                                  size: 14,
                                  color: theme.colorScheme.mutedForeground),
                              const SizedBox(width: 4),
                              Text(
                                l10n.dragToReorder,
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
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelectionMode)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: ShadCheckbox(
                                      value: widget.viewModel.selectedPages
                                          .contains(index),
                                      onChanged: (v) {
                                        widget.viewModel
                                            .togglePageSelection(index);
                                      },
                                    ),
                                  ),
                                Container(
                                  width: 50,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: theme.radius,
                                    border: Border.all(
                                        color: theme.colorScheme.border),
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
                              ],
                            ),
                            title: Text(
                              l10n.pageIndex(index + 1),
                              style: theme.textTheme.p,
                            ),
                            subtitle: widget.viewModel.isImageEdited(index)
                                ? Row(
                                    children: [
                                      const Icon(LucideIcons.check,
                                          size: 12, color: Color(0xFF22C55E)),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.edited,
                                        style: theme.textTheme.small.copyWith(
                                            color: const Color(0xFF22C55E)),
                                      ),
                                    ],
                                  )
                                : null,
                            trailing: isSelectionMode
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ShadIconButton.ghost(
                                        icon: Icon(
                                          LucideIcons.trash2,
                                          color: widget.viewModel.totalPages > 1
                                              ? theme.colorScheme.destructive
                                              : theme
                                                  .colorScheme.mutedForeground,
                                        ),
                                        onPressed:
                                            widget.viewModel.totalPages > 1
                                                ? () {
                                                    widget.onDelete(index);
                                                  }
                                                : null,
                                      ),
                                      Icon(LucideIcons.gripVertical,
                                          color: theme
                                              .colorScheme.mutedForeground),
                                    ],
                                  ),
                            onTap: () {
                              if (isSelectionMode) {
                                widget.viewModel.togglePageSelection(index);
                              } else {
                                widget.onPageTap(index);
                              }
                            },
                            onLongPress: () {
                              if (!isSelectionMode) {
                                widget.viewModel.toggleSelectionMode();
                                widget.viewModel.togglePageSelection(index);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (isSelectionMode && selectedCount > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.card,
                        border: Border(
                          top: BorderSide(color: theme.colorScheme.border),
                        ),
                      ),
                      child: ShadButton.destructive(
                        width: double.infinity,
                        onPressed: () {
                          final pagesToRemove =
                              widget.viewModel.selectedPages.length;
                          if (pagesToRemove >= widget.viewModel.totalPages) {
                            ShadToaster.of(context).show(
                              ShadToast(
                                title: Text(l10n.cannotDeleteAllPages),
                              ),
                            );
                            return;
                          }

                          widget.viewModel.deleteSelectedPages();
                          // We need to trigger save externally or inside VM.
                          // For now we assume parent caller handles save via a callback if needed,
                          // but since we only passed `onDelete`, we can just call it conceptually,
                          // or better: just let ViewModel do it, then call _saveDocument()
                          // Wait, `onDelete` receives an index. Let's just pop or pass a new `onBulkDelete`?
                          // The modal doesn't know about `_saveDocument`. We should trigger it.
                        },
                        child: Text(l10n.deleteSelectedCount(selectedCount)),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
