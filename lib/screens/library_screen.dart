import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/document_model.dart';
import '../services/api_service.dart';
import 'study_screen.dart';
 
// ── Library Screen 
 
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<DocumentModel>> _documents;
  String _search = "";

  @override
  void initState() {
    super.initState();
    _documents = ApiService.getDocuments();
  }

  Future<void> _refresh() async {
    setState(() {
      _documents = ApiService.getDocuments();
    });

    await _documents;
  }

  void _showMenu(DocumentModel item) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Rename"),
              onTap: () async {

  Navigator.pop(context);

  final controller = TextEditingController(
    text: item.originalFilename,
  );

  final newName = await showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text("Rename document",
      style: TextStyle(
        color: AppColors.textPrimary, 
        fontWeight: FontWeight.bold,
       ),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(
          color: AppColors.textPrimary, 
       ),
       decoration: const InputDecoration(
         enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
       ),
      focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
       ),
       ),
      ),
      
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              controller.text.trim(),
            );
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );

  if (newName != null && newName.isNotEmpty) {

    await ApiService.renameDocument(
      item.documentName,
      newName,
    );

    await _refresh();
  }
},
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text("Delete"),
              onTap: () async {
                Navigator.pop(context);

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.card,
                    title: const Text("Delete document?", 
                    style: TextStyle(
                          color: AppColors.textPrimary, 
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    content: Text(
                      "Delete ${item.originalFilename}?",
                      style: const TextStyle(
                          color: AppColors.textSecondary, 
                        ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel", 
                        style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.red, 
                          ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ApiService.deleteDocument(
                    item.documentName,
                  );

                  await _refresh();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
 
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh, 
          child: FutureBuilder<List<DocumentModel>>(
  future: _documents,
  builder: (context, snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(snapshot.error.toString()),
      );
    }

    final items = snapshot.data ?? [];
    final filtered = items.where((doc) {
      return doc.originalFilename.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    return CustomScrollView(
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
                    onTap: () async {
                      try {
                        final result = await ApiService.uploadPdf();

                        if (result != null) {
                          await _refresh();

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${result["original_filename"]} uploaded successfully',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
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
                            Text('Import Notes', style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('Tap to add your notes', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ]),
                        ),
                        const Icon(Icons.add_rounded, color: AppColors.primary),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 8), 
                  TextField(
  onChanged: (value) {
    setState(() {
      _search = value;
    });
  },
  style: const TextStyle(
  color: AppColors.textPrimary, 
  ),
  decoration: const InputDecoration(
    hintText: "Search documents...",
    hintStyle: TextStyle(color: AppColors.textMuted),
    prefixIcon: Icon(Icons.search),
    prefixIconColor: AppColors.textMuted,
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
                  final item = filtered[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => StudyScreen(
                              documentName: item.documentName, 
                              pdfName: item.originalFilename,
                            )
                          ),
                        );
                      }
                      ,
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
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item.originalFilename,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 3),
                              Text('${item.totalChunks} chunks · ${item.uploadedAt.substring(0, 10)}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ]),
                          ),
                          IconButton(
                         icon: const Icon(
                          Icons.more_vert_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                        onPressed: () {
                        _showMenu(item);
                       },
                      )
                        ]),
                      ),
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      },
    ),
  ),
),
    );
  }
}

