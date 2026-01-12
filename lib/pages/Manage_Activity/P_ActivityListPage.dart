import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/ActivityController.dart';
import '../../ui/common/daie_header.dart';
import '../../ui/common/preacher_nav.dart';

import '../Manage_User_Registration/P_HomePage.dart';
import '../Manage_User_Profile/P_ProfilePage.dart';

class P_ActivityList extends StatefulWidget {
  final String preacherId;
  const P_ActivityList({super.key, required this.preacherId});

  @override
  State<P_ActivityList> createState() => _P_ActivityListState();
}

class _P_ActivityListState extends State<P_ActivityList>
    with SingleTickerProviderStateMixin {
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
    final ctrl = context.read<ActivityController>();

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
              stream: ctrl.watchPreacherActivities(widget.preacherId),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text("Error: ${snap.error}"));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

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
        currentIndex: 0, // 👥 selected
        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PHomePage(preacherId: widget.preacherId),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PProfilePage(userId: widget.preacherId),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _list(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    required bool upcoming,
  }) {
    final now = DateTime.now();

    final filtered = docs.where((d) {
      final raw = d.data()['dateTime'];
      if (raw is! Timestamp) return false;
      final dt = raw.toDate();
      return upcoming ? dt.isAfter(now) : !dt.isAfter(now);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(upcoming ? "No upcoming activity" : "No completed activity"),
      );
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
              const SizedBox(height: 4),
              _row(Icons.access_time_rounded, timeStr),
              if (!upcoming) ...[
                const SizedBox(height: 6),
                Text(
                  "Payment Receipt",
                  style: TextStyle(
                    color: Colors.black.withOpacity(.35),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
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
