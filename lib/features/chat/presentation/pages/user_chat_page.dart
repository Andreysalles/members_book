import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class UserChatPage extends StatefulWidget {
  final Map<String, dynamic>? member;

  const UserChatPage({super.key, this.member});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _typingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadInitialMessages();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    _typingController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    // Carregar mensagens iniciais do chat
    _addMessage("Olá! Como posso te ajudar hoje?", MessageType.other);
    _addMessage(
        "Oi! Tudo bem? Vi seu perfil e fiquei interessado em conhecer mais sobre seu trabalho.", MessageType.user);
  }

  void _addMessage(String text, MessageType type) {
    setState(() {
      _messages.add(ChatMessage(text: text, type: type));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _addMessage(text, MessageType.user);
    _messageController.clear();

    // Simular resposta do outro usuário
    setState(() {
      _isTyping = true;
    });

    _typingController.forward().then((_) {
      setState(() {
        _isTyping = false;
      });
      _addMessage("Obrigado pela mensagem! Vou responder em breve.", MessageType.other);
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberData = widget.member ?? _getMockMemberData();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: CustomScrollView(
        slivers: [
          _buildAppBar(memberData),
          _buildChatContent(),
        ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRouter.chat,
      ),
      bottomSheet: _buildMessageInput(),
    );
  }

  Widget _buildAppBar(Map<String, dynamic> memberData) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: _buildBackButton(),
      flexibleSpace: _buildAppBarContent(memberData),
    );
  }

  Widget _buildBackButton() {
    return Container(
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
    );
  }

  Widget _buildAppBarContent(Map<String, dynamic> memberData) {
    return FlexibleSpaceBar(
      background: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.appBarGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildUserAvatar(memberData),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildUserInfo(memberData),
                    ),
                    const SizedBox(width: 8),
                    _buildOnlineStatus(memberData),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(Map<String, dynamic> memberData) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: memberData['isOnline'] == true ? const Color(0xFF50C878) : const Color(0xFFAAAAAA),
          width: 2,
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
        radius: 18,
        backgroundColor: const Color(0xFF2A2A2A),
        backgroundImage:
            (memberData['profileImage'] ?? '').isNotEmpty ? NetworkImage(memberData['profileImage']) : null,
        child: (memberData['profileImage'] ?? '').isEmpty
            ? Text(
                _getInitials(memberData['name'] ?? 'NN'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'SF Pro Display',
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> memberData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          memberData['name'] ?? 'Usuário',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          memberData['company'] ?? 'Empresa não informada',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontFamily: 'SF Pro Display',
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildOnlineStatus(Map<String, dynamic> memberData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: memberData['isOnline'] == true
            ? const Color(0xFF50C878).withOpacity(0.2)
            : const Color(0xFFAAAAAA).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: memberData['isOnline'] == true ? const Color(0xFF50C878) : const Color(0xFFAAAAAA),
          width: 1,
        ),
      ),
      child: Text(
        memberData['isOnline'] == true ? 'Online' : 'Offline',
        style: TextStyle(
          color: memberData['isOnline'] == true ? const Color(0xFF50C878) : const Color(0xFFAAAAAA),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length && _isTyping) {
                            return _buildTypingIndicator();
                          }
                          return _buildMessageBubble(_messages[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.type == MessageType.user ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.type == MessageType.other) ...[
            _buildMessageAvatar(isUser: false),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: _buildMessageContent(message),
          ),
          if (message.type == MessageType.user) ...[
            const SizedBox(width: 12),
            _buildMessageAvatar(isUser: true),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageAvatar({required bool isUser}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF4A90E2) : const Color(0xFF2A2A2A),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isUser ? const Color(0xFF4A90E2) : Colors.black).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person : Icons.business,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: message.type == MessageType.user
            ? const LinearGradient(
                colors: [
                  Color(0xFF4A90E2),
                  Color(0xFF357ABD),
                ],
              )
            : const LinearGradient(
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0F0F0F),
                ],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: message.type == MessageType.user
              ? const Color(0xFF4A90E2).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.5,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildMessageAvatar(isUser: false),
          const SizedBox(width: 12),
          _buildTypingBubble(),
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => _buildTypingDot(index)),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _typingController,
      builder: (context, child) {
        final delay = index * 0.2;
        final animationValue = (_typingController.value - delay).clamp(0.0, 1.0);
        final opacity = (1.0 - animationValue) * 0.5 + 0.5;

        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A1A),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(),
          ),
          const SizedBox(width: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4A90E2).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _messageController,
        focusNode: _messageFocusNode,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'SF Pro Display',
        ),
        decoration: const InputDecoration(
          hintText: 'Digite sua mensagem...',
          hintStyle: TextStyle(
            color: Color(0xFFAAAAAA),
            fontSize: 15,
            fontFamily: 'SF Pro Display',
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: _sendMessage,
        textInputAction: TextInputAction.send,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD4AF37),
            Color(0xFF4A90E2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _sendMessage(_messageController.text),
          borderRadius: BorderRadius.circular(12),
          child: const Icon(
            Icons.send_rounded,
            color: Colors.white,
            size: 18,
          ),
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
      'profileImage': '',
      'isOnline': true,
    };
  }
}

class ChatMessage {
  final String text;
  final MessageType type;

  ChatMessage({required this.text, required this.type});
}

enum MessageType {
  user,
  other,
}
