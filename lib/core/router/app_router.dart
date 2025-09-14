import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/inbox_page.dart';
import '../../features/chat/presentation/pages/user_chat_page.dart';
import '../../features/gamification/presentation/pages/gamification_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/manifesto/presentation/pages/manifesto_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static const String home = '/';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String inbox = '/inbox';
  static const String userChat = '/chat/user';
  static const String chatAssistant = '/chat/assistant';
  static const String gamification = '/gamification';
  static const String manifesto = '/manifesto';
  static const String admin = '/admin';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      // Rota principal - Home
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
          );
        },
      ),

      // Rota de perfil com parâmetro opcional para dados do membro
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) {
          // Recebe dados do membro via extra
          final memberData = state.extra as Map<String, dynamic>?;
          return ProfilePage(member: memberData);
        },
      ),

      // Rota de chat com parâmetro opcional para dados do membro
      GoRoute(
        path: chat,
        name: 'chat',
        builder: (context, state) {
          // Recebe dados do membro via extra
          final memberData = state.extra as Map<String, dynamic>?;
          return ChatPage(member: memberData);
        },
      ),

      // Rota de inbox (lista de mensagens)
      GoRoute(
        path: inbox,
        name: 'inbox',
        builder: (context, state) {
          return const InboxPage();
        },
      ),

      // Rota de chat entre usuários
      GoRoute(
        path: userChat,
        name: 'userChat',
        builder: (context, state) {
          // Recebe dados do membro via extra
          final memberData = state.extra as Map<String, dynamic>?;
          return UserChatPage(member: memberData);
        },
      ),

      // Rota de chat com assistente para cadastro
      GoRoute(
        path: chatAssistant,
        name: 'chatAssistant',
        builder: (context, state) {
          return const ChatPage(isAssistant: true);
        },
      ),

      // Rota de gamificação
      GoRoute(
        path: gamification,
        name: 'gamification',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const GamificationPage(),
          );
        },
      ),

      // Rota do manifesto
      GoRoute(
        path: manifesto,
        name: 'manifesto',
        builder: (context, state) => const ManifestoPage(),
      ),

      // Rota de administração
      GoRoute(
        path: admin,
        name: 'admin',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const AdminDashboardPage(),
          );
        },
      ),
    ],

    // Tratamento de erros de rota
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Página não encontrada',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A rota "${state.uri}" não existe.',
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 16,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go(home),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: const Text(
                      'Voltar ao Início',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
