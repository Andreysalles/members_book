import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic>? member;
  final bool isAssistant;

  const ChatPage({
    super.key,
    this.member,
    this.isAssistant = false,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _typingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  int _currentStep = 0;

  final List<AssistantStep> _registrationSteps = [
    AssistantStep(
      message:
          "Olá! Bem-vindo à Comunidade Disruption! 👋\n\nSou a Enjoy, sua assistente virtual. Vou te ajudar a completar seu cadastro de forma rápida e personalizada.",
      type: MessageType.assistant,
      options: ["Vamos começar!", "Preciso de ajuda"],
    ),
    AssistantStep(
      message: "Perfeito! Vamos começar com suas informações básicas.\n\nQual é o seu nome completo?",
      type: MessageType.assistant,
      inputType: InputType.text,
      field: "name",
    ),
    AssistantStep(
      message: "Ótimo, {name}! 😊\n\nAgora me conte qual é a sua empresa e o cargo que você ocupa?",
      type: MessageType.assistant,
      inputType: InputType.text,
      field: "company",
    ),
    AssistantStep(
      message: "Excelente! 🚀\n\nQual é o seu principal desafio como empresário atualmente?",
      type: MessageType.assistant,
      inputType: InputType.options,
      options: [
        "Crescimento de vendas",
        "Gestão de equipe",
        "Inovação e tecnologia",
        "Expansão de mercado",
        "Eficiência operacional"
      ],
      field: "challenge",
    ),
    AssistantStep(
      message: "Entendi! 💡\n\nE qual é o seu principal objetivo para os próximos 12 meses?",
      type: MessageType.assistant,
      inputType: InputType.text,
      field: "goal",
    ),
    AssistantStep(
      message:
          "Perfeito! 🎯\n\nPara finalizar, me conte um pouco sobre sua experiência como empresário (anos de atuação):",
      type: MessageType.assistant,
      inputType: InputType.options,
      options: ["Menos de 2 anos", "2-5 anos", "5-10 anos", "10-20 anos", "Mais de 20 anos"],
      field: "experience",
    ),
    AssistantStep(
      message:
          "Fantástico! 🎉\n\nSeu cadastro foi concluído com sucesso! Agora você faz parte oficialmente da Comunidade Disruption.\n\nVou te conectar com outros empresários que compartilham objetivos similares e podem te ajudar em sua jornada.",
      type: MessageType.assistant,
      options: ["Explorar comunidade", "Ver perfil"],
    ),
  ];

  final Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startConversation();
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

  void _startConversation() {
    if (widget.isAssistant) {
      _addMessage(_registrationSteps[0].message, MessageType.assistant);
    }
  }

  void _addMessage(String text, MessageType type, {List<String>? options}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        type: type,
        timestamp: DateTime.now(),
        options: options,
      ));
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

    if (widget.isAssistant && _currentStep < _registrationSteps.length - 1) {
      _handleAssistantResponse(text);
    }
  }

  void _handleAssistantResponse(String userInput) {
    setState(() {
      _isTyping = true;
    });

    _typingController.forward().then((_) {
      setState(() {
        _isTyping = false;
        _currentStep++;
      });

      if (_currentStep < _registrationSteps.length) {
        final step = _registrationSteps[_currentStep];

        // Salvar dados do usuário
        if (step.field != null) {
          _userData[step.field!] = userInput;
        }

        // Personalizar mensagem com dados do usuário
        String personalizedMessage = step.message;
        if (step.field == "company" && _userData.containsKey("name")) {
          personalizedMessage = step.message.replaceAll("{name}", _userData["name"]);
        }

        _addMessage(personalizedMessage, step.type, options: step.options);
      }
    });
  }

  void _selectOption(String option) {
    _sendMessage(option);
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
            _buildAppBar(),
            _buildChatContent(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRouter.chatAssistant,
      ),
      bottomSheet: _buildMessageInput(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: _buildBackButton(),
      flexibleSpace: _buildAppBarContent(),
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

  Widget _buildAppBarContent() {
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
                    _buildAssistantAvatar(),
                    const SizedBox(width: 12),
                    _buildAssistantInfo(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD4AF37),
            Color(0xFF4A90E2),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildAssistantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enjoy Assistant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
          ),
        ),
        Text(
          widget.isAssistant ? 'Cadastro por conversa' : 'Assistente virtual',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
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
          if (message.type == MessageType.assistant) ...[
            _buildMessageAvatar(isAssistant: true),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: _buildMessageContent(message),
          ),
          if (message.type == MessageType.user) ...[
            const SizedBox(width: 12),
            _buildMessageAvatar(isAssistant: false),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageAvatar({required bool isAssistant}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: isAssistant
            ? const LinearGradient(
                colors: [
                  Color(0xFFD4AF37),
                  Color(0xFF4A90E2),
                ],
              )
            : null,
        color: isAssistant ? null : const Color(0xFF4A90E2),
        shape: BoxShape.circle,
        boxShadow: isAssistant
            ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Icon(
        isAssistant ? Icons.smart_toy : Icons.person,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
              fontFamily: 'SF Pro Display',
            ),
          ),
          if (message.options != null) ...[
            const SizedBox(height: 12),
            ...message.options!.map((option) => _buildOptionButton(option)),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectOption(option),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              option,
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildMessageAvatar(isAssistant: true),
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
}

class ChatMessage {
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final List<String>? options;

  ChatMessage({
    required this.text,
    required this.type,
    required this.timestamp,
    this.options,
  });
}

class AssistantStep {
  final String message;
  final MessageType type;
  final List<String>? options;
  final InputType? inputType;
  final String? field;

  AssistantStep({
    required this.message,
    required this.type,
    this.options,
    this.inputType,
    this.field,
  });
}

enum MessageType { user, assistant }

enum InputType { text, options }
