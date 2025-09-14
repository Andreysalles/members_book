import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/dashboard_metrics_grid.dart';
import '../widgets/members_activity_chart.dart';
import '../widgets/referral_value_chart.dart';
import '../widgets/roi_analysis_card.dart';
import '../widgets/top_active_members.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // App Bar personalizada para admin
              AdminAppBar(
                onBackPressed: () => context.go(AppRouter.home),
              ),

              // Conteúdo principal
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título e subtítulo
                      _buildHeader(),
                      const SizedBox(height: 32),

                      // Abas de navegação
                      _buildTabNavigation(),
                      const SizedBox(height: 24),

                      // Conteúdo baseado na aba selecionada
                      _buildTabContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.accentColor, AppTheme.primaryColor],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Painel Administrativo',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Visão geral da comunidade e métricas de performance',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return const Column(
      children: [
        // Gráfico de atividade dos membros
        MembersActivityChart(),
        SizedBox(height: 24),

        // Análise de ROI
        ROIAnalysisCard(),
        SizedBox(height: 24),

        // Membro mais ativos
        TopActiveMembers(),
        SizedBox(height: 24),

        // Gráfico de valor de indicações
        ReferralValueChart(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return const Column(
      children: [
        // Primeira linha - 2 colunas
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MembersActivityChart(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ROIAnalysisCard(),
            ),
          ],
        ),
        SizedBox(height: 24),

        // Segunda linha - 2 colunas
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TopActiveMembers(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ReferralValueChart(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return const Column(
      children: [
        // Primeira linha - 3 colunas
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: MembersActivityChart(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ROIAnalysisCard(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TopActiveMembers(),
            ),
          ],
        ),
        SizedBox(height: 24),

        // Segunda linha - gráfico de valor de indicações
        ReferralValueChart(),
      ],
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Dashboard', Icons.dashboard),
          _buildTabItem(1, 'Pedidos', Icons.person_add),
          _buildTabItem(2, 'Convites', Icons.link),
          _buildTabItem(3, 'Membros', Icons.people),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title, IconData icon) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildMemberRequestsContent();
      case 2:
        return _buildInviteLinksContent();
      case 3:
        return _buildMembersManagementContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Column(
      children: [
        // Grid de métricas principais
        const DashboardMetricsGrid(),
        const SizedBox(height: 32),

        // Layout responsivo para gráficos
        if (isMobile) ...[
          // Layout mobile - coluna única
          _buildMobileLayout(),
        ] else if (isTablet) ...[
          // Layout tablet - 2 colunas
          _buildTabletLayout(),
        ] else ...[
          // Layout desktop - 3 colunas
          _buildDesktopLayout(),
        ],
      ],
    );
  }

  Widget _buildMemberRequestsContent() {
    return Column(
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
                Icons.person_add,
                color: Color(0xFFFF6B35),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Pedidos de Cadastro',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                '12 pendentes',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Lista de pedidos
        _buildMemberRequestsList(),
      ],
    );
  }

  Widget _buildInviteLinksContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.link,
                color: Color(0xFF9C27B0),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Links de Convite',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 24),

        // Lista de links ativos
        _buildActiveInviteLinks(),
      ],
    );
  }

  Widget _buildMembersManagementContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.people,
                color: AppTheme.accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Gerenciar Membros',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                '2,847 membros',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Lista de membros
        _buildMembersList(),
      ],
    );
  }

  Widget _buildMemberRequestsList() {
    // Mock data para pedidos
    final requests = [
      {
        'name': 'João Silva',
        'email': 'joao@empresa.com',
        'company': 'TechCorp',
        'position': 'Desenvolvedor Senior',
        'status': 'pending',
        'date': '2024-01-15',
      },
      {
        'name': 'Maria Santos',
        'email': 'maria@startup.com',
        'company': 'StartupX',
        'position': 'Product Manager',
        'status': 'pending',
        'date': '2024-01-14',
      },
      {
        'name': 'Pedro Costa',
        'email': 'pedro@consultoria.com',
        'company': 'Consultoria ABC',
        'position': 'Consultor',
        'status': 'pending',
        'date': '2024-01-13',
      },
    ];

    return Column(
      children: requests.map((request) => _buildRequestCard(request)).toList(),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceColor,
            AppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentColor, AppTheme.primaryColor],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                request['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['name'],
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request['position'] + ' • ' + request['company'],
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request['email'],
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
          ),

          // Ações
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _approveRequest(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C851),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Aprovar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _rejectRequest(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Rejeitar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveInviteLinks() {
    // Mock data para links ativos
    final links = [
      {
        'name': 'Convite VIP',
        'link': 'https://app.enjoy.com/invite/vip456',
        'uses': 12,
        'maxUses': 50,
        'expires': '2024-03-01',
        'created': '2024-01-15',
      },
      {
        'name': 'Convite Corporativo',
        'link': 'https://app.enjoy.com/invite/corp789',
        'uses': 8,
        'maxUses': 25,
        'expires': '2024-02-28',
        'created': '2024-01-20',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Links Ativos',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => _buildInviteLinkCard(link)),
      ],
    );
  }

  Widget _buildInviteLinkCard(Map<String, dynamic> link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                link['name'],
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const Spacer(),
              Text(
                '${link['uses']}/${link['maxUses']} usos',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: AppTheme.textLight,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                'Expira em: ${link['expires']}',
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 11,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const Spacer(),
              Text(
                'Criado: ${link['created']}',
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 11,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  link['link'],
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _copyToClipboard(link['link']),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.copy,
                    color: AppTheme.accentColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    // Mock data para membros
    final members = [
      {
        'name': 'Ana Silva',
        'email': 'ana@techcorp.com',
        'company': 'TechCorp',
        'position': 'CEO',
        'status': 'active',
        'joinDate': '2023-06-15',
        'indications': 45,
        'score': 3250,
      },
      {
        'name': 'Carlos Mendes',
        'email': 'carlos@startupx.com',
        'company': 'StartupX',
        'position': 'CTO',
        'status': 'active',
        'joinDate': '2023-08-22',
        'indications': 127,
        'score': 9850,
      },
      {
        'name': 'Marina Costa',
        'email': 'marina@varejo.com',
        'company': 'Varejo Plus',
        'position': 'Diretora de Marketing',
        'status': 'active',
        'joinDate': '2023-09-10',
        'indications': 89,
        'score': 7420,
      },
      {
        'name': 'Pedro Santos',
        'email': 'pedro@consultoria.com',
        'company': 'Consultoria ABC',
        'position': 'Consultor Senior',
        'status': 'inactive',
        'joinDate': '2023-05-03',
        'indications': 203,
        'score': 12100,
      },
    ];

    return Column(
      children: members.map((member) => _buildMemberCard(member)).toList(),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final isActive = member['status'] == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceColor,
            AppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppTheme.accentColor.withOpacity(0.2) : AppTheme.textLight.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentColor, AppTheme.primaryColor],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member['name'],
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF00C851).withOpacity(0.1)
                            : const Color(0xFFFF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive ? const Color(0xFF00C851) : const Color(0xFFFF4444),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        isActive ? 'Ativo' : 'Inativo',
                        style: TextStyle(
                          color: isActive ? const Color(0xFF00C851) : const Color(0xFFFF4444),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  member['position'] + ' • ' + member['company'],
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['email'],
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMemberMetric('Indicações', '${member['indications']}'),
                    const SizedBox(width: 16),
                    _buildMemberMetric('Score', '${member['score']}'),
                    const SizedBox(width: 16),
                    _buildMemberMetric('Membro desde', member['joinDate']),
                  ],
                ),
              ],
            ),
          ),

          // Ações
          Row(
            children: [
              GestureDetector(
                onTap: () => _editMember(member),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.accentColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppTheme.accentColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _deleteMember(member),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFF4444).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Color(0xFFFF4444),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 10,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }

  void _generateInviteLink() {
    // Implementar geração de link
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link de convite gerado com sucesso!'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }

  void _approveRequest(Map<String, dynamic> request) {
    // Implementar aprovação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido de ${request['name']} aprovado!'),
        backgroundColor: const Color(0xFF00C851),
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> request) {
    // Implementar rejeição
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido de ${request['name']} rejeitado.'),
        backgroundColor: const Color(0xFFFF4444),
      ),
    );
  }

  void _copyToClipboard(String text) {
    // Implementar cópia para clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copiado para a área de transferência!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _editMember(Map<String, dynamic> member) {
    // Implementar edição de membro
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Editar Membro',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
        content: Text(
          'Editar informações de ${member['name']}',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontFamily: 'SF Pro Display',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member['name']} editado com sucesso!'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _deleteMember(Map<String, dynamic> member) {
    // Implementar exclusão de membro
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Excluir Membro',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir ${member['name']}? Esta ação não pode ser desfeita.',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontFamily: 'SF Pro Display',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member['name']} excluído com sucesso!'),
                  backgroundColor: const Color(0xFFFF4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
