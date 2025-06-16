import 'package:flutter/material.dart';
import 'package:hopyn/core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../home/domain/entities/vehicle_type.dart';

class VehicleTypeCard extends StatelessWidget {
  final VehicleType vehicleType;
  final bool isSelected;
  final double estimatedPrice;
  final VoidCallback onTap;

  const VehicleTypeCard({
    Key? key,
    required this.vehicleType,
    required this.isSelected,
    required this.estimatedPrice,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color:AppColors.kWhite,
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.kYellow: AppColors.kPrimaryColor,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Vehicle icon
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    _getVehicleIcon(vehicleType.category),
                    color: isSelected ? AppColors.kYellow :  AppColors.kPrimaryColor,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Vehicle details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vehicleType.name,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.kPrimaryColor
                          ),
                        ),
                        Text(
                          estimatedPrice.toCurrency,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                         color: AppColors.kPrimaryColor
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicleType.description,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.kBlackShade.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color:AppColors.kPrimaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicleType.estimatedTime.toInt()} min',
                          style: context.textTheme.bodySmall?.copyWith(
                              color:AppColors.kPrimaryColor
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.person,
                          size: 16,
                            color:AppColors.kPrimaryColor
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicleType.maxPassengers}',
                          style: context.textTheme.bodySmall?.copyWith(
                              color:AppColors.kPrimaryColor
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selection indicator
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getVehicleIcon(VehicleCategoryType category) {
    switch (category) {
      case VehicleCategoryType.economy:
        return Icons.directions_car;
      case VehicleCategoryType.comfort:
        return Icons.car_rental;
      case VehicleCategoryType.premium:
        return Icons.local_taxi;
      case VehicleCategoryType.xl:
        return Icons.airport_shuttle;
    }
  }
}
