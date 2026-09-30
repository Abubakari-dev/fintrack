// lib/features/wallet/models/wallet.dart

import 'package:fintrack/core/constants/db_constants.dart';

class Wallet {
  final int? id;
  final String name;
  final String type;
  final double balance;
  final String icon;
  final int color;

  Wallet({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colWalletName: name,
      DbConstants.colWalletType: type,
      DbConstants.colWalletBalance: balance,
      DbConstants.colWalletIcon: icon,
      DbConstants.colWalletColor: color,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map[DbConstants.colId] as int?,
      name: map[DbConstants.colWalletName] as String? ?? '',
      type: map[DbConstants.colWalletType] as String? ?? 'cash',
      balance: (map[DbConstants.colWalletBalance] as num?)?.toDouble() ?? 0.0,
      icon: map[DbConstants.colWalletIcon] as String? ?? 'payments',
      color: map[DbConstants.colWalletColor] as int? ?? 0xFF16A34A,
    );
  }

  Wallet copyWith({
    int? id,
    String? name,
    String? type,
    double? balance,
    String? icon,
    int? color,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
