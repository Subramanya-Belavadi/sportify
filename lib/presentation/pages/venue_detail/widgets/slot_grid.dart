import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
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
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
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
    final Color bg;
    final Color border;
    final Color text;

    if (!slot.isAvailable) {
      bg = AppColors.slotBookedBg;
      border = AppColors.slotBooked;
      text = AppColors.slotBooked;
    } else if (isSelected) {
      bg = AppColors.slotSelected;
      border = AppColors.slotSelected;
      text = Colors.white;
    } else {
      bg = AppColors.slotAvailableBg;
      border = AppColors.slotAvailable;
      text = AppColors.slotAvailable;
    }

    return GestureDetector(
      onTap: slot.isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        ),
        child: Center(
          child: Text(
            DateFormatter.toTimeDisplay(slot.startTime),
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
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
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          _LegendDot(color: AppColors.slotAvailable, label: 'Available'),
          SizedBox(width: 16),
          _LegendDot(color: AppColors.slotBooked, label: 'Booked'),
          SizedBox(width: 16),
          _LegendDot(color: AppColors.slotSelected, label: 'Selected'),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
