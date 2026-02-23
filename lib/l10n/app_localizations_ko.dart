// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => '내 문서';

  @override
  String get searchHint => '검색...';

  @override
  String get searchDocumentsHint => '문서 검색...';

  @override
  String get allDocuments => '모든 문서';

  @override
  String get allDocumentsNoFolder => '모든 문서 (폴더 없음)';

  @override
  String get emptyDocuments => '문서가 없습니다. \'+\'를 눌러 스캔하세요.';

  @override
  String get noDocumentsTitle => '문서 없음';

  @override
  String get noDocumentsDesc => '스캔 버튼을 눌러\n첫 번째 문서를 추가하세요';

  @override
  String get searchNoResultsTitle => '찾을 수 없음';

  @override
  String get searchNoResultsDesc => '검색어를 변경해 보세요';

  @override
  String get scanButton => '스캔';

  @override
  String get importGallery => '갤러리에서 가져오기';

  @override
  String get settings => '설정';

  @override
  String get upgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get premiumActive => '프리미엄 활성';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get contactSupport => '고객 지원';

  @override
  String get privacyPolicy => '개인 정보 정책';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get delete => '삭제';

  @override
  String get share => '공유';

  @override
  String get exportPdf => 'PDF로 내보내기';

  @override
  String get untitledDocument => '제목 없는 문서';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get done => '완료';

  @override
  String get premiumRequired => '프리미엄 기능';

  @override
  String get premiumRequiredDesc => '이 기능은 프리미엄 구독이 필요합니다.';

  @override
  String get unlimitedScans => '무제한 스캔 및 내보내기';

  @override
  String get noAds => '광고 없음';

  @override
  String get highQualityExport => '고품질 PDF 내보내기';

  @override
  String get subscribe => '지금 구독하기';

  @override
  String get paywallTitle => '프리미엄 잠금 해제';

  @override
  String get monthly => '월간';

  @override
  String get yearly => '연간';

  @override
  String get weekly => '주간';

  @override
  String get lifetime => '평생';

  @override
  String get open => '열기';

  @override
  String get rename => '이름 바꾸기';

  @override
  String get moveToFolder => '폴더로 이동';

  @override
  String get addDocument => '문서 추가';

  @override
  String get addDocumentDesc => '문서 추가 방법 선택';

  @override
  String get scanWithCamera => '카메라로 스캔';

  @override
  String get importPdf => 'PDF 가져오기';

  @override
  String get importImages => '이미지 가져오기';

  @override
  String get renameDocument => '문서 이름 바꾸기';

  @override
  String get enterNewName => '새 이름 입력';

  @override
  String get documentName => '문서 이름';

  @override
  String get newFolder => '새 폴더';

  @override
  String get enterFolderName => '폴더 이름 입력';

  @override
  String get folderName => '폴더 이름';

  @override
  String get create => '만들기';

  @override
  String get moveToFolderTitle => '폴더로 이동';

  @override
  String get chooseFolderDesc => '이 문서를 위한 폴더를 선택하세요';

  @override
  String get deleteDocument => '문서 삭제';

  @override
  String get deleteDocumentDesc => '이 문서를 삭제하시겠습니까?';

  @override
  String get deleteFolder => '폴더를 삭제하시겠습니까?';

  @override
  String get deleteFolderDesc => '폴더는 삭제되지만 내부 문서들은 홈 화면으로 이동됩니다.';

  @override
  String get noFolder => '폴더 없음(홈)';

  @override
  String selectedCount(int count) {
    return '선택됨: $count';
  }

  @override
  String get selectAll => '모두';

  @override
  String get premium => '프리미엄';

  @override
  String get managePages => '페이지 관리';

  @override
  String get newDocument => '새 문서';

  @override
  String get scanning => '스캔 중...';

  @override
  String get retake => '다시 찍기';

  @override
  String get scanDocument => '문서 스캔';

  @override
  String get add => '추가';

  @override
  String get noScannedImages => '스캔된 이미지 없음';

  @override
  String get dragToReorder => '드래그하여 순서 변경';

  @override
  String pageIndex(int index) {
    return '$index 페이지';
  }

  @override
  String get edited => '편집됨';

  @override
  String get clickToEdit => '눌러서 편집';

  @override
  String get cannotDeleteAllPages => '모든 페이지를 삭제할 수 없습니다';

  @override
  String deleteSelectedCount(int count) {
    return '선택한 항목 삭제 ($count)';
  }

  @override
  String get scanError => '스캔 오류';

  @override
  String get addPagesError => '페이지 추가 오류';

  @override
  String get saveError => '저장 오류';

  @override
  String get photosAdded => '사진이 추가되었습니다';

  @override
  String get importPhotoError => '사진 가져오기 오류';

  @override
  String get importPdfError => 'PDF 가져오기 오류';

  @override
  String get pdfImported => 'PDF 가져옴';

  @override
  String get pdfSaved => 'PDF 저장됨';

  @override
  String get exportError => '내보내기 오류';

  @override
  String get printError => '인쇄 오류';

  @override
  String get shareError => '공유 오류';

  @override
  String get pdfExportSettings => 'PDF 내보내기 설정';

  @override
  String get choosePageFormat => '페이지 형식 및 여백 선택';

  @override
  String get continueText => '계속';

  @override
  String get pageFormat => '페이지 형식';

  @override
  String get margins => '여백';

  @override
  String get noMargins => '여백 없음 (0)';

  @override
  String get narrowMargins => '좁게 (10)';

  @override
  String get defaultMargins => '기본 (20)';

  @override
  String get cannotDeleteLastPage => '마지막 페이지는 삭제할 수 없습니다';

  @override
  String get deletePage => '페이지 삭제?';

  @override
  String get deletePageDesc => '이 페이지를 삭제하시겠습니까?';

  @override
  String get removeFromFolder => '폴더에서 제거';

  @override
  String pagesCount(int count) {
    return '$count 페이지';
  }

  @override
  String get paywallSubtitle => '모든 앱 기능 잠금 해제';

  @override
  String subscriptionLoadError(String error) {
    return '구독 불러오기 오류: $error';
  }

  @override
  String get close => '닫기';

  @override
  String get advancedEditing => '고급 편집';

  @override
  String get exportAndPrint => '문서 내보내기 및 인쇄';

  @override
  String get unlimitedStorage => '무제한 저장 용량';

  @override
  String get cloudSync => '클라우드 동기화';

  @override
  String get prioritySupport => '우선 지원';

  @override
  String get subscriptionsUnavailable => '구독을 일시적으로 사용할 수 없습니다';

  @override
  String get freeTrial => '무료 체험';

  @override
  String get weeklySubscription => '주간 구독';

  @override
  String get monthlySubscription => '월간 구독';

  @override
  String get annualSubscription => '연간 구독';

  @override
  String get defaultSubscription => '구독';

  @override
  String get weeklyPayment => '매주 결제';

  @override
  String get monthlyPayment => '매월 결제';

  @override
  String get annualPayment => '매년 결제';

  @override
  String get premiumAccess => '프리미엄 액세스';

  @override
  String get purchaseFailed => '구매 실패';

  @override
  String errorWithDetail(String error) {
    return '오류: $error';
  }

  @override
  String get noActiveSubscriptions => '활성화된 구독을 찾을 수 없습니다';
}
