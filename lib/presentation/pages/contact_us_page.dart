import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                Text(
                  "يسعدنا تواصلك معنا",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF001E30),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "يمكنك الوصول إلينا عبر المنصات التالية",
                  style: TextStyle(color: Colors.black45, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildContactCard(
                  context,
                  title: 'البريد الإلكتروني',
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
                  icon: Icons.play_store_rounded,
                  url: 'https://play.google.com/store/apps/dev?id=6122016141032404367',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar.large(
      title: const Text('تواصل معنا'),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF0F4F8), Color(0xFFE0E8F0)],
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
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
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
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
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF001E30)),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.black45),
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
