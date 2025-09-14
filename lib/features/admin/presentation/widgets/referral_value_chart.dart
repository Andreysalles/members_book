import 'package:flutter/material.dart';

class ReferralValueChart extends StatefulWidget {
  const ReferralValueChart({super.key});

  @override
  State<ReferralValueChart> createState() => _ReferralValueChartState();
}

class _ReferralValueChartState extends State<ReferralValueChart> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
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
                    color: const Color(0xFF9C27B0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Color(0xFF9C27B0),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Valor Total de Indicações',
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
                    color: const Color(0xFF9C27B0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'R\$ 2.4M',
                    style: TextStyle(
                      color: Color(0xFF9C27B0),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gráfico de barras customizado
            SizedBox(
              height: 250,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BarChartPainter(
                      animation: _animation.value,
                    ),
                    size: const Size(double.infinity, 250),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Estatísticas do gráfico
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Janeiro', 'R\$ 180K', const Color(0xFF9C27B0)),
                _buildStatItem('Fevereiro', 'R\$ 220K', const Color(0xFF9C27B0)),
                _buildStatItem('Março', 'R\$ 310K', const Color(0xFF9C27B0)),
                _buildStatItem('Abril', 'R\$ 280K', const Color(0xFF9C27B0)),
                _buildStatItem('Maio', 'R\$ 350K', const Color(0xFF9C27B0)),
                _buildStatItem('Junho', 'R\$ 420K', const Color(0xFF9C27B0)),
              ],
            ),
            const SizedBox(height: 20),

            // Resumo financeiro
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF333333),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildFinancialRow('Receita Total', 'R\$ 2.4M', '+23.5%'),
                  const SizedBox(height: 12),
                  _buildFinancialRow('Ticket Médio', 'R\$ 1,950', '+8.2%'),
                  const SizedBox(height: 12),
                  _buildFinancialRow('Crescimento Mensal', '15.2%', '+5.1%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String month, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          month,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialRow(String label, String value, String change) {
    final isPositive = change.startsWith('+');
    final changeColor = isPositive ? const Color(0xFF00C851) : const Color(0xFFFF4444);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontFamily: 'SF Pro Display',
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(width: 8),
            Text(
              change,
              style: TextStyle(
                color: changeColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  final double animation;

  BarChartPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF9C27B0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Dados simulados para o gráfico (valores em milhares)
    final data = [180, 220, 310, 280, 350, 420];
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final barWidth = (size.width - 40) / data.length - 8;

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxValue) * (size.height - 40) * animation;
      final x = 20 + i * (barWidth + 8);
      final y = size.height - 20 - barHeight;

      // Desenhar barra
      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);

      // Gradiente para a barra
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF9C27B0).withOpacity(0.8),
          const Color(0xFF9C27B0).withOpacity(0.4),
        ],
      );

      final gradientPaint = Paint()..shader = gradient.createShader(rect);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        gradientPaint,
      );

      // Borda da barra
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        strokePaint,
      );

      // Valor no topo da barra
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'R\$ ${(data[i] / 1000).toStringAsFixed(0)}K',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x + barWidth / 2 - textPainter.width / 2,
          y - 20,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
