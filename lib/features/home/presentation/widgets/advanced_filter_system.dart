import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

const List<String> _areas = [
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

class AdvancedFilterSystem extends StatefulWidget {
  final List<String> selectedAreas;
  final Map<String, int> areaCounts;
  final Function(List<String>) onAreasChanged;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const AdvancedFilterSystem({
    super.key,
    required this.selectedAreas,
    required this.areaCounts,
    required this.onAreasChanged,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  State<AdvancedFilterSystem> createState() => _AdvancedFilterSystemState();
}

class _AdvancedFilterSystemState extends State<AdvancedFilterSystem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterHeader(),
          const SizedBox(height: 8),
          _buildActiveFilters(),
          const SizedBox(height: 8),
          _buildExpandableFilters(),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90E2).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.tune,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Filtros Inteligentes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        if (widget.selectedAreas.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4A90E2).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.selectedAreas.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4A90E2),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  'ativo${widget.selectedAreas.length > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4A90E2),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActiveFilters() {
    if (widget.selectedAreas.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.textSecondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.filter_alt,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Filtros Ativos',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => widget.onAreasChanged([]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.clear_all,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Limpar Tudo',
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
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedAreas.map((area) => _buildActiveFilterChip(area)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String area) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            area,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              final newAreas = List<String>.from(widget.selectedAreas);
              newAreas.remove(area);
              widget.onAreasChanged(newAreas);
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableFilters() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.textSecondary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.category,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Todas as Áreas',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return SizeTransition(
              sizeFactor: _fadeAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAllAreasGrid(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAllAreasGrid() {
    // Usar a lista completa de áreas em ordem fixa
    const allAreas = _areas;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.textSecondary.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textSecondary.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: allAreas.map((area) => _buildAreaChip(area)).toList(),
      ),
    );
  }

  Widget _buildAreaChip(String area) {
    final isSelected = widget.selectedAreas.contains(area);
    final memberCount = widget.areaCounts[area] ?? 0;
    final hasMembers = memberCount > 0;

    return GestureDetector(
      onTap: () {
        final newAreas = List<String>.from(widget.selectedAreas);
        if (isSelected) {
          newAreas.remove(area);
        } else {
          newAreas.add(area);
        }
        widget.onAreasChanged(newAreas);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2).withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFFD4AF37).withOpacity(0.3),
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
                    color: isSelected ? const Color(0xFF4A90E2) : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
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
