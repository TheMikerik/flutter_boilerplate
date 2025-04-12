import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/common/widgets/buttons/primary_button.dart';
import 'package:flutter_boilerplate/src/core/extensions/theme_data_extension.dart';
import 'package:flutter_boilerplate/src/core/routing/router.dart';
import 'package:flutter_boilerplate/src/features/onboarding/data/onboarding_repository.dart';
import 'package:flutter_boilerplate/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const routePath = '/onboarding';
  static const name = 'onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(onboardingControllerProvider);

    return Scaffold(
      backgroundColor: context.c.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Spacer(),
              Text(screen.currentStep.title!),
              Spacer(),
              PrimaryButton(
                text: 'Next onb step',
                onPressed: () {
                  ref.read(onboardingControllerProvider.notifier).next();
                },
              ),
              OutlinedButton(
                child: Text('Set onb as comleted'),
                onPressed: () {
                  ref
                      .read(onboardingRepositoryProvider)
                      .setOnboardingComplete();
                  ref.invalidate(goRouterProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
