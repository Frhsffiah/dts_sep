import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/activity_service.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/preacher_nav.dart';

class PreacherActivityTabs extends StatefulWidget {
  final String preacherId; // pass "preacher_001"
  const PreacherActivityTabs({super.key, required this.preacherId});

  @override
  State<PreacherActivityTabs> createState() => _PreacherActivityTabsState();
}

class _PreacherActivityTabsState extends State<PreacherActivityTabs> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svc = ActivityService();

    return Scaffold(
      appBar: const DaieHeader(),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFCFE7F3),
            child: TabBar(
              controller: _tab,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: svc.watchPreacherActivities(widget.preacherId),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;

                return TabBarView(
                  controller: _tab,
                  children: [
                    _list(docs, upcoming: true),
                    _list(docs, upcoming: false),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: PreacherNav(
        currentIndex: 0,
        onTap: (i) {
          // friend will wire navigation
        },
      ),
    );
  }

  Widget _list(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {required bool upcoming}) {
    final now = DateTime.now();

    final filtered = docs.where((d) {
      final dt = (d.data()['dateTime'] as Timestamp).toDate();
      return upcoming ? dt.isAfter(now) : !dt.isAfter(now);
    }).toList();

    if (filtered.isEmpty) {
      return Center(child: Text(upcoming ? "No upcoming activity" : "No completed activity"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final data = filtered[i].data();
        final title = (data['title'] ?? '').toString();
        final place = (data['place'] ?? '').toString();
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              _row(Icons.location_on_outlined, place),
              const SizedBox(height: 4),
              _row(Icons.calendar_month_outlined, dateStr),
              const SizedBox(height: 4),_row(Icons.access_time_rounded, timeStr),
              if (!upcoming) ...[
                const SizedBox(height: 6),
                Text("Payment Receipt", style: TextStyle(color: Colors.black.withOpacity(.35), decoration: TextDecoration.underline)),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}
