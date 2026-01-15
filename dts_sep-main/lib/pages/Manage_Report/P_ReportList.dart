import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../ui/common/daie_header.dart';
import 'P_ViewReportPage.dart';

class P_ReportListPage extends StatefulWidget {
  const P_ReportListPage({super.key});

  @override
  State<P_ReportListPage> createState() => _O_ReportListPageState();
}

class _O_ReportListPageState extends State<P_ReportListPage> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final reportsRef = FirebaseFirestore.instance.collection('reports');

    return Scaffold(
      appBar: const DaieHeader(),
      body: Center(
        child: Container(
          width: 360,
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
                "Report List",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),

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

              const SizedBox(height: 12),

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: reportsRef
                      // If you have createdAt in docs, this works:
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snap.hasData) {
                      return const Center(child: Text("No data"));
                    }

                    final docs = snap.data!.docs;

                    // Filter by title (client-side)
                    final filtered = docs.where((d) {
                      final data = d.data();
                      final title = (data['title'] ?? data['reportTitle'] ?? '').toString().toLowerCase();
                      return _search.isEmpty || title.contains(_search);
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text("No report found"));
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final d = filtered[i];
                        final data = d.data();

                        final title = (data['title'] ?? data['reportTitle'] ?? '-').toString();
                        final date = (data['date'] ?? data['year'] ?? '-').toString();

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => P_ViewReportPage(reportId: d.id),
                              ),
                            );
                          },
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
                                  child: const Icon(Icons.description_outlined),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(.65),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

  Widget _pillButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE7E7E7),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
      ),
    );
  }
}
