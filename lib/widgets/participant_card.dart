import 'package:flutter/material.dart';
import '../models/split_model.dart';

class ParticipantCard extends StatelessWidget {
  final Participant participant;
  final bool customMode;
  final VoidCallback? onRemove;
  final ValueChanged<double>? onAmountChanged;
  final VoidCallback? onTogglePaid;

  const ParticipantCard({
    super.key,
    required this.participant,
    this.customMode = false,
    this.onRemove,
    this.onAmountChanged,
    this.onTogglePaid,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = participant.hasPaid;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isPaid
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: GestureDetector(
          onTap: onTogglePaid,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: isPaid
                ? Colors.green.withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.1),
            child: Text(participant.avatarEmoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          participant.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: GestureDetector(
          onTap: onTogglePaid,
          child: Row(
            children: [
              Icon(
                isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 14,
                color: isPaid ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                isPaid ? 'Paid' : 'Pending',
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customMode && onAmountChanged != null)
              SizedBox(
                width: 80,
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                  decoration: InputDecoration(
                    prefixText: 'NT\$ ',
                    prefixStyle: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                    border: InputBorder.none,
                    hintText: participant.amount.toStringAsFixed(0),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null) onAmountChanged!(parsed);
                  },
                ),
              )
            else
              Text(
                'NT\$ ${participant.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            const SizedBox(width: 8),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
