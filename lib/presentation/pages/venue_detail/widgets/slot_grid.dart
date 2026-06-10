import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../domain/entities/slot_entity.dart';

class SlotGrid extends StatelessWidget {
  final List<SlotEntity> slots;
  final SlotEntity? selectedSlot;
  final ValueChanged<SlotEntity> onSlotTap;
  const SlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Legend(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.7,
            ),
            itemCount: slots.length,
            itemBuilder: (context, i) => _SlotChip(
              slot: slots[i],
              isSelected: selectedSlot?.id == slots[i].id,
              onTap: () => onSlotTap(slots[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  final SlotEntity slot;
  final bool isSelected;
  final VoidCallback onTap;
  const _SlotChip({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool available = slot.isAvailable;

    return GestureDetector(
      onTap: available ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : available
                  ? Colors.white
                  : const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : available
                    ? AppColors.slotAvailable.withValues(alpha: 0.5)
                    : AppColors.slotBooked.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormatter.toTimeDisplay(slot.startTime),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : available
                        ? AppColors.textPrimary
                        : AppColors.slotBooked,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              available ? (isSelected ? 'Selected' : 'Open') : 'Booked',
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : available
                        ? AppColors.slotAvailable
                        : AppColors.slotBooked.withValues(alpha: 0.7),
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Text(
            'Slots',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          _LegendDot(color: AppColors.slotAvailable, label: 'Available'),
          const SizedBox(width: 14),
          _LegendDot(color: AppColors.slotBooked, label: 'Booked'),
          const SizedBox(width: 14),
          _LegendDot(color: AppColors.primary, label: 'Selected'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
