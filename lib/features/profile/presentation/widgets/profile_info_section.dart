import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class ProfileInfoSection extends StatelessWidget {
  final Map<String, dynamic> member;

  const ProfileInfoSection({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contato
        _buildInfoCard(
          'Contato',
          Icons.contact_phone_outlined,
          Column(
            children: [
              _buildContactItem(
                Icons.work_outline,
                'LinkedIn',
                member['linkedin'] ?? 'Não informado',
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildContactItem(
                Icons.email_outlined,
                'Email',
                member['email'] ?? 'Não informado',
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildContactItem(
                Icons.phone_outlined,
                'Telefone',
                member['phone'] ?? 'Não informado',
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildContactItem(
                Icons.camera_alt_outlined,
                'Instagram',
                member['instagram'] ?? 'Não informado',
              ),
            ],
          ),
        ),

        // Especialidades
        if (member['specialties'] != null && member['specialties'].isNotEmpty)
          _buildInfoCard(
            'Especialidades',
            Icons.star_outline,
            Wrap(
              spacing: AppConstants.paddingSmall,
              runSpacing: AppConstants.paddingSmall,
              children:
                  (member['specialties'] as List<String>).map((specialty) => _buildSpecialtyChip(specialty)).toList(),
            ),
          ),

        // Conquistas
        if (member['achievements'] != null && member['achievements'].isNotEmpty)
          _buildInfoCard(
            'Conquistas',
            Icons.emoji_events_outlined,
            Column(
              children: (member['achievements'] as List<Map<String, dynamic>>)
                  .map((achievement) => _buildAchievementItem(achievement))
                  .toList(),
            ),
          ),

        // Informações adicionais
        _buildInfoCard(
          'Informações',
          Icons.info_outline,
          Column(
            children: [
              _buildInfoItem(
                'Membro desde',
                _formatDate(member['joinDate'] ?? DateTime.now()),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildInfoItem(
                'Última atividade',
                (member['isOnline'] ?? false) ? 'Online agora' : 'Há 2 horas',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, Widget content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF4A90E2),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4A90E2),
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyChip(String specialty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4A90E2).withOpacity(0.2),
            const Color(0xFF4A90E2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4A90E2).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        specialty,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF4A90E2),
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              achievement['icon'] ?? Icons.emoji_events,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement['description'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFAAAAAA),
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFAAAAAA),
            fontFamily: 'SF Pro Display',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
