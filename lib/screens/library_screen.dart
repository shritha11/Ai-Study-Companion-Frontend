import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
 
// ── Library Screen 
 
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'DSA Notes', 'size': '2.4 MB', 'date': 'Today', 'icon': Icons.picture_as_pdf_rounded, 'color': AppColors.error},
      {'title': 'DBMS Slides', 'size': '5.1 MB', 'date': 'Yesterday', 'icon': Icons.picture_as_pdf_rounded, 'color': AppColors.warning},
      {'title': 'OS Concepts', 'size': '1.8 MB', 'date': '3 days ago', 'icon': Icons.picture_as_pdf_rounded, 'color': AppColors.blue},
    ];
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Library',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.8)),
                  const SizedBox(height: 6),
                  const Text('Your uploaded PDFs and notes.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                  const SizedBox(height: 24),
                  // Upload button
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                      ),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.upload_file_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Upload PDF', style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('Tap to add your notes', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ]),
                        ),
                        const Icon(Icons.add_rounded, color: AppColors.primary),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('YOUR FILES',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                  const SizedBox(height: 14),
                ]),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final item = items[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(children: [
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item['title'] as String,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 3),
                              Text('${item['size']} · ${item['date']}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ]),
                          ),
                          const Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: 18),
                        ]),
                      ),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}