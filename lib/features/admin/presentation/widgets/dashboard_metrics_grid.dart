import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardMetricsGrid extends StatelessWidget {
  const DashboardMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.2 : 1.1,
      children: [
        _buildMetricCard(
          title: 'Total de Membros',
          value: '2,847',
          change: '+12.5%',
          changeType: MetricChangeType.positive,
          icon: Icons.people,
          color: AppTheme.accentColor,
          subtitle: 'vs mês anterior',
        ),
        _buildMetricCard(
          title: 'ROI da Comunidade',
          value: '340%',
          change: '+8.2%',
          changeType: MetricChangeType.positive,
          icon: Icons.trending_up,
          color: const Color(0xFF00C851),
          subtitle: 'retorno médio',
        ),
        _buildMetricCard(
          title: 'Indicações',
          value: '1,234',
          change: '+23.1%',
          changeType: MetricChangeType.positive,
          icon: Icons.share,
          color: const Color(0xFFFF6B35),
          subtitle: 'este mês',
        ),
        _buildMetricCard(
          title: 'Valor Total',
          value: 'R\$ 2.4M',
          change: '+15.7%',
          changeType: MetricChangeType.positive,
          icon: Icons.attach_money,
          color: const Color(0xFF9C27B0),
          subtitle: 'em indicações',
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required MetricChangeType changeType,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com ícone e mudança
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                _buildChangeIndicator(change, changeType),
              ],
            ),
            const SizedBox(height: 16),

            // Valor principal
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 4),

            // Título
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 4),

            // Subtítulo
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 12,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeIndicator(String change, MetricChangeType changeType) {
    Color color;
    IconData icon;

    switch (changeType) {
      case MetricChangeType.positive:
        color = const Color(0xFF00C851);
        icon = Icons.trending_up;
        break;
      case MetricChangeType.negative:
        color = const Color(0xFFFF4444);
        icon = Icons.trending_down;
        break;
      case MetricChangeType.neutral:
        color = const Color(0xFFAAAAAA);
        icon = Icons.trending_flat;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum MetricChangeType {
  positive,
  negative,
  neutral,
}
