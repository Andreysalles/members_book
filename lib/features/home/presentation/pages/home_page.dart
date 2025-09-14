import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _filteredMembers = [];
  bool _isCollapsed = false;

  // Nome do usuário logado (mock - em produção viria do estado/API)
  final String _userName = 'André Pereira';

  // Mock data baseado na imagem
  final List<Map<String, dynamic>> _allMembers = [
    {
      'id': '1',
      'name': 'Ana Silva',
      'position': 'Gerente de Vendas • Tecnologia',
      'description': 'Especialista em vendas B2B com foco em soluções tecnológicas para empresas de médio porte.',
      'indicationsCount': 45,
      'score': 3250,
      'badge': 'Membro',
      'badgeColor': const Color(0xFF555555),
      'profileImage': '',
    },
    {
      'id': '2',
      'name': 'Alexandre Santos',
      'position': 'CEO • Tecnologia',
      'description': 'Fundador e CEO de startup de IA, mentor de empreendedores e palestrante internacional.',
      'indicationsCount': 127,
      'score': 9850,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
    },
    {
      'id': '3',
      'name': 'Beatriz Costa',
      'position': 'Diretora de Marketing • Varejo',
      'description': 'Especialista em marketing digital e growth hacking, com experiência em e-commerce.',
      'indicationsCount': 89,
      'score': 7420,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
    },
    {
      'id': '4',
      'name': 'Carlos Mendes',
      'position': 'Fundador • Consultoria',
      'description': 'Consultor empresarial com 15 anos de experiência em transformação digital.',
      'indicationsCount': 203,
      'score': 12100,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'profileImage': '',
    },
    {
      'id': '5',
      'name': 'Diana Oliveira',
      'position': 'Head de RH • Recursos Humanos',
      'description': 'Especialista em gestão de talentos e cultura organizacional em empresas de tecnologia.',
      'indicationsCount': 67,
      'score': 5890,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'profileImage': '',
    },
    {
      'id': '6',
      'name': 'Eduardo Lima',
      'position': 'Desenvolvedor Senior • Tecnologia',
      'description': 'Full-stack developer especializado em React, Node.js e arquiteturas de microsserviços.',
      'indicationsCount': 34,
      'score': 2780,
      'badge': 'Membro',
      'badgeColor': const Color(0xFF555555),
      'profileImage': '',
    },
    {
      'id': '7',
      'name': 'Fernanda Rocha',
      'position': 'Diretora Financeira • Finanças',
      'description': 'CFO com expertise em planejamento estratégico e gestão de investimentos.',
      'indicationsCount': 156,
      'score': 11200,
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
      'profileImage': '',
    },
    {
      'id': '8',
      'name': 'Gabriel Torres',
      'position': 'Product Manager • Produto',
      'description': 'Especialista em desenvolvimento de produtos digitais e metodologias ágeis.',
      'indicationsCount': 78,
      'score': 6340,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'profileImage': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredMembers = List.from(_allMembers);
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
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

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = List.from(_allMembers);
      } else {
        _filteredMembers = _allMembers.where((member) {
          final name = member['name'].toString().toLowerCase();
          final position = member['position']?.toString().toLowerCase() ?? '';
          final description = member['description']?.toString().toLowerCase() ?? '';

          return name.contains(query) || position.contains(query) || description.contains(query);
        }).toList();
      }
    });
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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(AppRouter.profile, extra: _getUserData());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF4A90E2),
                              Color(0xFF357ABD),
                              Color(0xFF2E5B8A),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4A90E2).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'SF Pro Display',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar com status
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.push(AppRouter.profile, extra: _getUserData());
                                },
                                child: Container(
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
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.backgroundColor, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Título com saudação
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: const TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Chat com badge
                          GestureDetector(
                            onTap: () {
                              context.push(AppRouter.inbox);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF1A1A1A),
                                        Color(0xFF2A2A2A),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF4A90E2).withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Color(0xFF4A90E2),
                                    size: 22,
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4A90E2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
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

            // Conteúdo principal
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Seção de busca melhorada
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Membros',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            Text(
                              '${_filteredMembers.length} encontrados',
                              style: const TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Search bar premium
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Buscar por nome, cargo ou área...',
                              hintStyle: TextStyle(
                                color: AppTheme.textSecondary.withOpacity(0.7),
                                fontSize: 16,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.search,
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppTheme.textSecondary,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4A90E2),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => FocusScope.of(context).unfocus(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Lista de membros otimizada
            _filteredMembers.isEmpty && _searchController.text.isNotEmpty
                ? SliverFillRemaining(
                    child: _buildEmptyState(),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final member = _filteredMembers[index];
                          return _buildMemberCard(member, index);
                        },
                        childCount: _filteredMembers.length,
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
        currentRoute: AppRouter.home,
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia!';
    if (hour < 18) return 'Boa tarde!';
    return 'Boa noite!';
  }

  Map<String, dynamic> _getUserData() {
    return {
      'id': 'user_logged',
      'name': _userName,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhum membro encontrado',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar por outro termo ou\nverifique a ortografia',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              FocusScope.of(context).unfocus();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Limpar busca'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        top: index == 0 ? 8 : 0,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0F0F0F),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(AppRouter.profile, extra: member);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar melhorado
                Hero(
                  tag: 'avatar_${member['id']}',
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          _getBadgeColor(member['badge']),
                          _getBadgeColor(member['badge']).withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getBadgeColor(member['badge']).withOpacity(0.3),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getBadgeColor(member['badge']),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _getBadgeColor(member['badge']).withOpacity(0.3),
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
                            value: '${member['score'] ?? member['gamificationPoints'] ?? 0}',
                            label: 'pontos',
                            color: const Color(0xFF4A90E2),
                          ),
                          const SizedBox(width: 20),
                          _buildMetric(
                            icon: Icons.trending_up,
                            value: '${member['indicationsCount'] ?? 0}',
                            label: 'indicações',
                            color: const Color(0xFF50C878),
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
                fontFamily: 'SF Pro Display',
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getBadgeColor(String? badge) {
    switch (badge?.toLowerCase()) {
      case 'eternity':
        return const Color(0xFF4682B4); // Azul diamante
      case 'infinity':
        return const Color(0xFFB8860B); // Dourado
      case 'membro':
      default:
        return const Color(0xFF555555); // Cinza
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
