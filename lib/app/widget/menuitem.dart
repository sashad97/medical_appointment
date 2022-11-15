import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final void Function()? onTap;

  const MenuItemWidget({Key? key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.white,
                    size: 20,
                  ),
                  SizedBox(width: 20),
                  Text(
                    title!,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: AppColors.white),
                  ),
                ],
              ),
              Divider(
                color: AppColors.white.withOpacity(0.9),
                height: 10,
                thickness: 0.8,
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
        ));
  }
}
