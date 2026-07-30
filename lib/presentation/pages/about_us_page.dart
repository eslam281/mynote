import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileHeader(),
                const SizedBox(height: 30),
                _buildSection(
                  title: 'المهارات التقنية',
                  icon: Icons.code_rounded,
                  items: [
                    'حل المشكلات، هياكل البيانات والخوارزميات',
                    'مبادئ OOP وهندسة البرمجيات الحديثة',
                    'قواعد البيانات العلائقية (MySQL)',
                    'إتقان Flutter, Dart, REST API, Git'
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'أبرز المشاريع',
                  icon: Icons.rocket_launch_rounded,
                  items: [
                    'نظام متجر إلكتروني متكامل (3 تطبيقات)',
                    'واجهة مستخدم متجاوبة باستخدام GetX',
                    'باك إند متطور باستخدام PHP و MySQL',
                    'أنظمة تتبع ودفع إلكتروني ذكية'
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'المهارات الشخصية',
                  icon: Icons.psychology_rounded,
                  items: [
                    'حب مشاركة المعرفة والتطوع التقني',
                    'القدرة على العمل الجماعي وقيادة الفرق',
                    'احترام أخلاقيات العمل والاحترافية',
                    'البحث السريع وإيجاد حلول إبداعية'
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "\"البرمجة ليست مجرد كود، بل هي فن حل المشكلات\"",
                  style: GoogleFonts.poppins(
                    fontStyle: FontStyle.italic,
                    color: Colors.black38,
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

  Widget _buildAppBar() {
    return SliverAppBar.large(
      title: const Text('من أنا'),
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

  Widget _buildProfileHeader() {
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
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_rounded, size: 60, color: Color(0xFF0061A4)),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'إسلام سيد عبد العزيز',
          style: GoogleFonts.poppins(
            fontSize: 26,
            color: const Color(0xFF001E30),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        const Text(
          'مطور تطبيقات موبايل (Flutter)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const Text(
          'كلية الحاسبات والمعلومات - أكاديمية طيبة',
          style: TextStyle(fontSize: 14, color: Colors.black45),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<String> items}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
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
                  color: const Color(0xFF001E30),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF0061A4)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
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
