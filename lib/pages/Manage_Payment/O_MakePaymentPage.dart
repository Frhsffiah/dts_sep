import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../provider/PaymentController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';

class OMakePaymentPage extends StatefulWidget {
  final String preacherId;
  final String preacherName;

  const OMakePaymentPage({
    super.key,
    required this.preacherId,
    required this.preacherName,
  });

  @override
  State<OMakePaymentPage> createState() => _OMakePaymentPageState();
}

class _OMakePaymentPageState extends State<OMakePaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedActivityId;
  String? selectedActivityTitle;

  String paymentType = "Fund Transfer";
  String bank = "Maybank";

  final TextEditingController accountCtrl = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> activities = [];
  bool loadingActivities = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final paymentCtrl =
        Provider.of<PaymentController>(context, listen: false);

    final result =
        await paymentCtrl.getActivitiesByPreacher(widget.preacherId);

    setState(() {
      activities = result;
      loadingActivities = false;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() ||
        selectedActivityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final paymentCtrl = context.read<PaymentController>();

    final success = await paymentCtrl.makePayment(
      preacherId: widget.preacherId,
      activityId: selectedActivityId!,
      activityTitle: selectedActivityTitle!,
      amount: double.parse(amountCtrl.text),
      paymentType: paymentType,
      bank: bank,
      accountNumber: accountCtrl.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentCtrl.error ?? "Payment failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentCtrl = context.watch<PaymentController>();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Center(
                child: Text(
                  "Payment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              //Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                ),
              ),
              const SizedBox(height: 12), 

              /// Preacher name
              TextFormField(
                initialValue: widget.preacherName,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              /// Activity dropdown / message
              if (loadingActivities)
                const Center(child: CircularProgressIndicator())
              else if (activities.isEmpty)
                const Text(
                  "No activities found",
                  style: TextStyle(color: Colors.red),
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Activity",
                    border: OutlineInputBorder(),
                  ),
                  items: activities.map((doc) {
                    final data = doc.data();
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(data['title'] ?? "-"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final doc =
                        activities.firstWhere((e) => e.id == value);
                    setState(() {
                      selectedActivityId = value;
                      selectedActivityTitle =
                          doc.data()['title'] ?? "";
                    });
                  },
                  validator: (v) =>
                      v == null ? "Please select an activity" : null,
                ),
              const SizedBox(height: 12),

              /// Transfer type
              DropdownButtonFormField<String>(
                value: paymentType,
                decoration: const InputDecoration(
                  labelText: "Transfer Type",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Fund Transfer",
                      child: Text("Fund Transfer")),
                  DropdownMenuItem(value: "Cash", child: Text("Cash")),
                ],
                onChanged: (v) => setState(() => paymentType = v!),
              ),
              const SizedBox(height: 12),

              /// Bank
              DropdownButtonFormField<String>(
                value: bank,
                decoration: const InputDecoration(
                  labelText: "Bank / Wallet",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Maybank", child: Text("Maybank")),
                  DropdownMenuItem(value: "CIMB", child: Text("CIMB")),
                  DropdownMenuItem(
                      value: "Bank Islam", child: Text("Bank Islam")),
                ],
                onChanged: (v) => setState(() => bank = v!),
              ),
              const SizedBox(height: 12),

              /// Account number
              TextFormField(
                controller: accountCtrl,
                decoration: const InputDecoration(
                  labelText: "Account Number",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              /// Amount
              TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount (RM)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: paymentCtrl.loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: paymentCtrl.loading
                    ? const CircularProgressIndicator()
                    : const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: OfficerNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pop(context);
        },
      ),
    );
  }
}
