import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/app_mode.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  top: 32.0,
                  bottom: 24.0,
                ),
                child: Text(
                  appProvider.getText("Other Services", "其他服務"),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.black87,
                  ),
                ),
              ),

              // Top Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTopAction(
                      context,
                      Icons.favorite,
                      appProvider.getText("Favorites", "優惠收藏"),
                      Colors.pinkAccent,
                    ),
                    _buildTopAction(
                      context,
                      Icons.receipt,
                      appProvider.getText("Invoice Lottery", "發票對獎"),
                      Colors.orangeAccent,
                    ),
                    _buildTopAction(
                      context,
                      Icons.volunteer_activism,
                      appProvider.getText("Charity Code", "愛心碼"),
                      Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Section 1: Customer Service
              Container(
                color: Theme.of(context).cardColor,
                child: _buildListTile(
                  context,
                  Icons.support_agent,
                  appProvider.getText("Customer Service", "客戶服務"),
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Settings & Tools
              Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      leading: Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).iconTheme.color,
                        size: 28,
                      ),
                      title: Text(
                        appProvider.getText("Dark Mode", "深色模式"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Switch(
                        value: appProvider.isDarkMode,
                        onChanged: (val) => appProvider.toggleDarkMode(val),
                        activeThumbColor: Colors.blueAccent,
                      ),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildListTile(
                      context,
                      Icons.notifications_active_outlined,
                      appProvider.getText("Auto Reload Settings", "自動加值通知設定"),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildListTile(
                      context,
                      Icons.currency_exchange,
                      appProvider.getText("Exchange Rates", "匯率查詢"),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      leading: Icon(
                        Icons.language,
                        color: Theme.of(context).iconTheme.color,
                        size: 28,
                      ),
                      title: Text(
                        appProvider.getText("Language", "語言"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        appProvider.language == "EN" ? "English" : "中文",
                      ),
                      trailing: const Icon(Icons.arrow_drop_down, size: 24),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (sheetCtx) => _buildLanguageSheet(sheetCtx, appProvider),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      leading: Icon(
                        Icons.psychology,
                        color: Theme.of(context).iconTheme.color,
                        size: 28,
                      ),
                      title: Text(
                        appProvider.getText("App Mode", "應用模式"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        appProvider.currentMode.name.toUpperCase(),
                      ),
                      trailing: const Icon(Icons.arrow_drop_down, size: 24),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (sheetCtx) => _buildAppModeSheet(sheetCtx, appProvider),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildListTile(
                      context,
                      Icons.shield_outlined,
                      appProvider.getText("Anti-Fraud Dashboard", "打詐儀錶板"),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildListTile(
                      context,
                      Icons.menu_book,
                      appProvider.getText("User Guide", "使用教學"),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildListTile(
                      context,
                      Icons.format_list_bulleted,
                      appProvider.getText("Terms & Conditions", "使用條款"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: App Info
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).iconTheme.color,
                    size: 28,
                  ),
                  title: Text(
                    appProvider.getText("Check for Updates", "版本更新檢查"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    appProvider.getText(
                      "Current Version 3.1.33_release_835",
                      "目前版本 3.1.33_release_835",
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 48), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopAction(
    BuildContext context,
    IconData icon,
    String label,
    Color iconColor,
  ) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: Theme.of(context).iconTheme.color, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        debugPrint("Tapped on \$title");
      },
    );
  }

  Widget _buildAppModeSheet(BuildContext context, AppProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
          Text(
            appProvider.getText("Select App Mode", "選擇應用模式"),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            appProvider.getText("Choose the experience that suits you best", "選擇最適合您的使用體驗"),
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          _buildModeOption(context, appProvider, AppMode.normal,
            icon: Icons.dashboard_rounded,
            emoji: "🧠",
            title: appProvider.getText("Normal Mode", "標準模式"),
            subtitle: appProvider.getText("Full features & complete navigation", "完整功能與全面導覽"),
            gradient: [const Color(0xFF2196F3), const Color(0xFF1565C0)],
          ),
          const SizedBox(height: 12),
          _buildModeOption(context, appProvider, AppMode.tourist,
            icon: Icons.travel_explore,
            emoji: "🌍",
            title: appProvider.getText("Tourist Mode", "遊客模式"),
            subtitle: appProvider.getText("Currency helper, transport QR & travel tools", "匯率查詢、交通乘車及旅遊工具"),
            gradient: [const Color(0xFF26A69A), const Color(0xFF00695C)],
          ),
          const SizedBox(height: 12),
          _buildModeOption(context, appProvider, AppMode.simple,
            icon: Icons.accessibility_new_rounded,
            emoji: "👴",
            title: appProvider.getText("Simple Mode", "簡易模式"),
            subtitle: appProvider.getText("Large text, minimal layout, easy access", "大字體、簡潔佈局、操作簡單"),
            gradient: [const Color(0xFFFF7043), const Color(0xFFBF360C)],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context,
    AppProvider appProvider,
    AppMode mode, {
    required IconData icon,
    required String emoji,
    required String title,
    required String subtitle,
    required List<Color> gradient,
  }) {
    final isSelected = appProvider.currentMode == mode;

    return GestureDetector(
      onTap: () {
        appProvider.setAppMode(mode);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isSelected
              ? LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            // Icon bubble
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : gradient[0].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            // Check badge
            if (isSelected)
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              )
            else
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSheet(BuildContext context, AppProvider appProvider) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            appProvider.getText("Select Language", "選擇語言"),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text("🇬🇧", style: TextStyle(fontSize: 24)),
            title: const Text("English"),
            trailing: appProvider.language == "EN"
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              appProvider.setLanguage("EN");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Text("🇹🇼", style: TextStyle(fontSize: 24)),
            title: const Text("中文"),
            trailing: appProvider.language == "中文"
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              appProvider.setLanguage("中文");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
