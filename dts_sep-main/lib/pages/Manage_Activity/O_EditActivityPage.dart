import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/ActivityController.dart';
import '../../services/user_service.dart';
import '../../ui/common/daie_header.dart';

class O_EditActivity extends StatefulWidget {
  final String officerId;
  final String activityId;
  final Map<String, dynamic> existing;

  const O_EditActivity({
    super.key,
    required this.officerId,
    required this.activityId,
    required this.existing,
  });

  @override
  State<O_EditActivity> createState() => _O_EditActivityState();
}

class _O_EditActivityState extends State<O_EditActivity> {
  late final TextEditingController _title;
  late final TextEditingController _place;
  late final TextEditingController _desc;

  DateTime? _picked;

  String _search = "";
  String? _preacherId;
  String? _preacherName;

  @override
  void initState() {
    super.initState();

    _title = TextEditingController(text: (widget.existing['title'] ?? '').toString());
    _place = TextEditingController(text: (widget.existing['place'] ?? '').toString());
    _desc = TextEditingController(text: (widget.existing['description'] ?? '').toString());

    final rawDt = widget.existing['dateTime'];
    if (rawDt is Timestamp) {
      _picked = rawDt.toDate();
    }

    _preacherId = (widget.existing['preacherId'] ?? '').toString();
    _preacherName = (widget.existing['preacherName'] ?? '').toString();
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = UserService();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 320,
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),

              _field("Activity Name", _title),
              const SizedBox(height: 10),

              _field("Activity Place", _place),
              const SizedBox(height: 10),

              _dateTimePicker(),
              const SizedBox(height: 10),

              _field("Description", _desc, maxLines: 2),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Preacher",
                  style: TextStyle(color: Colors.black.withOpacity(.7), fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search preacher name...",
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 8),

              Container(
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: users.watchPreachers(),
                  builder: (context, snap) {
                    if (!snap.hasData) return const Center(child: CircularProgressIndicator());

                    final docs = snap.data!.docs;
                    final filtered = docs.where((d) {
                      final name = (d.data()['fullName'] ?? '').toString().toLowerCase();
                      return _search.isEmpty || name.contains(_search);
                    }).toList();

                    if (filtered.isEmpty) return const Center(child: Text("No preacher found"));

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final d = filtered[i];
                        final data = d.data();
                        final name = (data['fullName'] ?? '').toString();
                        final selected = d.id == _preacherId;

                        return ListTile(
                          dense: true,
                          title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          trailing: selected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                          onTap: () => setState(() {
                            _preacherId = d.id;
                            _preacherName = name;
                          }),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              InkWell(
                onTap: _submit,
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFE7F3),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(.25)),
                  ),
                  child: const Center(child: Text("Update", style: TextStyle(fontWeight: FontWeight.w800))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black.withOpacity(.7), fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          maxLines: maxLines,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }

  Widget _dateTimePicker() {
    final text = _picked == null
        ? ""
        : "${DateFormat('d/M/yyyy').format(_picked!)}  ${DateFormat('h:mm a').format(_picked!)}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date & Time", style: TextStyle(color: Colors.black.withOpacity(.7), fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickDateTime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(text.isEmpty ? "Select date & time" : text),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _picked ?? now,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_picked ?? now),
    );
    if (time == null) return;

    setState(() {
      _picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty ||
        _place.text.trim().isEmpty ||
        _picked == null ||
        (_preacherId == null || _preacherId!.isEmpty) ||
        (_preacherName == null || _preacherName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    final ctrl = context.read<ActivityController>();
    await ctrl.updateActivity(
      widget.activityId,
      title: _title.text,
      description: _desc.text,
      place: _place.text,
      dateTime: _picked!,
      preacherId: _preacherId!,
      preacherName: _preacherName!,
    );

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, size: 72, color: Colors.green),
            SizedBox(height: 10),
            Text(
              "Activity\nUpdated!!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );

    if (mounted) Navigator.pop(context);
  }
}
