import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  // Mock data das conversas
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'Ana Silva',
      'position': 'Gerente de Vendas • Tecnologia',
      'lastMessage': 'Obrigada pela indicação! Vamos conversar sobre o projeto.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 2,
      'isOnline': true,
      'profileImage': '',
      'badge': 'Membro',
      'badgeColor': const Color(0xFF555555),
    },
    {
      'id': '2',
      'name': 'Carlos Mendes',
      'position': 'Fundador • Consultoria',
      'lastMessage': 'Perfeito! Vou enviar a proposta até amanhã.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'unreadCount': 0,
      'isOnline': false,
      'profileImage': '',
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
    },
    {
      'id': '3',
      'name': 'Beatriz Costa',
      'position': 'Diretora de Marketing • Varejo',
      'lastMessage': 'Que ótima oportunidade! Vamos marcar uma reunião.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'unreadCount': 1,
      'isOnline': true,
      'profileImage': '',
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
    },
    {
      'id': '4',
      'name': 'Alexandre Santos',
      'position': 'CEO • Tecnologia',
      'lastMessage': 'Obrigado pela conexão! Vamos conversar em breve.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'isOnline': false,
      'profileImage': '',
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
    },
    {
      'id': '5',
      'name': 'Diana Oliveira',
      'position': 'Head de RH • Recursos Humanos',
      'lastMessage': 'Excelente! Vou analisar a proposta.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unreadCount': 0,
      'isOnline': true,
      'profileImage': '',
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
    },
    {
      'id': '6',
      'name': 'Fernanda Rocha',
      'position': 'Diretora Financeira • Finanças',
      'lastMessage': 'Perfeito! Vamos fechar esse negócio.',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'unreadCount': 0,
      'isOnline': false,
      'profileImage': '',
      'badge': 'Infinity',
      'badgeColor': const Color(0xFFB8860B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _scrollController.addListener(_onScroll);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
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
          _buildAppBar(),
          _buildContent(),
        ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRouter.inbox,
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: const Text(
          'Mensagens',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      flexibleSpace: _buildAppBarContent(),
    );
  }

  Widget _buildAppBarContent() {
    return FlexibleSpaceBar(
      background: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.appBarGradient,
        ),
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título principal
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Mensagens',
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
                          'Suas conversas com membros',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Lista de conversas
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Conversas Recentes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._conversations.map((conversation) => _buildConversationCard(conversation)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversationCard(Map<String, dynamic> conversation) {
    final hasUnread = (conversation['unreadCount'] as int) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: hasUnread
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasUnread ? const Color(0xFF4A90E2).withOpacity(0.3) : Colors.white.withOpacity(0.1),
          width: hasUnread ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(AppRouter.userChat, extra: conversation);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar com status online
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            conversation['badgeColor'],
                            conversation['badgeColor'].withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: conversation['badgeColor'].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: conversation['profileImage'].isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                conversation['profileImage'],
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                _getInitials(conversation['name']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    if (conversation['isOnline'])
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF50C878),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF0A0A0A),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // Conteúdo da conversa
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['name'],
                              style: TextStyle(
                                color: hasUnread ? const Color(0xFF4A90E2) : Colors.white,
                                fontSize: 16,
                                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                                fontFamily: 'SF Pro Display',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(conversation['timestamp']),
                            style: TextStyle(
                              color: hasUnread ? const Color(0xFF4A90E2) : const Color(0xFFAAAAAA),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conversation['position'],
                        style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        conversation['lastMessage'],
                        style: TextStyle(
                          color: hasUnread ? Colors.white : const Color(0xFFAAAAAA),
                          fontSize: 14,
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Badge de não lidas
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A90E2).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${conversation['unreadCount']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
