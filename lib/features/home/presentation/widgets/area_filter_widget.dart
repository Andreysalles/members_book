import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AreaFilterWidget extends StatefulWidget {
  final List<String> selectedAreas;
  final Function(List<String>) onAreasChanged;
  final Map<String, int> areaCounts;

  const AreaFilterWidget({
    super.key,
    required this.selectedAreas,
    required this.onAreasChanged,
    required this.areaCounts,
  });

  @override
  State<AreaFilterWidget> createState() => _AreaFilterWidgetState();
}

class _AreaFilterWidgetState extends State<AreaFilterWidget> {
  static const List<String> _areas = [
    'ADVOCACIA',
    'ARQUITETURA',
    'COMÉRCIO',
    'COMEX',
    'CONSTRUTORA & INCORPORADORA',
    'CONSULTORIA',
    'CONTÁBIL',
    'EDUCAÇÃO',
    'ENGENHARIA',
    'EVENTOS & PRODUÇÕES',
    'FINANÇAS & INVESTIMENTOS',
    'FOOD',
    'FRANQUIAS',
    'IMOBILIÁRIO',
    'LICITAÇÃO',
    'LOGÍSTICA & TRANSPORTE',
    'MARKETING',
    'RECURSOS HUMANOS',
    'SAÚDE',
    'SEGUROS',
    'TECNOLOGIA',
    'VEÍCULOS',
  ];

  @override
  Widget build(BuildContext context) {
    // Ordenar áreas por popularidade (mais membros primeiro)
    final sortedAreas = _areas.where((area) => widget.areaCounts[area] != null && widget.areaCounts[area]! > 0).toList()
      ..sort((a, b) => (widget.areaCounts[b] ?? 0).compareTo(widget.areaCounts[a] ?? 0));

    // Adicionar áreas sem membros no final
    final areasWithoutMembers =
        _areas.where((area) => widget.areaCounts[area] == null || widget.areaCounts[area] == 0).toList();
    sortedAreas.addAll(areasWithoutMembers);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filtrar por Área',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              if (widget.selectedAreas.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4A90E2).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${widget.selectedAreas.length} selecionada${widget.selectedAreas.length > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF4A90E2),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    widget.onAreasChanged([]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.textSecondary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.clear,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Limpar',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortedAreas.map((area) => _buildAreaChip(area)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaChip(String area) {
    final isSelected = widget.selectedAreas.contains(area);
    final memberCount = widget.areaCounts[area] ?? 0;
    final hasMembers = memberCount > 0;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            widget.selectedAreas.remove(area);
          } else {
            widget.selectedAreas.add(area);
          }
        });
        widget.onAreasChanged(List.from(widget.selectedAreas));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A90E2).withOpacity(0.2)
              : hasMembers
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A90E2)
                : hasMembers
                    ? const Color(0xFFD4AF37).withOpacity(0.3)
                    : AppTheme.textSecondary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              area,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? const Color(0xFF4A90E2)
                        : hasMembers
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
            if (hasMembers) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF4A90E2).withOpacity(0.3) : const Color(0xFFD4AF37).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  memberCount.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFFD4AF37),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
