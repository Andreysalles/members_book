import 'package:flutter/material.dart';

class ROIAnalysisCard extends StatefulWidget {
  const ROIAnalysisCard({super.key});

  @override
  State<ROIAnalysisCard> createState() => _ROIAnalysisCardState();
}

class _ROIAnalysisCardState extends State<ROIAnalysisCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
                    color: const Color(0xFF00C851).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF00C851),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Análise de ROI',
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
                    color: const Color(0xFF00C851).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF00C851).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '340%',
                    style: TextStyle(
                      color: Color(0xFF00C851),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gráfico de pizza customizado
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: PieChartPainter(
                        animation: _animation.value,
                      ),
                      size: const Size(200, 200),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Legenda
            Column(
              children: [
                _buildLegendItem(
                  'Investimento Inicial',
                  'R\$ 500K',
                  const Color(0xFF4A90E2),
                  0.15,
                ),
                const SizedBox(height: 12),
                _buildLegendItem(
                  'Retorno Total',
                  'R\$ 1.7M',
                  const Color(0xFF00C851),
                  0.85,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Métricas detalhadas
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
                  _buildMetricRow('ROI Médio por Membro', 'R\$ 2,400', '+12.5%'),
                  const SizedBox(height: 12),
                  _buildMetricRow('Tempo de Retorno', '8.2 meses', '-2.1 meses'),
                  const SizedBox(height: 12),
                  _buildMetricRow('Taxa de Sucesso', '87.3%', '+5.2%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color, double percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, String change) {
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

class PieChartPainter extends CustomPainter {
  final double animation;

  PieChartPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Dados do gráfico
    final data = [
      {'value': 0.15, 'color': const Color(0xFF4A90E2), 'label': 'Investimento'},
      {'value': 0.85, 'color': const Color(0xFF00C851), 'label': 'Retorno'},
    ];

    double startAngle = -90 * (3.14159 / 180); // Começar do topo

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i]['value'] as double) * 2 * 3.14159 * animation;

      final paint = Paint()
        ..color = data[i]['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Desenhar círculo interno
    final innerPaint = Paint()
      ..color = const Color(0xFF0A0A0A)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);

    // Texto central
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'ROI\n340%',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
