import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class GamificationPage extends StatefulWidget {
  const GamificationPage({super.key});

  @override
  State<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  // Mock data do ranking
  final List<Map<String, dynamic>> _rankingData = [
    {
      'id': '1',
      'name': 'Carlos Mendes',
      'position': 'Fundador • Consultoria',
      'score': 12100,
      'indicationsCount': 203,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'profileImage': '',
      'rank': 1,
      'isCurrentUser': false,
    },
    {
      'id': '2',
      'name': 'Fernanda Rocha',
      'position': 'Diretora Financeira • Finanças',
      'score': 11200,
      'indicationsCount': 156,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
      'rank': 2,
      'isCurrentUser': false,
    },
    {
      'id': '3',
      'name': 'Alexandre Santos',
      'position': 'CEO • Tecnologia',
      'score': 9850,
      'indicationsCount': 127,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
      'rank': 3,
      'isCurrentUser': false,
    },
    {
      'id': 'user_logged',
      'name': 'André Pereira',
      'position': 'Fundador • Enjoy App',
      'score': 8750,
      'indicationsCount': 89,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
      'rank': 12,
      'isCurrentUser': true,
    },
    {
      'id': '4',
      'name': 'Beatriz Costa',
      'position': 'Diretora de Marketing • Varejo',
      'score': 7420,
      'indicationsCount': 89,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
      'rank': 4,
      'isCurrentUser': false,
    },
    {
      'id': '5',
      'name': 'Gabriel Torres',
      'position': 'Product Manager • Produto',
      'score': 6340,
      'indicationsCount': 78,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'profileImage': '',
      'rank': 5,
      'isCurrentUser': false,
    },
    {
      'id': '6',
      'name': 'Diana Oliveira',
      'position': 'Head de RH • Recursos Humanos',
      'score': 5890,
      'indicationsCount': 67,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'profileImage': '',
      'rank': 6,
      'isCurrentUser': false,
    },
    {
      'id': '7',
      'name': 'Ana Silva',
      'position': 'Gerente de Vendas • Tecnologia',
      'score': 3250,
      'indicationsCount': 45,
      'badge': 'Membro',
      'badgeColor': const Color(0xFF555555),
      'profileImage': '',
      'rank': 7,
      'isCurrentUser': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const double expandedHeight = 120.0;
    const double collapsedHeight = kToolbarHeight;

    final bool isCollapsed =
        _scrollController.hasClients && _scrollController.offset > (expandedHeight - collapsedHeight);

    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  List<Map<String, dynamic>> _getRankingDataWithoutCurrentUser() {
    return _rankingData.where((member) => member['isCurrentUser'] != true).toList();
  }

  Map<String, dynamic> _getCurrentUser() {
    return _rankingData.firstWhere((member) => member['isCurrentUser'] == true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar premium com gradiente
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: AnimatedOpacity(
                opacity: _isCollapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text(
                  'Ranking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.appBarGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Título principal
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ranking',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Top performers da comunidade',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Ícone de troféu
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF4A90E2),
                                  Color(0xFF357ABD),
                                  Color(0xFF2E5B8A),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4A90E2).withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Conteúdo principal
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Card do usuário atual
                  _buildCurrentUserCard(),

                  const SizedBox(height: 24),

                  // Lista completa do ranking
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ranking Completo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Lista de ranking
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final rankingData = _getRankingDataWithoutCurrentUser();
                    final member = rankingData[index];
                    return _buildRankingItem(member, index);
                  },
                  childCount: _getRankingDataWithoutCurrentUser().length,
                ),
              ),
            ),

            // Espaço extra no final
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRouter.gamification,
      ),
    );
  }

  Widget _buildCurrentUserCard() {
    final currentUser = _getCurrentUser();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF4A90E2).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(AppRouter.profile, extra: _getUserData());
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Posição no ranking
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${currentUser['rank']}º',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Avatar
                Hero(
                  tag: 'avatar_${currentUser['id']}',
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          currentUser['badgeColor'],
                          currentUser['badgeColor'].withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentUser['badgeColor'].withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: currentUser['profileImage'].isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.network(
                              currentUser['profileImage'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              _getInitials(currentUser['name']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 20),

                // Conteúdo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentUser['name'],
                              style: const TextStyle(
                                color: Color(0xFF4A90E2),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                                fontFamily: 'SF Pro Display',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: currentUser['badgeColor'],
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: currentUser['badgeColor'].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              currentUser['badge'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (currentUser['position'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          currentUser['position'],
                          style: const TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Métricas
                      Row(
                        children: [
                          _buildMetric(
                            icon: Icons.star,
                            value: '${currentUser['score']}',
                            label: 'pontos',
                            color: const Color(0xFF4A90E2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankingItem(Map<String, dynamic> member, int index) {
    final isCurrentUser = member['isCurrentUser'] ?? false;

    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        top: index == 0 ? 8 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Posição no ranking - fora do card
          SizedBox(
            width: 40,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${member['rank']}',
                    style: TextStyle(
                      color: member['rank'] <= 3 ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Card do membro
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: isCurrentUser
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2A2A2A),
                          Color(0xFF1A1A1A),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A1A),
                          Color(0xFF0F0F0F),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCurrentUser ? const Color(0xFF4A90E2).withOpacity(0.3) : Colors.white.withOpacity(0.1),
                  width: isCurrentUser ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  if (isCurrentUser)
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (isCurrentUser) {
                      context.push(AppRouter.profile, extra: _getUserData());
                    } else {
                      context.push(AppRouter.profile, extra: member);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Avatar
                        Hero(
                          tag: 'avatar_${member['id']}',
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  member['badgeColor'],
                                  member['badgeColor'].withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: member['badgeColor'].withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: member['profileImage'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Image.network(
                                      member['profileImage'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      _getInitials(member['name']),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Conteúdo
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      member['name'],
                                      style: TextStyle(
                                        color: isCurrentUser ? const Color(0xFF4A90E2) : Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.3,
                                        fontFamily: 'SF Pro Display',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: member['badgeColor'],
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: member['badgeColor'].withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      member['badge'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (member['position'] != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  member['position'],
                                  style: const TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 12),

                              // Métricas
                              Row(
                                children: [
                                  _buildMetric(
                                    icon: Icons.star,
                                    value: '${member['score']}',
                                    label: 'pontos',
                                    color: const Color(0xFF4A90E2),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: color,
            size: 14,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _getUserData() {
    return {
      'id': 'user_logged',
      'name': 'André Pereira',
      'company': 'Enjoy App',
      'position': 'Fundador',
      'linkedin': 'linkedin.com/in/andrepereira',
      'email': 'andre@enjoyapp.com',
      'phone': '+55 11 99999-9999',
      'instagram': '@andre.enjoyapp',
      'profileImage': '',
      'bio':
          'Empreendedor apaixonado por conectar pessoas e criar oportunidades de negócio. Fundador do Enjoy App, uma plataforma que revoluciona o networking empresarial.',
      'isOnline': true,
      'indicationsCount': 89,
      'businessValue': 150000.0,
      'gamificationPoints': 8750,
      'score': 8750,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'joinDate': DateTime.now().subtract(const Duration(days: 180)),
      'specialties': ['Empreendedorismo', 'Networking', 'Tecnologia', 'Inovação'],
      'achievements': [
        {'title': 'Founder', 'description': 'Criador da plataforma', 'icon': Icons.star},
        {'title': 'Top Connector', 'description': '100+ conexões realizadas', 'icon': Icons.people},
        {'title': 'Business Builder', 'description': 'R\$ 500K+ em negócios', 'icon': Icons.trending_up},
      ],
    };
  }
}
