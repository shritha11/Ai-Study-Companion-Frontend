import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'brain_break_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _continueLearning()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _brainBreak(context)), 
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _quickActions(context)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: _recentSessions()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
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
            'Shritha 👋',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
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

  Widget _continueLearning() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InkWell(
        onTap: () {},
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
                'Data Structures',
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Last session · Today · 6:42 PM',
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
            subtitle: 'Ask Lumina anything',
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.sm),
          Row(children: [
            Expanded(
              child: _smallAction(
                icon: Icons.quiz_outlined,
                title: 'Practice',
                subtitle: 'AI Quiz',
                color: AppColors.success,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _smallAction(
                icon: Icons.style_outlined,
                title: 'Revise',
                subtitle: 'Flashcards',
                color: AppColors.warning,
              ),
            ),
          ]),
          SizedBox(height: AppSpacing.sm),
          _largeAction(
            icon: Icons.folder_open_rounded,
            title: 'Library',
            subtitle: 'Your PDFs & Notes',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _largeAction({required IconData icon, required String title, required String subtitle, required Color color}) {
    return InkWell(
      onTap: () {},
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

  Widget _smallAction({required IconData icon, required String title, required String subtitle, required Color color}) {
    return InkWell(
      onTap: () {},
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

  Widget _recentSessions() {
    final sessions = [
      {'title': 'Binary Search', 'time': 'Today · 6:42 PM', 'icon': Icons.search_rounded},
      {'title': 'Operating Systems', 'time': 'Yesterday', 'icon': Icons.memory_rounded},
      {'title': 'Flutter Widgets', 'time': '2 days ago', 'icon': Icons.widgets_outlined},
    ];

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
          ...sessions.map((s) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () {},
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
                    child: Icon(s['icon'] as IconData, color: AppColors.primary, size: 18),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        s['title'] as String,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        s['time'] as String,
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
