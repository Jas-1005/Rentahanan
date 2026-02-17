import 'package:flutter/material.dart';

class ManagerHelper {
  static final List<Map<String, dynamic>> navItems = [
    {'image': 'assets/images/home.png', 'label': 'Home', 'route': '/manager-dashboard'},
    {'image': 'assets/images/message.png', 'label': 'Inbox', 'route': '/placeholder-page'},
    {'image': 'assets/images/aboutPage.png', 'label': 'About', 'route': '/placeholder-page'},
    {'image': 'assets/images/profile.png', 'label': 'Profile', 'route': '/manager-profile'},
  ];

  static List<Widget> buildNavItems(BuildContext context) {
    return navItems.map((item) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => Navigator.pushNamed(context, item['route']),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  item['image'],
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
