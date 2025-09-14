import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> member;

  const ProfileHeader({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar premium com gradiente
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2A2A2A),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      (member['profileImage'] ?? '').isNotEmpty ? NetworkImage(member['profileImage']) : null,
                  child: (member['profileImage'] ?? '').isEmpty
                      ? Text(
                          _getInitials(member['name'] ?? 'NN'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'SF Pro Display',
                          ),
                        )
                      : null,
                ),
              ),
              // Status online premium
              if (member['isOnline'] ?? false)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF50C878),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1A1A1A), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF50C878).withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // Badge premium (mais compacto)
          if (member['badge'] != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: member['badgeColor'] ?? const Color(0xFF555555),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                member['badge'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            const SizedBox(height: 3),
          ],

          // Nome premium
          Text(
            member['name'] ?? 'Nome não informado',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.8,
              fontFamily: 'SF Pro Display',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 2),

          // Cargo e empresa premium
          Text(
            '${member['position'] ?? 'Cargo'} • ${member['company'] ?? 'Empresa'}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFCCCCCC),
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Display',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }
}
