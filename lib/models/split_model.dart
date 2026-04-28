class Participant {
  final String id;
  String name;
  double amount;
  bool hasPaid;
  String avatarEmoji;

  Participant({
    required this.id,
    required this.name,
    this.amount = 0.0,
    this.hasPaid = false,
    this.avatarEmoji = '🙂',
  });
}

/// Dummy contact suggestions
final List<Participant> dummyContacts = [
  Participant(id: 'c1', name: 'Alice', avatarEmoji: '👩'),
  Participant(id: 'c2', name: 'Bob', avatarEmoji: '👨'),
  Participant(id: 'c3', name: 'Carol', avatarEmoji: '👩‍🦰'),
  Participant(id: 'c4', name: 'David', avatarEmoji: '🧔'),
  Participant(id: 'c5', name: 'Emma', avatarEmoji: '👱‍♀️'),
  Participant(id: 'c6', name: 'Frank', avatarEmoji: '🧑'),
  Participant(id: 'c7', name: 'Grace', avatarEmoji: '👩‍🦱'),
  Participant(id: 'c8', name: 'Henry', avatarEmoji: '🧑‍🦱'),
];
