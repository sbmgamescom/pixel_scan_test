// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => 'My Documents';

  @override
  String get searchHint => 'Search...';

  @override
  String get searchDocumentsHint => 'Search documents...';

  @override
  String get allDocuments => 'All documents';

  @override
  String get allDocumentsNoFolder => 'All documents (No folder)';

  @override
  String get emptyDocuments => 'No documents yet. Tap \'+\' to scan.';

  @override
  String get noDocumentsTitle => 'No documents';

  @override
  String get noDocumentsDesc =>
      'Tap the scan button\nto add your first document';

  @override
  String get searchNoResultsTitle => 'Nothing found';

  @override
  String get searchNoResultsDesc => 'Try changing your search query';

  @override
  String get scanButton => 'Scan';

  @override
  String get importGallery => 'Import from Gallery';

  @override
  String get settings => 'Settings';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get untitledDocument => 'Untitled Document';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get premiumRequired => 'Premium Feature';

  @override
  String get premiumRequiredDesc =>
      'This feature requires a premium subscription.';

  @override
  String get unlimitedScans => 'Unlimited Scans & Exports';

  @override
  String get noAds => 'No Ads';

  @override
  String get highQualityExport => 'High Quality PDF Export';

  @override
  String get subscribe => 'Subscribe Now';

  @override
  String get paywallTitle => 'Unlock Premium';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get weekly => 'Weekly';

  @override
  String get lifetime => 'Lifetime';

  @override
  String get open => 'Open';

  @override
  String get rename => 'Rename';

  @override
  String get moveToFolder => 'Move to Folder';

  @override
  String get addDocument => 'Add Document';

  @override
  String get addDocumentDesc => 'Choose how to add a document';

  @override
  String get scanWithCamera => 'Scan with camera';

  @override
  String get importPdf => 'Import PDF';

  @override
  String get importImages => 'Import Images';

  @override
  String get renameDocument => 'Rename Document';

  @override
  String get enterNewName => 'Enter new document name';

  @override
  String get documentName => 'Document Name';

  @override
  String get newFolder => 'New Folder';

  @override
  String get enterFolderName => 'Enter name for new folder';

  @override
  String get folderName => 'Folder Name';

  @override
  String get create => 'Create';

  @override
  String get moveToFolderTitle => 'Move to Folder';

  @override
  String get chooseFolderDesc => 'Choose a folder for this document';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String get deleteDocumentDesc =>
      'Are you sure you want to delete this document?';

  @override
  String get deleteFolder => 'Delete Folder?';

  @override
  String get deleteFolderDesc =>
      'The folder will be deleted, but the documents inside will remain and be moved to the home screen.';

  @override
  String get noFolder => 'Without folder (Home)';

  @override
  String selectedCount(int count) {
    return 'Selected: $count';
  }

  @override
  String get selectAll => 'All';

  @override
  String get premium => 'Premium';

  @override
  String get managePages => 'Manage Pages';

  @override
  String get newDocument => 'New Document';

  @override
  String get scanning => 'Scanning...';

  @override
  String get retake => 'Retake';

  @override
  String get scanDocument => 'Scan Document';

  @override
  String get add => 'Add';

  @override
  String get noScannedImages => 'No scanned images';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String pageIndex(int index) {
    return 'Page $index';
  }

  @override
  String get edited => 'Edited';

  @override
  String get clickToEdit => 'Tap to edit';

  @override
  String get cannotDeleteAllPages => 'Cannot delete all pages';

  @override
  String deleteSelectedCount(int count) {
    return 'Delete selected ($count)';
  }

  @override
  String get scanError => 'Scan Error';

  @override
  String get addPagesError => 'Error adding pages';

  @override
  String get saveError => 'Save Error';

  @override
  String get photosAdded => 'Photos Added';

  @override
  String get importPhotoError => 'Error importing photo';

  @override
  String get importPdfError => 'Error importing PDF';

  @override
  String get pdfImported => 'PDF Imported';

  @override
  String get pdfSaved => 'PDF Saved';

  @override
  String get exportError => 'Export Error';

  @override
  String get printError => 'Print Error';

  @override
  String get shareError => 'Share Error';

  @override
  String get pdfExportSettings => 'PDF Export Settings';

  @override
  String get choosePageFormat => 'Choose page format and margins';

  @override
  String get continueText => 'Continue';

  @override
  String get pageFormat => 'Page Format';

  @override
  String get margins => 'Margins';

  @override
  String get noMargins => 'No margins (0)';

  @override
  String get narrowMargins => 'Narrow (10)';

  @override
  String get defaultMargins => 'Default (20)';

  @override
  String get cannotDeleteLastPage => 'Cannot delete the last page';

  @override
  String get deletePage => 'Delete page?';

  @override
  String get deletePageDesc => 'Are you sure you want to delete this page?';

  @override
  String get removeFromFolder => 'Remove from folder';

  @override
  String pagesCount(int count) {
    return '$count pages';
  }

  @override
  String get paywallSubtitle => 'Unlock all app features';

  @override
  String subscriptionLoadError(String error) {
    return 'Error loading subscriptions: $error';
  }

  @override
  String get close => 'Close';

  @override
  String get advancedEditing => 'Advanced Editing';

  @override
  String get exportAndPrint => 'Export and print documents';

  @override
  String get unlimitedStorage => 'Unlimited Storage';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get prioritySupport => 'Priority Support';

  @override
  String get subscriptionsUnavailable =>
      'Subscriptions are temporarily unavailable';

  @override
  String get freeTrial => 'Free Trial';

  @override
  String get weeklySubscription => 'Weekly Subscription';

  @override
  String get monthlySubscription => 'Monthly Subscription';

  @override
  String get annualSubscription => 'Annual Subscription';

  @override
  String get defaultSubscription => 'Subscription';

  @override
  String get weeklyPayment => 'Pay every week';

  @override
  String get monthlyPayment => 'Pay every month';

  @override
  String get annualPayment => 'Pay once a year';

  @override
  String get premiumAccess => 'Premium access';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String errorWithDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get noActiveSubscriptions => 'No active subscriptions found';
}
