import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../../provider/ActivityController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/officer_nav.dart';
import 'O_AddActivityPage.dart';
import 'O_EditActivityPage.dart';

class O_ActivityList extends StatelessWidget {
  final String officerId;
  const O_ActivityList({super.key, required this.officerId});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ActivityController>();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Activity List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const Spacer(),
                _circleButton(
                  icon: Icons.add,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => O_AddActivity(officerId: officerId),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ctrl.watchOfficerActivities(officerId),
                builder: (context, snap) {
                  if (snap.hasError) {return Center(child: Text("Error: ${snap.error}"));}
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) return const Center(child: Text("No activities yet. Tap + to add."));

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final d = docs[i];
                      final data = d.data();
                      final title = (data['title'] ?? '').toString();
                      final desc = (data['description'] ?? '').toString();
                      final place = (data['place'] ?? '').toString();
                      final preacherName = (data['preacherName'] ?? '').toString();
                      final dt = (data['dateTime'] as Timestamp).toDate();

                      final dateStr = DateFormat('d/M/yyyy').format(dt);
                      final timeStr = DateFormat('h:mm a').format(dt);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCFE7F3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black.withOpacity(.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            if (desc.trim().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(desc, style: const TextStyle(fontSize: 13)),
                            ],
                            const SizedBox(height: 8),
                            _infoRow(Icons.location_on_outlined, place),
                            const SizedBox(height: 4),
                            _infoRow(Icons.calendar_month_outlined, dateStr),
                            const SizedBox(height: 4),_infoRow(Icons.access_time_rounded, timeStr),
                            const SizedBox(height: 6),
                            _infoRow(Icons.person_outline, preacherName),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _pillButton("EDIT", onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => O_EditActivity(
                                        officerId: officerId,
                                        activityId: d.id,
                                        existing: data,
                                      ),

                                    ),
                                  );
                                }),
                                const SizedBox(width: 10),
                                _pillButton("DELETE", onTap: () => _confirmDelete(context, d.id)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OfficerNav(
        currentIndex: 0,
        onTap: (i) {
          // 0 activity (stay), 1 home, 2 profile
          // Your friend will wire navigation later
        },
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(.2)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  Widget _pillButton(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(.25)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final ctrl = context.read<ActivityController>();
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            "Are You Sure Want to\nDelete This Activity?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            _dialogBtn(context, "NO", () => Navigator.pop(context, false)),
            _dialogBtn(context, "YES", () => Navigator.pop(context, true)),
          ],
        );
      },
    );

    if (ok == true) {
      await ctrl.deleteActivity(id);
      if (context.mounted) {
        _successPopup(context, "The Activity\nSuccessfully\nDeleted!!");
      }
    }
  }

  Widget _dialogBtn(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFCFE7F3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withOpacity(.25)),
        ),
        child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
      ),
    );
  }

  Future<void> _successPopup(BuildContext context, String text) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 72, color: Colors.green),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 130,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFCFE7F3),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.black.withOpacity(.25)),
                ),
                child: const Center(child: Text("OK", style: TextStyle(fontWeight: FontWeight.w800))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
