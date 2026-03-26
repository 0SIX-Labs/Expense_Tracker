// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Fynz - 예산 및 지출 추적 앱';

  @override
  String get welcomeToFynz => 'Fynz에 오신 것을 환영합니다';

  @override
  String hello(String userName) {
    return '안녕하세요, $userName님!';
  }

  @override
  String get settings => '설정';

  @override
  String get home => '홈';

  @override
  String get analytics => '분석';

  @override
  String get budget => '예산';

  @override
  String get addExpense => '지출 추가';

  @override
  String get monthlyOverview => '월간 개요';

  @override
  String get income => '수입';

  @override
  String get spent => '사용함';

  @override
  String get remaining => '남은 금액';

  @override
  String get thisMonth => '이번 달';

  @override
  String get thisWeek => '이번 주';

  @override
  String get spendingByCategory => '카테고리별 지출';

  @override
  String get recentTransactions => '최근 거래';

  @override
  String get seeAll => '모두 보기';

  @override
  String get onTrack => '정상';

  @override
  String get overBudget => '예산 초과';

  @override
  String get categories => '카테고리';

  @override
  String get currency => '통화';

  @override
  String get monthStartDay => '월 시작일';

  @override
  String get darkMode => '다크 모드';

  @override
  String get notifications => '알림';

  @override
  String get exportData => '데이터 내보내기';

  @override
  String get exportCSV => 'CSV 내보내기';

  @override
  String get exportPDF => 'PDF 내보내기';

  @override
  String get about => '정보';

  @override
  String get version => '버전';

  @override
  String get developer => '개발자';

  @override
  String get license => '라이센스';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get save => '저장';

  @override
  String get edit => '편집';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get yourName => '이름';

  @override
  String get personalizeExperience => '환경 개인화';

  @override
  String get selectCurrency => '통화 선택';

  @override
  String get currencyAutoDetected => '통화가 자동 감지되었습니다';

  @override
  String get whenMonthStart => '월이 언제 시작되나요?';

  @override
  String get monthStartDescription => '청구 주기가 시작되는 날을 선택하여 지출을 정확하게 추적하세요';

  @override
  String get setMonthlyIncome => '월 수입 설정';

  @override
  String get monthlyIncomeDescription => '수입원을 입력하여 예산을 효과적으로 계획하는 데 도움이 됩니다';

  @override
  String get allSet => '완료되었습니다!';

  @override
  String get allSetDescription => '프로필이 준비되었습니다. 지출 추적을 시작하세요';

  @override
  String get getStarted => '시작하기';

  @override
  String get next => '다음';

  @override
  String get skip => '건너뛰기';

  @override
  String get salary => '급여';

  @override
  String get freelance => '프리랜서';

  @override
  String get investment => '투자';

  @override
  String get other => '기타';

  @override
  String get otherIncome => '기타 수입';

  @override
  String get foodAndDining => '음식 및 식사';

  @override
  String get transport => '교통';

  @override
  String get shopping => '쇼핑';

  @override
  String get entertainment => '엔터테인먼트';

  @override
  String get billsAndUtilities => '청구 및 유틸리티';

  @override
  String get healthcare => '의료';

  @override
  String get education => '교육';

  @override
  String get travel => '여행';

  @override
  String get groceries => '식료품';

  @override
  String get deleteExpense => '지출 삭제';

  @override
  String get confirmDelete => '이 지출을 삭제하시겠습니까?';

  @override
  String get expenseDeleted => '지출이 성공적으로 삭제되었습니다';

  @override
  String get profileUpdated => '프로필이 성공적으로 업데이트되었습니다';

  @override
  String get manageCategories => '카테고리 관리';

  @override
  String get categoriesDescription => '사용자 지정 지출 및 수입 카테고리 생성 및 관리';

  @override
  String get getBudgetAlerts => '예산 알림 및 미리 알림 받기';

  @override
  String get enableDarkTheme => '다크 테마 활성화';

  @override
  String get customizeExperience => '환경 사용자 정의';

  @override
  String get profile => '프로필';

  @override
  String monthStartsOnDay(int day) {
    return '월이 $day일에 시작됩니다';
  }

  @override
  String yourBillingCycle(int day) {
    return '청구 주기는 매월 $day일에 시작됩니다';
  }

  @override
  String get monthlyIncomeSources => '월별 수입원';

  @override
  String get dayOne => '1일';

  @override
  String get dayTwentyEight => '28일';

  @override
  String get selected => '선택됨';

  @override
  String get thisCurrencyWillBeUsed => '이 통화는 앱 전체의 모든 거래에 사용됩니다';

  @override
  String get pleaseEnterYourName => '이름을 입력해주세요';

  @override
  String get failedToSaveProfile => '프로필 저장에 실패했습니다';

  @override
  String get anErrorOccurred => '오류가 발생했습니다. 다시 시도해주세요';

  @override
  String get failedToDeleteExpense => '지출 삭제에 실패했습니다';

  @override
  String get language => '언어';

  @override
  String get chooseLanguage => '선호하는 언어를 선택하세요';

  @override
  String get selectYourCurrency => '통화를 선택하세요';

  @override
  String get billingCycleStart => '청구 주기 시작';

  @override
  String get billingCycleDescription => '지출 추적 주기는 매월 이 날짜에 재설정됩니다';

  @override
  String get day => '일';

  @override
  String get nativeMobileApp => '네이티브 모바일 앱';

  @override
  String get fullyPrivate => '100% 비공개';

  @override
  String get allDataStaysOnDevice => '모든 데이터는 기기에 저장됩니다';

  @override
  String get noBackend => '백엔드 없음';

  @override
  String get noServerNoAccount => '서버 불필요, 계정 불필요';

  @override
  String get fullyOffline => '완전 오프라인';

  @override
  String get worksWithoutInternet => '인터넷 없이 작동';

  @override
  String get lightningFast => '초고속';

  @override
  String get instantAccessNoLoading => '즉시 접근, 로딩 없음';

  @override
  String get pleaseEnterYourNameToContinue => '계속하려면 이름을 입력하세요';

  @override
  String get welcomeToFynzDescription => '100% 오프라인으로 작동하는 개인 지출 추적기';

  @override
  String get personalizeExperienceDescription => '이름부터 시작하겠습니다';
}
