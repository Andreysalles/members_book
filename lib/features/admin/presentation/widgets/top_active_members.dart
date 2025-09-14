import 'package:flutter/material.dart';

class TopActiveMembers extends StatefulWidget {
  const TopActiveMembers({super.key});

  @override
  State<TopActiveMembers> createState() => _TopActiveMembersState();
}

class _TopActiveMembersState extends State<TopActiveMembers> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Color(0xFFFF6B35),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Membros Mais Ativos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Top 5',
                    style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lista de membros
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  children: List.generate(5, (index) {
                    final member = _getMemberData(index);
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - _animation.value)),
                      child: Opacity(
                        opacity: _animation.value,
                        child: _buildMemberItem(
                          member,
                          index + 1,
                          _animation.value,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem(Map<String, dynamic> member, int position, double animation) {
    final colors = [
      const Color(0xFFFFD700), // Ouro
      const Color(0xFFC0C0C0), // Prata
      const Color(0xFFCD7F32), // Bronze
      const Color(0xFF4A90E2), // Azul
      const Color(0xFF9C27B0), // Roxo
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Posição
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors[position - 1].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors[position - 1].withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '$position',
                style: TextStyle(
                  color: colors[position - 1],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors[position - 1],
                  colors[position - 1].withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Informações do membro
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['role'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
          ),

          // Métricas
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                member['score'],
                style: TextStyle(
                  color: colors[position - 1],
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                member['metric'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMemberData(int index) {
    final members = [
      {
        'name': 'Ana Silva',
        'role': 'CEO - TechCorp',
        'score': '2,847',
        'metric': 'indicações',
      },
      {
        'name': 'Carlos Mendes',
        'role': 'CTO - StartupX',
        'score': '2,134',
        'metric': 'indicações',
      },
      {
        'name': 'Marina Costa',
        'role': 'Diretora - Inovação',
        'score': '1,892',
        'metric': 'indicações',
      },
      {
        'name': 'Pedro Santos',
        'role': 'VP - Vendas',
        'score': '1,654',
        'metric': 'indicações',
      },
      {
        'name': 'Julia Oliveira',
        'role': 'Head - Marketing',
        'score': '1,423',
        'metric': 'indicações',
      },
    ];
    return members[index];
  }
}
