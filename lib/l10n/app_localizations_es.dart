// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => 'Mis documentos';

  @override
  String get searchHint => 'Buscar...';

  @override
  String get searchDocumentsHint => 'Buscar documentos...';

  @override
  String get allDocuments => 'Todos los documentos';

  @override
  String get allDocumentsNoFolder => 'Todos los documentos (Sin carpeta)';

  @override
  String get emptyDocuments =>
      'Aún no hay documentos. Toca \'+\' para escanear.';

  @override
  String get noDocumentsTitle => 'No hay documentos';

  @override
  String get noDocumentsDesc =>
      'Toca el botón de escaneo\npara agregar tu primer documento';

  @override
  String get searchNoResultsTitle => 'No se encontró nada';

  @override
  String get searchNoResultsDesc => 'Prueba cambiar tu consulta de búsqueda';

  @override
  String get scanButton => 'Escanear';

  @override
  String get importGallery => 'Importar desde la Galería';

  @override
  String get settings => 'Ajustes';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String get premiumActive => 'Premium Activo';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get contactSupport => 'Contactar Soporte';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get delete => 'Eliminar';

  @override
  String get share => 'Compartir';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get untitledDocument => 'Documento sin título';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get done => 'Hecho';

  @override
  String get premiumRequired => 'Función Premium';

  @override
  String get premiumRequiredDesc =>
      'Esta función requiere una suscripción premium.';

  @override
  String get unlimitedScans => 'Escaneos y Exportaciones Ilimitados';

  @override
  String get noAds => 'Sin Anuncios';

  @override
  String get highQualityExport => 'Exportación a PDF de Alta Calidad';

  @override
  String get subscribe => 'Suscribirse Ahora';

  @override
  String get paywallTitle => 'Desbloquear Premium';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get weekly => 'Semanal';

  @override
  String get lifetime => 'De Por Vida';

  @override
  String get open => 'Abrir';

  @override
  String get rename => 'Renombrar';

  @override
  String get moveToFolder => 'Mover a Carpeta';

  @override
  String get addDocument => 'Añadir Documento';

  @override
  String get addDocumentDesc => 'Elige cómo añadir un documento';

  @override
  String get scanWithCamera => 'Escanear con cámara';

  @override
  String get importPdf => 'Importar PDF';

  @override
  String get importImages => 'Importar Imágenes';

  @override
  String get renameDocument => 'Renombrar Documento';

  @override
  String get enterNewName => 'Introduce un nuevo nombre';

  @override
  String get documentName => 'Nombre del documento';

  @override
  String get newFolder => 'Nueva Carpeta';

  @override
  String get enterFolderName => 'Introduce nombre para la carpeta';

  @override
  String get folderName => 'Nombre de carpeta';

  @override
  String get create => 'Crear';

  @override
  String get moveToFolderTitle => 'Mover a Carpeta';

  @override
  String get chooseFolderDesc => 'Elige una carpeta para este documento';

  @override
  String get deleteDocument => 'Eliminar Documento';

  @override
  String get deleteDocumentDesc =>
      '¿Estás seguro de que quieres eliminar este documento?';

  @override
  String get deleteFolder => '¿Eliminar Carpeta?';

  @override
  String get deleteFolderDesc =>
      'La carpeta se eliminará, pero los documentos dentro se mantendrán y se moverán a la pantalla inicial.';

  @override
  String get noFolder => 'Sin carpeta (Inicio)';

  @override
  String selectedCount(int count) {
    return 'Seleccionados: $count';
  }

  @override
  String get selectAll => 'Todos';

  @override
  String get premium => 'Premium';

  @override
  String get managePages => 'Gestionar Páginas';

  @override
  String get newDocument => 'Nuevo Documento';

  @override
  String get scanning => 'Escaneando...';

  @override
  String get retake => 'Volver a tomar';

  @override
  String get scanDocument => 'Escanear Documento';

  @override
  String get add => 'Añadir';

  @override
  String get noScannedImages => 'No hay imágenes escaneadas';

  @override
  String get dragToReorder => 'Arrastra para reordenar';

  @override
  String pageIndex(int index) {
    return 'Página $index';
  }

  @override
  String get edited => 'Editado';

  @override
  String get clickToEdit => 'Toca para editar';

  @override
  String get cannotDeleteAllPages => 'No se pueden eliminar todas las páginas';

  @override
  String deleteSelectedCount(int count) {
    return 'Eliminar seleccionados ($count)';
  }

  @override
  String get scanError => 'Error de Esceneo';

  @override
  String get addPagesError => 'Error al añadir páginas';

  @override
  String get saveError => 'Error al Guardar';

  @override
  String get photosAdded => 'Fotos Añadidas';

  @override
  String get importPhotoError => 'Error al importar foto';

  @override
  String get importPdfError => 'Error al importar PDF';

  @override
  String get pdfImported => 'PDF Importado';

  @override
  String get pdfSaved => 'PDF Guardado';

  @override
  String get exportError => 'Error de Exportación';

  @override
  String get printError => 'Error de Impresión';

  @override
  String get shareError => 'Error de Compartir';

  @override
  String get pdfExportSettings => 'Ajustes de Exportación';

  @override
  String get choosePageFormat => 'Elige formato y márgenes';

  @override
  String get continueText => 'Continuar';

  @override
  String get pageFormat => 'Formato de Página';

  @override
  String get margins => 'Márgenes';

  @override
  String get noMargins => 'Sin márgenes (0)';

  @override
  String get narrowMargins => 'Estrecho (10)';

  @override
  String get defaultMargins => 'Por defecto (20)';

  @override
  String get cannotDeleteLastPage => 'No se puede eliminar la última página';

  @override
  String get deletePage => '¿Eliminar página?';

  @override
  String get deletePageDesc =>
      '¿Estás seguro de que quieres eliminar esta página?';

  @override
  String get removeFromFolder => 'Eliminar de la carpeta';

  @override
  String pagesCount(int count) {
    return '$count páginas';
  }

  @override
  String get paywallSubtitle => 'Desbloquea todas las funciones';

  @override
  String subscriptionLoadError(String error) {
    return 'Error al cargar sucripciones: $error';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get advancedEditing => 'Edición Avanzada';

  @override
  String get exportAndPrint => 'Exportar e imprimir documentos';

  @override
  String get unlimitedStorage => 'Almacenamiento Ilimitado';

  @override
  String get cloudSync => 'Sincronización en la Nube';

  @override
  String get prioritySupport => 'Soporte Prioritario';

  @override
  String get subscriptionsUnavailable =>
      'Suscripciones no disponibles temporalmente';

  @override
  String get freeTrial => 'Prueba Gratis';

  @override
  String get weeklySubscription => 'Suscripción Semanal';

  @override
  String get monthlySubscription => 'Suscripción Mensual';

  @override
  String get annualSubscription => 'Suscripción Anual';

  @override
  String get defaultSubscription => 'Suscripción';

  @override
  String get weeklyPayment => 'Pagar cada semana';

  @override
  String get monthlyPayment => 'Pagar cada mes';

  @override
  String get annualPayment => 'Pagar una vez al año';

  @override
  String get premiumAccess => 'Acceso premium';

  @override
  String get purchaseFailed => 'Error en la compra';

  @override
  String errorWithDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get noActiveSubscriptions => 'No se encontraron suscripciones activas';
}
