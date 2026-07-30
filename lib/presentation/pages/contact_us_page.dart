import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../logic/l10n/app_localizations.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(l10n, isDark),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                Text(
                  l10n.translate('contact_msg'),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF001E30),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate('contact_platform'),
                  style: TextStyle(color: isDark ? Colors.white38 : Colors.black45, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildContactCard(
                  context,
                  title: l10n.translate('email'),
                  subtitle: 'aslamsydbdalzyzbry@gmail.com',
                  icon: Icons.email_rounded,
                  url: "mailto:aslamsydbdalzyzbry@gmail.com",
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  context,
                  title: 'GitHub',
                  subtitle: 'github.com/eslam281',
                  icon: Icons.code_rounded,
                  url: 'https://github.com/eslam281',
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  context,
                  title: 'LinkedIn',
                  subtitle: 'islam-sayed',
                  icon: Icons.business_center_rounded,
                  url: 'https://www.linkedin.com/in/islam-sayed-a2a8b4259',
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  context,
                  title: 'Google Play',
                  subtitle: 'Eslam28_1',
                  icon: Icons.play_arrow_rounded,
                  url: 'https://play.google.com/store/apps/dev?id=6122016141032404367',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n, bool isDark) {
    return SliverAppBar.large(
      title: Text(l10n.translate('contact_us')),
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

  Widget _buildContactCard(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required String url}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(url);
            try {
              final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
              if (!launched) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر فتح الرابط')),
                  );
                }
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('حدث خطأ أثناء فتح الرابط')),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0061A4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: const Color(0xFF0061A4), size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: isDark ? Colors.white : const Color(0xFF001E30)
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.black45),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
