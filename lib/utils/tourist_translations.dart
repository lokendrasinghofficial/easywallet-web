/// Supported tourist languages
enum TouristLang { en, zh, vi, id, fil }

extension TouristLangExt on TouristLang {
  String get code {
    switch (this) {
      case TouristLang.en: return 'tourist_en';
      case TouristLang.zh: return 'tourist_zh';
      case TouristLang.vi: return 'tourist_vi';
      case TouristLang.id: return 'tourist_id';
      case TouristLang.fil: return 'tourist_fil';
    }
  }

  String get label {
    switch (this) {
      case TouristLang.en: return 'English';
      case TouristLang.zh: return '中文';
      case TouristLang.vi: return 'Tiếng Việt';
      case TouristLang.id: return 'Bahasa';
      case TouristLang.fil: return 'Filipino';
    }
  }

  String get flag {
    switch (this) {
      case TouristLang.en: return '🇬🇧';
      case TouristLang.zh: return '🇹🇼';
      case TouristLang.vi: return '🇻🇳';
      case TouristLang.id: return '🇮🇩';
      case TouristLang.fil: return '🇵🇭';
    }
  }

  static TouristLang fromCode(String code) {
    return TouristLang.values.firstWhere(
      (l) => l.code == code,
      orElse: () => TouristLang.en,
    );
  }
}

/// Static translation strings for the Tourist screen
class TouristStrings {
  final String appTitle;
  final String language;
  final String currencyHelper;
  final String scanAndPay;
  final String transportQr;
  final String travelOffers;
  final String nearbyStores;
  final String returnNormal;
  final String offer1Title;
  final String offer1Sub;
  final String offer2Title;
  final String offer2Sub;
  final String store1;
  final String store2;
  final String mAway;

  const TouristStrings({
    required this.appTitle,
    required this.language,
    required this.currencyHelper,
    required this.scanAndPay,
    required this.transportQr,
    required this.travelOffers,
    required this.nearbyStores,
    required this.returnNormal,
    required this.offer1Title,
    required this.offer1Sub,
    required this.offer2Title,
    required this.offer2Sub,
    required this.store1,
    required this.store2,
    required this.mAway,
  });
}

const Map<TouristLang, TouristStrings> touristTranslations = {
  TouristLang.en: TouristStrings(
    appTitle: 'Tourist Wallet',
    language: 'Language',
    currencyHelper: 'Currency Helper',
    scanAndPay: 'Scan & Pay',
    transportQr: 'Transport QR',
    travelOffers: 'Travel Offers',
    nearbyStores: 'Nearby Stores',
    returnNormal: 'Return to Normal Mode',
    offer1Title: '30% off at Taipei 101',
    offer1Sub: 'Limited time deal for tourists',
    offer2Title: 'Free MRT Trip',
    offer2Sub: 'First trip on us!',
    store1: '7-Eleven Xinyi',
    store2: 'KFC Songshan',
    mAway: 'away',
  ),
  TouristLang.zh: TouristStrings(
    appTitle: '旅客錢包',
    language: '語言',
    currencyHelper: '匯率工具',
    scanAndPay: '掃碼付款',
    transportQr: '交通碼',
    travelOffers: '旅遊優惠',
    nearbyStores: '附近商店',
    returnNormal: '返回一般模式',
    offer1Title: '台北101折扣30%',
    offer1Sub: '限時旅客優惠',
    offer2Title: '捷運免費一次',
    offer2Sub: '首次搭乘免費',
    store1: '7-Eleven 信義店',
    store2: 'KFC 松山店',
    mAway: '外',
  ),
  TouristLang.vi: TouristStrings(
    appTitle: 'Ví du lịch',
    language: 'Ngôn ngữ',
    currencyHelper: 'Công cụ tiền tệ',
    scanAndPay: 'Quét & Thanh toán',
    transportQr: 'Mã giao thông',
    travelOffers: 'Ưu đãi du lịch',
    nearbyStores: 'Cửa hàng gần đây',
    returnNormal: 'Quay lại chế độ thường',
    offer1Title: 'Giảm 30% tại Taipei 101',
    offer1Sub: 'Ưu đãi có hạn cho khách du lịch',
    offer2Title: 'Chuyến tàu MRT miễn phí',
    offer2Sub: 'Chuyến đầu tiên miễn phí!',
    store1: '7-Eleven Xinyi',
    store2: 'KFC Songshan',
    mAway: 'cách',
  ),
  TouristLang.id: TouristStrings(
    appTitle: 'Dompet Wisata',
    language: 'Bahasa',
    currencyHelper: 'Konversi Mata Uang',
    scanAndPay: 'Pindai & Bayar',
    transportQr: 'QR Transportasi',
    travelOffers: 'Penawaran Wisata',
    nearbyStores: 'Toko Terdekat',
    returnNormal: 'Kembali ke Mode Normal',
    offer1Title: 'Diskon 30% di Taipei 101',
    offer1Sub: 'Penawaran terbatas untuk wisatawan',
    offer2Title: 'Perjalanan MRT Gratis',
    offer2Sub: 'Perjalanan pertama gratis!',
    store1: '7-Eleven Xinyi',
    store2: 'KFC Songshan',
    mAway: 'jauh',
  ),
  TouristLang.fil: TouristStrings(
    appTitle: 'Wallet ng Turista',
    language: 'Wika',
    currencyHelper: 'Tagapag-convert ng Pera',
    scanAndPay: 'I-scan at Magbayad',
    transportQr: 'QR Transport',
    travelOffers: 'Mga Alok sa Paglalakbay',
    nearbyStores: 'Mga Kalapit na Tindahan',
    returnNormal: 'Bumalik sa Normal na Mode',
    offer1Title: '30% diskwento sa Taipei 101',
    offer1Sub: 'Limitadong alok para sa mga turista',
    offer2Title: 'Libreng MRT',
    offer2Sub: 'Unang biyahe libre!',
    store1: '7-Eleven Xinyi',
    store2: 'KFC Songshan',
    mAway: 'malayo',
  ),
};

/// Fixed currency conversion rates relative to 1 NTD
class CurrencyRates {
  static const double ntdToUsd = 1 / 31.54;   // 1 NTD = 0.0317 USD
  static const double ntdToEur = 1 / 36.92;   // 1 NTD = 0.0271 EUR
  static const double ntdToPhp = 1.94;         // 1 NTD = 1.94 PHP
  static const double ntdToIdr = 547.07;       // 1 NTD = 547.07 IDR
  static const double ntdToVnd = 835.41;       // 1 NTD = 835.41 VND
}
