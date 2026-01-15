import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../ui/common/daie_header.dart';

class O_ApproveReportPage extends StatefulWidget {
  final String officerId;
  const O_ApproveReportPage({super.key, required this.officerId});

  @override
  State<O_ApproveReportPage> createState() => _O_ApproveReportPageState();
}

class _O_ApproveReportPageState extends State<O_ApproveReportPage> {
  String _search = "";
  String _filter = "Pending"; // Pending / Approved / Rejected / All

  @override
  Widget build(BuildContext context) {
    final reportsRef = FirebaseFirestore.instance.collection('reports');

    Query<Map<String, dynamic>> q = reportsRef;
    if (_filter != "All") {
      q = q.where('status', isEqualTo: _filter);
    }

    // If you do NOT have createdAt in your reports, change to: q.snapshots()
    final stream = q.orderBy('createdAt', descending: true).snapshots();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 370,
          margin: const EdgeInsets.only(top: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFD8ECF7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Approve Report",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),

              // Search
              TextField(
                decoration: InputDecoration(
                  hintText: "Search report title...",
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white.withOpacity(.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 10),

              // Filter chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip("Pending"),
                  _chip("Approved"),
                  _chip("Rejected"),
                  _chip("All"),
                ],
              ),

              const SizedBox(height: 12),

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: stream,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snap.hasData) {
                      return const Center(child: Text("No data"));
                    }

                    final docs = snap.data!.docs;

                    final filtered = docs.where((d) {
                      final data = d.data();
                      final title = _readStr(data, ['title', 'reportTitle']).toLowerCase();
                      return _search.isEmpty || title.contains(_search);
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text("No reports found"));
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final doc = filtered[i];
                        final data = doc.data();

                        final title = _readStr(data, ['title', 'reportTitle']);
                        final date = _readStr(data, ['date', 'year']);
                        final status = _readStr(data, ['status']).isEmpty ? "Pending" : _readStr(data, ['status']);

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openDetailSheet(reportId: doc.id, data: data),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.55),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE7E7E7),
                                  ),
                                  child: const Icon(Icons.assignment_turned_in_outlined),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title.isEmpty ? "-" : title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        date.isEmpty ? "-" : date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(.65),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _statusPill(status),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _pillButton("Back", () => Navigator.pop(context)),
                  _pillButton("Close", () => Navigator.pop(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== Detail Sheet =====================

  Future<void> _openDetailSheet({
    required String reportId,
    required Map<String, dynamic> data,
  }) async {
    final title = _readStr(data, ['title', 'reportTitle']);
    final date = _readStr(data, ['date', 'year']);
    final desc = _readStr(data, ['description']);
    final participants = _readAnyToStr(data, ['participants', 'numberOfParticipants']);
    final evidence = _readStr(data, ['evidence']);
    final status = _readStr(data, ['status']).isEmpty ? "Pending" : _readStr(data, ['status']);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text("Report Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    ),
                    _statusPill(status),
                  ],
                ),
                const SizedBox(height: 12),

                _label("Report Title"),
                _box(title),

                const SizedBox(height: 10),
                _label("Date"),
                _box(date),

                const SizedBox(height: 10),
                _label("Description"),
                _box(desc, minHeight: 90),

                const SizedBox(height: 10),
                _label("Number of participants"),
                _box(participants),

                const SizedBox(height: 10),
                _label("Evidence"),
                _box(evidence, minHeight: 55),

                const SizedBox(height: 16),

                // Actions (only show if still pending)
                if (status == "Pending") ...[
                  Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          text: "Reject",
                          bg: const Color(0xFFFFE5E5),
                          onTap: () => _confirmAndUpdate(
                            reportId: reportId,
                            newStatus: "Rejected",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionBtn(
                          text: "Approve",
                          bg: const Color(0xFFE2F7E6),
                          onTap: () => _confirmAndUpdate(
                            reportId: reportId,
                            newStatus: "Approved",
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  _hint("This report is already $status."),
                ],

                const SizedBox(height: 10),
                Center(child: _pillButton("Close", () => Navigator.pop(context))),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmAndUpdate({
    required String reportId,
    required String newStatus,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(newStatus == "Approved" ? "Approve report?" : "Reject report?"),
        content: Text(
          newStatus == "Approved"
              ? "This will mark the report as Approved."
              : "This will mark the report as Rejected.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
        ],
      ),
    );

    if (ok != true) return;

    await FirebaseFirestore.instance.collection('reports').doc(reportId).update({
      'status': newStatus,
      'reviewedByOfficerId': widget.officerId,
      'reviewedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    Navigator.pop(context); // close bottom sheet
    _toast("Report $newStatus");
  }

  // ===================== UI helpers =====================

  Widget _chip(String label) {
    final selected = _filter == label;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black.withOpacity(.8))),
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg;
    if (status == "Approved") {
      bg = Colors.green;
    } else if (status == "Rejected") {
      bg = Colors.red;
    } else {
      bg = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }

  Widget _box(String value, {double? minHeight}) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value.isEmpty ? "-" : value,
        style: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: Colors.black.withOpacity(.75),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _pillButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE7E7E7),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _actionBtn({
    required String text,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _hint(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===================== Field helpers =====================

  String _readStr(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k];
      if (v != null) return v.toString();
    }
    return "";
  }

  String _readAnyToStr(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k];
      if (v == null) continue;
      return v.toString();
    }
    return "";
  }
}
