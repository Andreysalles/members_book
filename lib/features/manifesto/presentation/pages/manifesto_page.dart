import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class ManifestoPage extends StatefulWidget {
  const ManifestoPage({super.key});

  @override
  State<ManifestoPage> createState() => _ManifestoPageState();
}

class _ManifestoPageState extends State<ManifestoPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: CustomScrollView(
        slivers: [
          // App Bar com gradiente
          SliverAppBar(
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.appBarGradient,
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'NOSSO MANIFESTO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            fontFamily: 'SF Pro Display',
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
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      color: const Color(0xFFF5F5F5),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // Manifesto Principal
                            _buildMainManifesto(),

                            const SizedBox(height: 40),

                            // Slogan
                            _buildSlogan(),

                            const SizedBox(height: 40),

                            // Card de Informações
                            _buildInfoCard(),

                            const SizedBox(height: 40),

                            // Footer
                            _buildFooter(),

                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRouter.manifesto,
      ),
    );
  }

  Widget _buildMainManifesto() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saudação
          Text(
            'Caros Membros,',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              fontFamily: 'SF Pro Display',
            ),
          ),

          SizedBox(height: 24),

          // Texto sobre Comunidade Disruption
          Text(
            'Bem-vindos ao mapa vivo da nossa comunidade. Este material é o reflexo da Comunidade Disruption: empresários que constroem, lideram e transformam.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.3,
              fontFamily: 'SF Pro Display',
            ),
          ),

          SizedBox(height: 16),

          Text(
            'Aqui você encontra quem está ativo, conectado e pronto para gerar valor. Use este livro como ponto de partida para criar relacionamentos estratégicos, ampliar sua rede e encontrar sinergias reais de negócios.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.3,
              fontFamily: 'SF Pro Display',
            ),
          ),

          SizedBox(height: 16),

          Text(
            'A Comunidade Disruption existe para acelerar quem já faz a diferença.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.3,
              fontFamily: 'SF Pro Display',
            ),
          ),

          SizedBox(height: 32),

          // Assinatura
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Wander Miranda',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'CEO Enjoy',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    letterSpacing: 0.2,
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

  Widget _buildSlogan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Text(
        'Juntos, somos Enjoy.',
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontFamily: 'SF Pro Display',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ícone de check com linhas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 2,
                height: 2,
                color: const Color(0xFFD4AF37),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 2,
                height: 2,
                color: const Color(0xFFD4AF37),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Texto informativo
          const Text(
            'Este Members Book é atualizado mensalmente e apresenta os membros ativos da comunidade. Para garantir a melhor experiência, recomendamos manter seus dados sempre atualizados junto à Enjoy.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 15,
              height: 1.5,
              letterSpacing: 0.2,
              fontFamily: 'SF Pro Display',
            ),
            textAlign: TextAlign.left,
          ),

          const SizedBox(height: 16),

          const Text(
            'O material é voltado exclusivamente para networking interno, preservando a confidencialidade das informações e imagens aqui reunidas.',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.2,
              fontFamily: 'SF Pro Display',
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Text(
            'COMUNIDADE',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFD4AF37),
                Color(0xFF4A90E2),
              ],
            ).createShader(bounds),
            child: const Text(
              'DISRUPTION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
