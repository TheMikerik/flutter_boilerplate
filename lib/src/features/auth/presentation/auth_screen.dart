import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/common/providers/haptic_feedback_provider.dart';
import 'package:flutter_boilerplate/src/core/common/widgets/buttons/primary_button.dart';
import 'package:flutter_boilerplate/src/core/extensions/theme_data_extension.dart';
import 'package:flutter_boilerplate/src/core/resources/assets.dart';
import 'package:flutter_boilerplate/src/core/routing/router.dart';
import 'package:flutter_boilerplate/src/features/auth/presentation/auth_controller.dart';
import 'package:flutter_boilerplate/src/features/home/presentation/home_screen.dart';
import 'package:flutter_boilerplate/src/features/onboarding/data/onboarding_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  static const routePath = '/auth';
  static const name = 'auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Spacer(),
              Text("Auth"),
              Text(
                "(login with auth will work after setting up supabase - after setting up supabase, uncomment the code in router.dart)",
                textAlign: TextAlign.center,
              ),
              Text("(seek: UNCOMMENT #1)"),
              OutlinedButton(
                onPressed: () => context.goNamed(HomeScreen.name),
                child: Text('Home Screen'),
              ),
              Spacer(),
              loginButton(
                context: context,
                iconPath: LogoAssets.appleLogo,
                text: 'Sign in with Apple',
                onTap: () async {
                  ref.read(hapticProvider.notifier).vibrate();
                  await ref
                      .read(authControllerProvider.notifier)
                      .signInWithApple();
                },
              ),
              const SizedBox(height: 22),
              loginButton(
                context: context,
                iconPath: LogoAssets.googleLogo,
                text: 'Sign in with Google',
                onTap: () async {
                  ref.read(hapticProvider.notifier).vibrate();
                  await ref
                      .read(authControllerProvider.notifier)
                      .signInWithGoogle();
                },
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                text: 'set onb as uncompleted',
                onPressed: () async {
                  ref.read(hapticProvider.notifier).vibrate();
                  ref
                      .read(onboardingRepositoryProvider)
                      .setOnboardingNotComplete();
                  ref.invalidate(goRouterProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: context.c.surface.withAlpha(222),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(iconPath),
            width: 30,
            height: 30,
            color:
                iconPath == LogoAssets.appleLogo ? context.c.onSurface : null,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: context.t.bodyLarge!.copyWith(
              color: context.c.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
