import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_bio_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_stats.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? member;

  const ProfilePage({super.key, this.member});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

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
    const double expandedHeight = 240.0;
    const double collapsedHeight = kToolbarHeight;

    final bool isCollapsed =
        _scrollController.hasClients && _scrollController.offset > (expandedHeight - collapsedHeight);

    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se não receber dados, usar dados mock
    final memberData = widget.member ?? _getMockMemberData();

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
              expandedHeight: 240,
              pinned: true,
              backgroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              title: AnimatedOpacity(
                opacity: _isCollapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
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
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        backgroundImage: (memberData['profileImage'] ?? '').isNotEmpty
                            ? NetworkImage(memberData['profileImage'])
                            : null,
                        child: (memberData['profileImage'] ?? '').isEmpty
                            ? Text(
                                _getInitials(memberData['name'] ?? 'NN'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: 'SF Pro Display',
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        memberData['name'] ?? 'Nome não informado',
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
                  child: ProfileHeader(member: memberData),
                ),
              ),
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Conteúdo do perfil
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Estatísticas
                  ProfileStats(member: memberData),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Biografia
                  ProfileBioSection(member: memberData),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Ações rápidas
                  ProfileActions(member: memberData),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Informações detalhadas
                  ProfileInfoSection(member: memberData),

                  const Spacer(),
                  const SizedBox(height: AppConstants.paddingXLarge),
                ],
              ),
            ),
          ],
        ),
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

  Map<String, dynamic> _getMockMemberData() {
    return {
      'id': '1',
      'name': 'Ana Silva',
      'company': 'Tech Solutions',
      'position': 'CEO',
      'linkedin': 'linkedin.com/in/anasilva',
      'email': 'ana.silva@techsolutions.com',
      'phone': '+55 11 99999-9999',
      'instagram': '@ana.silva.tech',
      'profileImage': '',
      'bio':
          'Empreendedora apaixonada por tecnologia e inovação. Com mais de 15 anos de experiência no mercado, especializada em transformação digital e liderança de equipes.',
      'isOnline': true,
      'indicationsCount': 15,
      'businessValue': 25000.0,
      'gamificationPoints': 850,
      'score': 8750,
      'badge': 'Eternity',
      'badgeColor': const Color(0xFF4682B4),
      'joinDate': DateTime.now().subtract(const Duration(days: 365)),
      'specialties': ['Tecnologia', 'Inovação', 'Liderança', 'Transformação Digital'],
      'achievements': [
        {'title': 'Top Networker', 'description': '10+ indicações no mês', 'icon': Icons.trending_up},
        {'title': 'Business Closer', 'description': 'R\$ 50K+ em negócios', 'icon': Icons.attach_money},
        {'title': 'Community Leader', 'description': 'Membro há 1+ ano', 'icon': Icons.emoji_events},
      ],
    };
  }
}
