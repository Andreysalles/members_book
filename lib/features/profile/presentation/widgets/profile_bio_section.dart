import 'package:flutter/material.dart';

class ProfileBioSection extends StatelessWidget {
  final Map<String, dynamic> member;

  const ProfileBioSection({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final bio = member['bio'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header da seção
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF357ABD),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Sobre',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Conteúdo da bio
          Text(
            bio.isNotEmpty
                ? bio
                : 'Empreendedor apaixonado por tecnologia e inovação. Com mais de 15 anos de experiência no mercado, especializado em transformação digital e liderança de equipes.',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFCCCCCC),
              height: 1.6,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
