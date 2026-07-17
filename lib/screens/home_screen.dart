import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'brain_break_screen.dart';
import '../models/dashboard_model.dart';
import '../services/api_service.dart';
import 'study_screen.dart';
import 'library_screen.dart';
import '../models/study_mode.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} 
class _HomeScreenState extends State<HomeScreen> {

  DashboardModel? dashboard;
  bool isLoading = true;

  String formatDate(DateTime date) {
  final now = DateTime.now();

  if (DateUtils.isSameDay(now, date)) {
    return "Today • ${TimeOfDay.fromDateTime(date).format(context)}";
  }

  if (DateUtils.isSameDay(
      now.subtract(const Duration(days: 1)),
      date,
  )) {
    return "Yesterday";
  }

  return "${date.day}/${date.month}/${date.year}";
}

  @override
void initState() {
  super.initState();
  loadDashboard();
}

// Future<void> loadUser() async {
//   try {
//     dashboard = await ApiService.getDashboard();
//   } catch (e) {
//     debugPrint(e.toString());
//   }

//   if (mounted) {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }

Future<void> loadDashboard() async {
  try {
    dashboard = await ApiService.getDashboard();
  } catch (e) {
    debugPrint(e.toString());
  }

  if (mounted) {
    setState(() {
      isLoading = false;
    });
  }
}

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

if (dashboard == null) {
  return const Scaffold(
    body: Center(
      child: Text("Failed to load dashboard"),
    ),
  );
}

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header(dashboard!)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _continueLearning(dashboard!)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _brainBreak(context)), 
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _quickActions(context)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _recentSessions(dashboard!)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  Widget _header(DashboardModel dashboard) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.md,
      AppSpacing.lg,
      0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          '${dashboard.user.name} ',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
  margin: const EdgeInsets.only(top: 12),
  padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 8,
  ),
  decoration: BoxDecoration(
    color: Colors.orange.withOpacity(0.12),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: Colors.orange.withOpacity(0.4),
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "🔥",
        style: TextStyle(fontSize: 18),
      ),
      const SizedBox(width: 8),
      Text(
        "${dashboard.user.currentStreak} Day Streak",
        style: GoogleFonts.inter(
          color: Colors.orange.shade800,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  ),
),
        Text(
          'Continue your learning journey.',
          style: GoogleFonts.inter(
            color: AppColors.textMuted,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}

  Widget _continueLearning(DashboardModel dashboard) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InkWell(
        onTap: dashboard.continueLearning == null ? null : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudyScreen(
                sessionId: dashboard.continueLearning!.id,
                documentName: dashboard.continueLearning!.documentName,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Ink(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONTINUE LEARNING',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                 dashboard.continueLearning?.title ?? "No recent study session",
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                dashboard.continueLearning == null ? "Start chatting to begin learning." : formatDate(dashboard.continueLearning!.createdAt),
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Row(children: [
                Text(
                  'Resume Learning',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brainBreak(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg), 
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => const BrainBreakScreen(),
          ));
        }, 
        child: Ink(
          padding: EdgeInsets.all(AppSpacing.md), 
          decoration: BoxDecoration(
            color: const Color(0xffFFF7E8),
            borderRadius: BorderRadius.circular(AppRadius.medium), 
            border: Border.all(
              color: const Color(0xffF5D37A),
            ),
          ), 
          child: Row(
            children: [
              Container(
                width: 58, 
                height: 58, 
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded, 
                  color: Colors.orange, 
                  size: 28,
                ),
              ),
              SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text("Brain Break", 
                    style: GoogleFonts.inter(
                      fontSize: 18, 
                      fontWeight: FontWeight.w700, 
                      color: Colors.black87,
                    )),
                    const SizedBox(height: 6),
                    Text("Recharge with a fun 3-minute challenge.", 
                    style: GoogleFonts.inter(
                      color: Colors.black54, 
                      fontSize: 13,
                    )),
                    const SizedBox(height: 14), 
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14, 
                        vertical: 8,
                      ), 
                      decoration: BoxDecoration(
                        color: Colors.orange, 
                        borderRadius: BorderRadius.circular(20),
                      ), 
                      child: const Text("Start Challenge", 
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w600,
                      )),
                    )
                  ]
                )
              )
            ]
          )
        )
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start Learning',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Choose how you'd like to continue.",
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _largeAction(
            icon: Icons.auto_awesome_rounded,
            title: 'Learn',
            subtitle: 'Ask Eunoia anything',
            color: AppColors.primary,
            onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudyScreen(
          sessionId: "",
        ),
          ),
    );
            },
          ),
          SizedBox(height: AppSpacing.sm),
          Row(children: [
            Expanded(
              child: _smallAction(
                icon: Icons.quiz_outlined,
                title: 'Practice',
                subtitle: 'AI Quiz',
                color: AppColors.success,
                onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudyScreen(
          sessionId: "",
          mode: StudyMode.quiz,
        ),
      ),
    );
  },
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _smallAction(
                icon: Icons.style_outlined,
                title: 'Revise',
                subtitle: 'Flashcards',
                color: AppColors.warning,
                onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudyScreen(
          sessionId: "",
          mode: StudyMode.flashcards,
        ),
      ),
    );
  },
              ),
            ),
          ]),
          SizedBox(height: AppSpacing.sm),
          _largeAction(
            icon: Icons.folder_open_rounded,
            title: 'Library',
            subtitle: 'Your PDFs & Notes',
            color: AppColors.primary,
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => LibraryScreen(),
    ),
  );
}
          ),
        ],
      ),
    );
  }

  Widget _largeAction({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return InkWell(
        onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Ink(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ]),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 15),
        ]),
      ),
    );
  }

  Widget _smallAction({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Ink(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _recentSessions(DashboardModel dashboard) {
    final sessions = dashboard.recentSessions;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Sessions',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Continue from where you left off.',
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          if (sessions.isEmpty)
  Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(
      "No recent sessions yet.",
      style: GoogleFonts.inter(
        color: AppColors.textSecondary,
      ),
    ),
  )
else
  ...sessions.map((session) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudyScreen(
          sessionId: session.id,
          documentName: session.documentName,
        ),
      ),
    );
  },
              
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Icon(Icons.history_rounded, color: AppColors.primary, size: 18),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        session.title ?? "Untitled Session",
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        formatDate(session.createdAt),
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14),
                ]),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
