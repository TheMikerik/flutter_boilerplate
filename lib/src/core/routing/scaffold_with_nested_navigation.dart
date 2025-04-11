import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/extensions/theme_data_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: navigationShell.currentIndex,
        backgroundColor: context.c.surface,
        onTap: _goBranch,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome04,
              color: context.c.onSurface.withAlpha(150),
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome04,
              color: context.c.onSurface,
              size: 30,
            ),
          ),

          // Settings tab
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: context.c.onSurface.withAlpha(150),
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: context.c.onSurface,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
