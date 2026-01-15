import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/Payment/PaymentModel.dart';
import '../../ui/common/daie_header.dart';

class P_PaymentReceiptPage extends StatelessWidget {
  final PaymentModel payment;

  const P_PaymentReceiptPage({super.key, required this.payment});

  Color get bankColor {
    switch (payment.bank.toLowerCase()) {
      case 'maybank':
        return Colors.yellow.shade700;
      case 'cimb':
        return Colors.red.shade700;
      case 'bank islam':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String get bankLogo {
    switch (payment.bank.toLowerCase()) {
      case 'maybank':
        return 'assets/banks/maybank.png';
      case 'cimb':
        return 'assets/banks/cimb.png';
      case 'bank islam':
        return 'assets/banks/bank_islam.png';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a')
        .format(payment.createdAt.toDate());

    return Scaffold(
      appBar: const DaieHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// BANK HEADER
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: bankColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      if (bankLogo.isNotEmpty)
                        Image.asset(bankLogo, height: 40),
                      const SizedBox(height: 6),
                      const Text(
                        "Transaction Receipt",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _row("Activity", payment.activityTitle),
                _row("Amount", "RM ${payment.amount.toStringAsFixed(2)}"),
                _row("Payment Type", payment.paymentType),
                _row("Bank", payment.bank),
                _row("Status", payment.status),
                _row("Date", dateStr),

                const Divider(height: 30),

                const Text(
                  "This is a system-generated receipt\nfor record purposes only.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download Receipt"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bankColor,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("PDF download feature (future enhancement)"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
