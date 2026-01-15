import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/KpiController.dart';
import '../../services/user_service.dart';
import '../../ui/common/daie_header.dart';

class O_AddKpiPage extends StatefulWidget {
  final String officerId; // ✅ fixed name
  const O_AddKpiPage({super.key, required this.officerId});

  @override
  State<O_AddKpiPage> createState() => _O_AddKpiState();
}

class _O_AddKpiState extends State<O_AddKpiPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _target = TextEditingController();
  final _actual = TextEditingController();

  String? _year;
  String? _preacherId;
  String? _preacherName;
  String _status = "Pending";

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _target.dispose();
    _actual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = UserService();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 330,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFD8ECF7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "KPI Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 14),

                _label("KPI Title"),
                _input(_title, "Enter KPI title"),

                _label("Description"),
                _input(_desc, "Write description here", maxLines: 3),

                _label("Year"),
                _dropdown(
                  value: _year,
                  hint: "Select year",
                  items: List.generate(
                    6,
                    (i) => (DateTime.now().year - 2 + i).toString(),
                  ),
                  onChanged: (v) => setState(() => _year = v),
                ),

                _label("Assigned Preacher"),
                StreamBuilder(
                  stream: users.watchPreachers(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final docs = (snap.data as dynamic).docs;

                    return _dropdown(
                      value: _preacherId,
                      hint: "Select preacher",
                      items: docs.map<String>((d) => d.id).toList(),
                      labelBuilder: (id) {
                        final doc = docs.firstWhere((e) => e.id == id);
                        return (doc['fullName'] ?? '-').toString();
                      },
                      onChanged: (v) {
                        if (v == null) return;
                        final doc = docs.firstWhere((e) => e.id == v);
                        setState(() {
                          _preacherId = v;
                          _preacherName = (doc['fullName'] ?? '').toString();
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _label("Target KPI"),
                          _circleInput(_target),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _label("Actual KPI"),
                          _circleInput(_actual),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _label("Status KPI"),
                _readOnlyBox(_status),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionButton("Back", () => Navigator.pop(context)),
                    _actionButton("Save", _submit),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  Widget _input(TextEditingController c, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _readOnlyBox(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    String Function(String)? labelBuilder,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        hint: Text(hint),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(labelBuilder != null ? labelBuilder(e) : e),
              ),
            )
            .toList(),
        onChanged: (v) => onChanged(v),
      ),
    );
  }

  Widget _circleInput(TextEditingController c) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE7E7E7),
      ),
      child: TextField(
        controller: c,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (_) => _updateStatus(),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }

  // ================= LOGIC =================

  void _updateStatus() {
    final t = int.tryParse(_target.text) ?? 0;
    final a = int.tryParse(_actual.text) ?? 0;

    setState(() {
      _status = (a >= t && t > 0) ? "Achieved" : "Pending";
    });
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty ||
        _year == null ||
        _preacherId == null ||
        _preacherName == null ||
        _target.text.trim().isEmpty) {
      _toast("Please complete all required fields");
      return;
    }

    final target = int.tryParse(_target.text.trim());
    final actual = int.tryParse(_actual.text.trim()) ?? 0;

    if (target == null || target <= 0) {
      _toast("Target KPI must be a valid number (> 0)");
      return;
    }

    final ctrl = context.read<KpiController>();
    await ctrl.addKpi(
      officerId: widget.officerId,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      year: _year!,
      target: target,
      actual: actual,
      status: _status,
      preacherId: _preacherId!,
      preacherName: _preacherName!,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
