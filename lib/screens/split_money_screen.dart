import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/split_model.dart';
import '../widgets/participant_card.dart';

class SplitMoneyScreen extends StatefulWidget {
  final String? prefillAmount;
  const SplitMoneyScreen({super.key, this.prefillAmount});

  @override
  State<SplitMoneyScreen> createState() => _SplitMoneyScreenState();
}

class _SplitMoneyScreenState extends State<SplitMoneyScreen>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  final List<Participant> _participants = [];
  bool _customMode = false;
  bool _requestSent = false;
  late AnimationController _successAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    if (widget.prefillAmount != null) {
      _amountController.text = widget.prefillAmount!;
    }
    _successAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _successAnim, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _successAnim.dispose();
    super.dispose();
  }

  double get _totalAmount => double.tryParse(_amountController.text) ?? 0;
  double get _equalShare =>
      _participants.isEmpty ? 0 : _totalAmount / _participants.length;

  void _redistributeEqually() {
    if (_participants.isEmpty) return;
    final share = _equalShare;
    for (final p in _participants) {
      p.amount = share;
    }
  }

  void _addParticipant(Participant p) {
    setState(() {
      _participants.add(p);
      if (!_customMode) _redistributeEqually();
    });
  }

  void _removeParticipant(String id) {
    setState(() {
      _participants.removeWhere((p) => p.id == id);
      if (!_customMode) _redistributeEqually();
    });
  }

  void _togglePaid(String id) {
    setState(() {
      final p = _participants.firstWhere((p) => p.id == id);
      p.hasPaid = !p.hasPaid;
    });
  }

  void _sendRequests() {
    setState(() => _requestSent = true);
    _successAnim.forward();
  }

  void _showAddPeopleSheet(AppProvider appProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _AddPeopleSheet(
        existing: _participants.map((p) => p.id).toSet(),
        onAdd: _addParticipant,
        appProvider: appProvider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final paidCount = _participants.where((p) => p.hasPaid).length;
    final pendingCount = _participants.length - paidCount;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          appProvider.getText('Split Money', '分帳'), 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Total Amount ─────────────────────────────────────
            _sectionLabel(appProvider.getText('Total Bill Amount', '總帳單金額')),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: 'NT\$ ',
                  prefixStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  border: InputBorder.none,
                  hintText: '0',
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onChanged: (_) {
                  if (!_customMode) setState(() => _redistributeEqually());
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Split Mode ────────────────────────────────────────
            _sectionLabel(appProvider.getText('Split Mode', '分帳方式')),
            Row(
              children: [
                _modeChip(appProvider.getText('Equal Split', '平均分攤'), !_customMode, () {
                  setState(() {
                    _customMode = false;
                    _redistributeEqually();
                  });
                }),
                const SizedBox(width: 12),
                _modeChip(appProvider.getText('Custom Split', '個別設定'), _customMode, () {
                  setState(() => _customMode = true);
                }),
              ],
            ),
            const SizedBox(height: 24),

            // ── Participants ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionLabel('${appProvider.getText('Participants', '參與成員')} (${_participants.length})'),
                TextButton.icon(
                  onPressed: () => _showAddPeopleSheet(appProvider),
                  icon: const Icon(Icons.person_add, size: 18),
                  label: Text(appProvider.getText('Add People', '新增成員')),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
              ],
            ),
            if (_participants.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.group_add, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      appProvider.getText('Tap "Add People" to get started', '點擊"新增成員"開始分帳'),
                      style: TextStyle(color: Colors.grey[500])
                    ),
                  ],
                ),
              )
            else
              ...(_participants.map((p) => ParticipantCard(
                    participant: p,
                    customMode: _customMode,
                    onRemove: () => _removeParticipant(p.id),
                    onTogglePaid: () => _togglePaid(p.id),
                    onAmountChanged: _customMode
                        ? (val) => setState(() => p.amount = val)
                        : null,
                  ))),

            // ── Summary ───────────────────────────────────────────
            if (_participants.isNotEmpty) ...[
              const SizedBox(height: 24),
              _sectionLabel(appProvider.getText('Summary', '分帳摘要')),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _summaryRow(appProvider.getText('Total Bill', '總金額'), 'NT\$ ${_totalAmount.toStringAsFixed(0)}', Colors.white),
                    const Divider(color: Colors.white24, height: 20),
                    _summaryRow(appProvider.getText('Per Person (equal)', '每人應付 (平均)'), 'NT\$ ${_equalShare.toStringAsFixed(1)}', Colors.white70),
                    _summaryRow(appProvider.getText('Participants', '參與成員'), '${_participants.length} ${appProvider.getText('people', '人')}', Colors.white70),
                    const Divider(color: Colors.white24, height: 20),
                    _summaryRow('✅ ${appProvider.getText('Paid', '已付')}', '$paidCount ${appProvider.getText('people', '人')}', Colors.greenAccent),
                    _summaryRow('⏳ ${appProvider.getText('Pending', '待付')}', '$pendingCount ${appProvider.getText('people', '人')}', Colors.orangeAccent),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Request / Success ─────────────────────────────
              if (!_requestSent)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _participants.isNotEmpty && _totalAmount > 0
                        ? _sendRequests
                        : null,
                    icon: const Icon(Icons.send),
                    label: Text(appProvider.getText('Request Money', '向好友收款'), style: const TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                )
              else
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          appProvider.getText('Requests sent successfully! 🎉', '收款請求已成功送出！🎉'),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appProvider.getText(
                            'Tap a participant\'s avatar to mark as paid', 
                            '點擊成員頭像可標記為已支付'
                          ),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
      );

  Widget _modeChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.blue[700] : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.blue[700]! : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : null,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// ── Add People Sheet ──────────────────────────────────────────────────────────

class _AddPeopleSheet extends StatefulWidget {
  final Set<String> existing;
  final ValueChanged<Participant> onAdd;
  final AppProvider appProvider;

  const _AddPeopleSheet({required this.existing, required this.onAdd, required this.appProvider});

  @override
  State<_AddPeopleSheet> createState() => _AddPeopleSheetState();
}

class _AddPeopleSheetState extends State<_AddPeopleSheet> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addManual() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(Participant(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      avatarEmoji: '🙂',
    ));
    _nameController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final available = dummyContacts.where((c) => !widget.existing.contains(c.id)).toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.appProvider.getText('Add People', '新增成員'), 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),

          // Manual name entry
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: widget.appProvider.getText('Enter name manually', '手動輸入姓名'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _addManual(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addManual,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            widget.appProvider.getText('Suggested Contacts', '建議聯絡人'),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)
          ),
          const SizedBox(height: 10),

          if (available.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                widget.appProvider.getText('All contacts added', '所有聯絡人已加入'), 
                style: const TextStyle(color: Colors.grey)
              ),
            )
          else
            ...available.map((c) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: Text(c.avatarEmoji, style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: IconButton(
                    icon: const Icon(Icons.person_add, color: Colors.blue),
                    onPressed: () {
                      widget.onAdd(Participant(
                        id: c.id,
                        name: c.name,
                        avatarEmoji: c.avatarEmoji,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                )),
        ],
      ),
    );
  }
}
