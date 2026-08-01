import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/l10n/app_localizations.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(l10n, isDark),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileHeader(l10n, isDark),
                const SizedBox(height: 30),
                _buildSection(
                  context,
                  title: l10n.translate('technical_skills'),
                  icon: Icons.code_rounded,
                  items: [
                    l10n.translate('skill_1'),
                    l10n.translate('skill_2'),
                    l10n.translate('skill_3'),
                    l10n.translate('skill_4'),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  title: l10n.translate('key_projects'),
                  icon: Icons.rocket_launch_rounded,
                  items: [
                    l10n.translate('proj_1'),
                    l10n.translate('proj_2'),
                    l10n.translate('proj_3'),
                    l10n.translate('proj_4'),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  title: l10n.translate('personal_skills'),
                  icon: Icons.psychology_rounded,
                  items: [
                    l10n.translate('pers_1'),
                    l10n.translate('pers_2'),
                    l10n.translate('pers_3'),
                    l10n.translate('pers_4'),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  l10n.translate('quote'),
                  style: GoogleFonts.poppins(
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n, bool isDark) {
    return SliverAppBar.large(
      title: Text(l10n.translate('about_me')),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark 
                ? [const Color(0xFF121212), const Color(0xFF1E1E1E)]
                : [const Color(0xFFF0F4F8), const Color(0xFFE0E8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations l10n, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF0061A4), Color(0xFF00A3FF)],
            ),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: Icon(Icons.person_rounded, size: 60, color: const Color(0xFF0061A4)),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          l10n.translate('dev_name'),
          style: GoogleFonts.poppins(
            fontSize: 26,
            color: isDark ? Colors.white : const Color(0xFF001E30),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          l10n.translate('dev_role'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black54),
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.translate('dev_edu'),
          style: TextStyle(fontSize: 14, color: isDark ? Colors.white38 : Colors.black45),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required IconData icon, required List<String> items}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0061A4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF0061A4), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF001E30),
                ),
              ),
            ],
          ),
          Divider(height: 30, color: isDark ? Colors.white10 : Colors.black12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF0061A4)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
