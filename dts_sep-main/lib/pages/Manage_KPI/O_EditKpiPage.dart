import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/KpiController.dart';
import '../../ui/common/daie_header.dart';

class O_EditKpiPage extends StatefulWidget {
  final String kpiId;
  final Map<String, dynamic> kpiData;

  const O_EditKpiPage({
    super.key,
    required this.kpiId,
    required this.kpiData,
  });

  @override
  State<O_EditKpiPage> createState() => _O_EditKpiPageState();
}

class _O_EditKpiPageState extends State<O_EditKpiPage> {
  late TextEditingController _actual;
  late String _status;

  @override
  void initState() {
    super.initState();
    _actual = TextEditingController(
      text: widget.kpiData['actual'].toString(),
    );
    _status = widget.kpiData['status'];
  }

  @override
  void dispose() {
    _actual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.kpiData;

    return Scaffold(
      appBar: const DaieHeader(),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info("KPI Title", data['title']),
            _info("Year", data['year']),
            _info("Preacher", data['preacherName']),
            _info("Target KPI", data['target'].toString()),

            const SizedBox(height: 14),

            const Text(
              "Actual KPI",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _actual,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _updateStatus,
            ),

            const SizedBox(height: 12),

            _info("Status", _status),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  void _updateStatus(String v) {
    final target = widget.kpiData['target'] as int;
    final actual = int.tryParse(v) ?? 0;

    setState(() {
      _status = actual >= target ? "Achieved" : "Pending";
    });
  }

  Future<void> _save() async {
    final actual = int.tryParse(_actual.text);
    if (actual == null) {
      _toast("Invalid number");
      return;
    }

    final ctrl = context.read<KpiController>();
    await ctrl.updateKpi(
      kpiId: widget.kpiId,
      actual: actual,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
