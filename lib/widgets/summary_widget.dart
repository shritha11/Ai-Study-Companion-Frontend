import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';

// ── Summary Widget ────────────────────────────────────────────────────────

class SummaryWidget extends StatefulWidget {
  final String topic;
  final String? documentName;
  final List<String>? documentNames;
  const SummaryWidget({super.key, required this.topic, this.documentName, this.documentNames});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  String? _summary;
  bool _loading = true;
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await ApiService.chat(
          'Give me a concise bullet-point summary of: ${widget.topic}. Use • for each point. Max 6 points.', 
          documentName: widget.documentName,
          documentNames: widget.documentNames,
          );
      setState(() { _summary = response.response; _loading = false; });
    } catch (_) {
      setState(() { _summary = 'Failed to load summary.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.summarize_outlined, color: AppColors.blue, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Summary', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(widget.topic, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ]),
                ),
                Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: AppColors.textMuted, size: 20),
              ]),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _loading
                  ? const Center(child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: AppColors.blue, strokeWidth: 2),
                    ))
                  : Text(_summary ?? '',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 14, height: 1.7)),
            ),
        ],
      ),
    );
  }
}

// ── Examples Widget 

class ExamplesWidget extends StatefulWidget {
  final String topic;
  final String? documentName;
  final List<String>? documentNames;
  const ExamplesWidget({super.key, required this.topic, this.documentName, this.documentNames });

  @override
  State<ExamplesWidget> createState() => _ExamplesWidgetState();
}

class _ExamplesWidgetState extends State<ExamplesWidget> {
  String? _content;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await ApiService.chat(
          'Give me 4 real-world practical examples of: ${widget.topic}. Number them 1-4. Keep each example concise and clear.', 
          documentName: widget.documentName,
          documentNames: widget.documentNames,
          );
      setState(() { _content = response.response; _loading = false; });
    } catch (_) {
      setState(() { _content = 'Failed to load examples.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.success, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Real-World Examples',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(widget.topic, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ]),
            ),
          ]),
          const SizedBox(height: 14),
          _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.success, strokeWidth: 2))
              : Text(_content ?? '',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.7)),
        ],
      ),
    );
  }
}

// ── Coding Widget

class CodingWidget extends StatefulWidget {
  final String topic;
  final String? documentName;
  final List<String>? documentNames;
  const CodingWidget({super.key, required this.topic, this.documentName, this.documentNames});

  @override
  State<CodingWidget> createState() => _CodingWidgetState();
}

class _CodingWidgetState extends State<CodingWidget> {
  Map<String, String>? _challenge;
  bool _loading = true;
  bool _showHint = false;
  bool _showSolution = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _showHint = false; _showSolution = false; });
    try {
      final response = await ApiService.chat(
          'Give me a coding challenge on: ${widget.topic}. Format your response exactly like this:\n'
          'DIFFICULTY: Easy/Medium/Hard\n'
          'PROBLEM: [problem statement]\n'
          'CONSTRAINTS: [constraints]\n'
          'HINT: [one helpful hint]\n'
          'SOLUTION: [code solution]', 
          documentName: widget.documentName,
          documentNames: widget.documentNames,
          );
      setState(() { _challenge = _parse(response.response ?? ""); _loading = false; });
    } catch (_) {
      setState(() { _loading = false; });
    }
  }

  Map<String, String> _parse(String text) {
    final map = <String, String>{};
    for (final key in ['DIFFICULTY', 'PROBLEM', 'CONSTRAINTS', 'HINT', 'SOLUTION']) {
      final regex = RegExp('$key:\\s*(.+?)(?=\\n[A-Z]+:|\$)',dotAll: true,);
      final match = regex.firstMatch(text);
      if (match != null) map[key] = match.group(1)?.trim() ?? '';
    }
    return map;
  }

  Color _diffColor(String? diff) {
    switch (diff?.toLowerCase()) {
      case 'easy': return AppColors.success;
      case 'hard': return AppColors.error;
      default: return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: _loading
          ? Column(mainAxisSize: MainAxisSize.min, children: [
              const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              const SizedBox(height: 12),
              Text('Generating challenge on "${widget.topic}"...',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.code_rounded, color: AppColors.primary, size: 16),
                ),
                const SizedBox(width: 12),
                const Text('Coding Challenge',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                if (_challenge?['DIFFICULTY'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _diffColor(_challenge!['DIFFICULTY']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_challenge!['DIFFICULTY']!,
                        style: TextStyle(
                            color: _diffColor(_challenge!['DIFFICULTY']),
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
              ]),
              const SizedBox(height: 14),
              if (_challenge?['PROBLEM'] != null) ...[
                _label('Problem'),
                const SizedBox(height: 6),
                Text(_challenge!['PROBLEM']!,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5)),
                const SizedBox(height: 12),
              ],
              if (_challenge?['CONSTRAINTS'] != null) ...[
                _label('Constraints'),
                const SizedBox(height: 6),
                Text(_challenge!['CONSTRAINTS']!,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                const SizedBox(height: 14),
              ],
              Row(children: [
                _outlineBtn('Hint', Icons.lightbulb_outline_rounded, () => setState(() => _showHint = !_showHint)),
                const SizedBox(width: 8),
                _outlineBtn('Solution', Icons.visibility_outlined, () => setState(() => _showSolution = !_showSolution)),
                const Spacer(),
                _outlineBtn('New', Icons.refresh_rounded, _load),
              ]),
              if (_showHint && _challenge?['HINT'] != null) ...[
                const SizedBox(height: 12),
                _infoBox('Hint', _challenge!['HINT']!, AppColors.warning),
              ],
              if (_showSolution && _challenge?['SOLUTION'] != null) ...[
                const SizedBox(height: 12),
                _codeBox(_challenge!['SOLUTION']!),
              ],
            ]),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5));

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    ),
  );

  Widget _infoBox(String title, String text, Color color) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.07),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Text(text, style: TextStyle(color: color, fontSize: 13, height: 1.5)),
  );

  Widget _codeBox(String code) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(code,
        style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontFamily: 'monospace',
            height: 1.6)),
  );
}