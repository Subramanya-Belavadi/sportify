import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../domain/entities/slot_entity.dart';

class SlotGrid extends StatelessWidget {
  final List<SlotEntity> slots;
  final SlotEntity? selectedSlot;
  final List<SlotEntity> selectedSlots;
  final Set<int> userBlockedHours;
  final ValueChanged<SlotEntity> onSlotTap;
  const SlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.selectedSlots,
    required this.userBlockedHours,
    required this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIds = selectedSlots.map((s) => s.id).toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Legend(showYours: userBlockedHours.isNotEmpty),
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
            itemBuilder: (context, i) {
              final slot = slots[i];
              final hour = int.parse(slot.startTime.split(':')[0]);
              final blockedByUser = userBlockedHours.contains(hour);
              return _SlotChip(
                slot: slot,
                isSelected: selectedIds.contains(slot.id),
                isAnchor: selectedSlot?.id == slot.id,
                isBlockedByUser: blockedByUser,
                onTap: () => onSlotTap(slot),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  final SlotEntity slot;
  final bool isSelected;
  final bool isAnchor;
  final bool isBlockedByUser;
  final VoidCallback onTap;
  const _SlotChip({
    required this.slot,
    required this.isSelected,
    required this.isAnchor,
    required this.isBlockedByUser,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool available = slot.isAvailable && !isBlockedByUser;

    Color bgColor;
    Color borderColor;
    Color timeColor;
    Color labelColor;
    String label;

    if (isSelected) {
      bgColor = AppColors.primary;
      borderColor = AppColors.primary;
      timeColor = Colors.white;
      labelColor = Colors.white.withValues(alpha: 0.8);
      label = isAnchor ? 'Start' : 'Added';
    } else if (isBlockedByUser) {
      bgColor = const Color(0xFFFFF8E1);
      borderColor = const Color(0xFFFFB300).withValues(alpha: 0.6);
      timeColor = const Color(0xFFE65100);
      labelColor = const Color(0xFFE65100).withValues(alpha: 0.8);
      label = 'Yours';
    } else if (!slot.isAvailable) {
      bgColor = const Color(0xFFFFF0F0);
      borderColor = AppColors.slotBooked.withValues(alpha: 0.4);
      timeColor = AppColors.slotBooked;
      labelColor = AppColors.slotBooked.withValues(alpha: 0.7);
      label = 'Booked';
    } else {
      bgColor = Colors.white;
      borderColor = AppColors.slotAvailable.withValues(alpha: 0.5);
      timeColor = AppColors.textPrimary;
      labelColor = AppColors.slotAvailable;
      label = 'Open';
    }

    return GestureDetector(
      onTap: available ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormatter.toTimeDisplay(slot.startTime),
              style: TextStyle(
                color: timeColor,
                fontWeight: isAnchor ? FontWeight.w800 : FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final bool showYours;
  const _Legend({this.showYours = false});

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
          const SizedBox(width: 12),
          _LegendDot(color: AppColors.slotBooked, label: 'Booked'),
          if (showYours) ...[
            const SizedBox(width: 12),
            _LegendDot(color: Color(0xFFE65100), label: 'Yours'),
          ],
          const SizedBox(width: 12),
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
