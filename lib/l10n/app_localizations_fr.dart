// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => 'Mes Documents';

  @override
  String get searchHint => 'Rechercher...';

  @override
  String get searchDocumentsHint => 'Rechercher des documents...';

  @override
  String get allDocuments => 'Tous les documents';

  @override
  String get allDocumentsNoFolder => 'Tous les documents (Sans dossier)';

  @override
  String get emptyDocuments =>
      'Aucun document. Appuyez sur \'+\' pour scanner.';

  @override
  String get noDocumentsTitle => 'Aucun document';

  @override
  String get noDocumentsDesc =>
      'Appuyez sur le bouton de scan\npour ajouter votre premier document';

  @override
  String get searchNoResultsTitle => 'Rien n\'a été trouvé';

  @override
  String get searchNoResultsDesc => 'Essayez de modifier votre requête';

  @override
  String get scanButton => 'Scanner';

  @override
  String get importGallery => 'Importer de la Galerie';

  @override
  String get settings => 'Paramètres';

  @override
  String get upgradeToPremium => 'Passer à Premium';

  @override
  String get premiumActive => 'Premium Actif';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get delete => 'Supprimer';

  @override
  String get share => 'Partager';

  @override
  String get exportPdf => 'Exporter en PDF';

  @override
  String get untitledDocument => 'Document sans titre';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'Terminé';

  @override
  String get premiumRequired => 'Fonction Premium';

  @override
  String get premiumRequiredDesc =>
      'Cette fonction requiert un abonnement premium.';

  @override
  String get unlimitedScans => 'Scans et Exportations Illimités';

  @override
  String get noAds => 'Sans Publicités';

  @override
  String get highQualityExport => 'Exportation PDF Haute Qualité';

  @override
  String get subscribe => 'S\'abonner Maintenant';

  @override
  String get paywallTitle => 'Débloquer Premium';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get lifetime => 'À vie';

  @override
  String get open => 'Ouvrir';

  @override
  String get rename => 'Renommer';

  @override
  String get moveToFolder => 'Déplacer vers un dossier';

  @override
  String get addDocument => 'Ajouter un Document';

  @override
  String get addDocumentDesc => 'Choisissez comment ajouter';

  @override
  String get scanWithCamera => 'Scanner avec l\'appareil photo';

  @override
  String get importPdf => 'Importer un PDF';

  @override
  String get importImages => 'Importer des Images';

  @override
  String get renameDocument => 'Renommer le Document';

  @override
  String get enterNewName => 'Entrez un nouveau nom';

  @override
  String get documentName => 'Nom du document';

  @override
  String get newFolder => 'Nouveau Dossier';

  @override
  String get enterFolderName => 'Entrez un nom pour le dossier';

  @override
  String get folderName => 'Nom du dossier';

  @override
  String get create => 'Créer';

  @override
  String get moveToFolderTitle => 'Déplacer vers un dossier';

  @override
  String get chooseFolderDesc => 'Choisissez un dossier';

  @override
  String get deleteDocument => 'Supprimer le Document';

  @override
  String get deleteDocumentDesc =>
      'Êtes-vous sûr de vouloir supprimer ce document ?';

  @override
  String get deleteFolder => 'Supprimer le Dossier ?';

  @override
  String get deleteFolderDesc =>
      'Le dossier sera supprimé, mais les documents seront conservés dans l\'accueil.';

  @override
  String get noFolder => 'Sans dossier (Accueil)';

  @override
  String selectedCount(int count) {
    return 'Sélectionnés : $count';
  }

  @override
  String get selectAll => 'Tous';

  @override
  String get premium => 'Premium';

  @override
  String get managePages => 'Gérer les Pages';

  @override
  String get newDocument => 'Nouveau Document';

  @override
  String get scanning => 'Scan en cours...';

  @override
  String get retake => 'Reprendre';

  @override
  String get scanDocument => 'Scanner le Document';

  @override
  String get add => 'Ajouter';

  @override
  String get noScannedImages => 'Aucune image scannée';

  @override
  String get dragToReorder => 'Faites glisser pour réorganiser';

  @override
  String pageIndex(int index) {
    return 'Page $index';
  }

  @override
  String get edited => 'Édité';

  @override
  String get clickToEdit => 'Appuyez pour éditer';

  @override
  String get cannotDeleteAllPages => 'Impossible de supprimer toutes les pages';

  @override
  String deleteSelectedCount(int count) {
    return 'Supprimer la sélection ($count)';
  }

  @override
  String get scanError => 'Erreur de scan';

  @override
  String get addPagesError => 'Erreur d\'ajout de pages';

  @override
  String get saveError => 'Erreur d\'enregistrement';

  @override
  String get photosAdded => 'Photos ajoutées';

  @override
  String get importPhotoError => 'Erreur d\'importation de photo';

  @override
  String get importPdfError => 'Erreur d\'importation de PDF';

  @override
  String get pdfImported => 'PDF Importé';

  @override
  String get pdfSaved => 'PDF Enregistré';

  @override
  String get exportError => 'Erreur d\'exportation';

  @override
  String get printError => 'Erreur d\'impression';

  @override
  String get shareError => 'Erreur de partage';

  @override
  String get pdfExportSettings => 'Paramètres d\'export PDF';

  @override
  String get choosePageFormat => 'Choisissez le format et les marges';

  @override
  String get continueText => 'Continuer';

  @override
  String get pageFormat => 'Format de page';

  @override
  String get margins => 'Marges';

  @override
  String get noMargins => 'Sans marges (0)';

  @override
  String get narrowMargins => 'Étroit (10)';

  @override
  String get defaultMargins => 'Défaut (20)';

  @override
  String get cannotDeleteLastPage => 'Impossible de supprimer la dernière page';

  @override
  String get deletePage => 'Supprimer la page ?';

  @override
  String get deletePageDesc =>
      'Êtes-vous sûr de vouloir supprimer cette page ?';

  @override
  String get removeFromFolder => 'Retirer du dossier';

  @override
  String pagesCount(int count) {
    return '$count pages';
  }

  @override
  String get paywallSubtitle => 'Débloquez toutes les fonctionnalités';

  @override
  String subscriptionLoadError(String error) {
    return 'Erreur de chargement: $error';
  }

  @override
  String get close => 'Fermer';

  @override
  String get advancedEditing => 'Édition avancée';

  @override
  String get exportAndPrint => 'Exporter et imprimer';

  @override
  String get unlimitedStorage => 'Stockage illimité';

  @override
  String get cloudSync => 'Synchronisation Cloud';

  @override
  String get prioritySupport => 'Support prioritaire';

  @override
  String get subscriptionsUnavailable =>
      'Abonnements temporairement indisponibles';

  @override
  String get freeTrial => 'Essai Gratuit';

  @override
  String get weeklySubscription => 'Abonnement Hebdomadaire';

  @override
  String get monthlySubscription => 'Abonnement Mensuel';

  @override
  String get annualSubscription => 'Abonnement Annuel';

  @override
  String get defaultSubscription => 'Abonnement';

  @override
  String get weeklyPayment => 'Payer chaque semaine';

  @override
  String get monthlyPayment => 'Payer chaque mois';

  @override
  String get annualPayment => 'Payer une fois par an';

  @override
  String get premiumAccess => 'Accès premium';

  @override
  String get purchaseFailed => 'Échec de l\'achat';

  @override
  String errorWithDetail(String error) {
    return 'Erreur: $error';
  }

  @override
  String get noActiveSubscriptions => 'Aucun abonnement actif trouvé';
}
