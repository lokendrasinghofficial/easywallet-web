import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/app_state.dart';
import '../models/app_mode.dart';
import '../utils/tourist_translations.dart';
import 'qr_scanner_screen.dart';

class TouristHomeScreen extends StatelessWidget {
  const TouristHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final lang = appProvider.touristLang;
    final s = touristTranslations[lang]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: appProvider.getText('Change Mode', '切換模式'),
            onPressed: () => appProvider.setAppMode(AppMode.normal),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Language Selector ──────────────────────────────
            _buildSectionTitle(context, s.language),
            _buildLanguageRow(context, appProvider, lang),
            const SizedBox(height: 28),

            // ── Currency Helper ────────────────────────────────
            _buildSectionTitle(context, s.currencyHelper),
            _buildCurrencyCard(context),
            const SizedBox(height: 28),

            // ── Quick Actions ──────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildSquareAction(
                    context,
                    Icons.qr_code_scanner,
                    s.scanAndPay,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSquareAction(
                    context,
                    Icons.train,
                    s.transportQr,
                    Colors.green,
                    () => _showTransportQr(context, s),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Travel Offers ──────────────────────────────────
            _buildSectionTitle(context, s.travelOffers),
            _buildOfferCard(context, s.offer1Title, s.offer1Sub, Icons.confirmation_num),
            const SizedBox(height: 12),
            _buildOfferCard(context, s.offer2Title, s.offer2Sub, Icons.directions_subway),
            const SizedBox(height: 28),

            // ── Nearby Stores ──────────────────────────────────
            _buildSectionTitle(context, s.nearbyStores),
            _buildStoreItem(context, s.store1, '200m ${s.mAway}', Icons.store),
            _buildStoreItem(context, s.store2, '450m ${s.mAway}', Icons.restaurant),

            const SizedBox(height: 28),

            // ── Return Button ──────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => appProvider.setAppMode(AppMode.normal),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(s.returnNormal),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showTransportQr(BuildContext context, TouristStrings s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) => _TransportQrSheet(s: s),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLanguageRow(BuildContext context, AppProvider appProvider, TouristLang selected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TouristLang.values.map((lang) {
          final isSelected = selected == lang;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: InkWell(
                onTap: () => appProvider.setTouristLang(lang),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withValues(alpha: 0.35),
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        lang.label,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : null,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context) {
    final rates = [
      _CurrencyRate('100 NTD', '≈ ${(100 * CurrencyRates.ntdToUsd).toStringAsFixed(2)} USD', '🇺🇸'),
      _CurrencyRate('100 NTD', '≈ ${(100 * CurrencyRates.ntdToEur).toStringAsFixed(2)} EUR', '🇪🇺'),
      _CurrencyRate('100 NTD', '≈ ${_formatNumber((100 * CurrencyRates.ntdToPhp).round())} PHP', '🇵🇭'),
      _CurrencyRate('100 NTD', '≈ ${_formatNumber((100 * CurrencyRates.ntdToIdr).round())} IDR', '🇮🇩'),
      _CurrencyRate('100 NTD', '≈ ${_formatNumber((100 * CurrencyRates.ntdToVnd).round())} VND', '🇻🇳'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: rates.asMap().entries.map((entry) {
          final i = entry.key;
          final rate = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Text(rate.flag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(rate.from, style: const TextStyle(fontSize: 15, color: Colors.grey)),
                    const Spacer(),
                    Text(
                      rate.to,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < rates.length - 1) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatNumber(int n) {
    // Insert commas every 3 digits
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  Widget _buildSquareAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withValues(alpha: 0.15),
          child: Icon(icon, color: Colors.orange, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, String name, String dist, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.blue, size: 20),
      ),
      title: Text(name),
      subtitle: Text(dist),
      trailing: const Icon(Icons.directions, color: Colors.blue),
    );
  }
}

class _CurrencyRate {
  final String from;
  final String to;
  final String flag;
  const _CurrencyRate(this.from, this.to, this.flag);
}

// ── Transport QR Bottom Sheet ─────────────────────────────────────────────────

class _TransportQrSheet extends StatefulWidget {
  final TouristStrings s;
  const _TransportQrSheet({required this.s});

  @override
  State<_TransportQrSheet> createState() => _TransportQrSheetState();
}

class _TransportQrSheetState extends State<_TransportQrSheet> {
  // Dummy EasyCard QR data — would be a real token in production
  static const String _dummyQrData =
      'EASYCARD:TW:2025-001:4EBF2A91C3D7:TRANSPORT:UNLIMITED';

  int _secondsLeft = 60;
  late final Stream<int> _countdown;

  @override
  void initState() {
    super.initState();
    _countdown = Stream.periodic(
      const Duration(seconds: 1),
      (i) => 59 - i,
    ).take(60);
    _countdown.listen((s) {
      if (mounted) setState(() => _secondsLeft = s);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool expiring = _secondsLeft <= 10;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.train, color: Colors.green, size: 22),
              const SizedBox(width: 8),
              Text(
                widget.s.transportQr,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'EasyCard · 悠遊卡',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // QR code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: expiring ? Colors.red.withValues(alpha: 0.6) : Colors.green.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (expiring ? Colors.red : Colors.green).withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: QrImageView(
              data: _dummyQrData,
              version: QrVersions.auto,
              size: 220,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: expiring ? Colors.red : Colors.green[800],
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: expiring ? Colors.red : Colors.green[800],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Countdown
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: expiring
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  expiring ? Icons.warning_amber_rounded : Icons.timer_outlined,
                  color: expiring ? Colors.red : Colors.green[700],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  expiring
                      ? (context.read<AppProvider>().language == '中文' ? '即將在 $_secondsLeft 秒後過期' : 'Expiring in $_secondsLeft s')
                      : (context.read<AppProvider>().language == '中文' ? '有效期剩餘 $_secondsLeft 秒' : 'Valid for $_secondsLeft s'),
                  style: TextStyle(
                    color: expiring ? Colors.red : Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.read<AppProvider>().getText(
              'Show this QR at any MRT / Bus gate', 
              '請在捷運或公車閘門出示此條碼'
            ),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
