import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/common/widgets/buttons/primary_button.dart';
import 'package:flutter_boilerplate/src/features/home/presentation/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  static const routePath = '/auth';
  static const name = 'auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            Text("Auth"),
            Spacer(),
            PrimaryButton(
              text: 'Login',
              onPressed: () => context.goNamed(HomeScreen.name),
            )
          ],
        ),
      ),
    ));
  }
}
