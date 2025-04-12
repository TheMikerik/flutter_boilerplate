import 'package:flutter_boilerplate/src/features/onboarding/data/onboarding_repository.dart';
import 'package:flutter_boilerplate/src/features/onboarding/domain/onboarding_step.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

class OnboardingProgress {
  const OnboardingProgress({
    required this.currentStep,
    required this.progress,
  });
  final OnboardingStep currentStep;
  final double progress;
}

@riverpod
class OnboardingController extends _$OnboardingController {
  static const _steps = [
    OnboardingStep.custom(
      title: 'Onboarding Screen #1',
    ),
    OnboardingStep.custom(
      title: 'Onboarding Screen #2',
    ),
    OnboardingStep.custom(
      title: 'Onboarding Screen #3',
    ),
  ];

  late DateTime? _currentStepStartTime;

  @override
  OnboardingProgress build() {
    _currentStepStartTime = DateTime.now();
    return OnboardingProgress(
      currentStep: _steps[0],
      progress: 0,
    );
  }

  Duration _trackStepTime() {
    return DateTime.now().difference(_currentStepStartTime!);
  }

  void answerSurvey(String question, String answer) {
    _trackStepTime();

    final currentIndex = _steps.indexOf(state.currentStep);
    final nextIndex = currentIndex + 1;

    if (nextIndex < _steps.length) {
      state = OnboardingProgress(
        currentStep: _steps[nextIndex],
        progress: state.currentStep.countForProgress
            ? state.progress +
                (1.0 / _steps.where((step) => step.countForProgress).length)
            : state.progress,
      );
      _currentStepStartTime = DateTime.now();
    } else {
      ref.read(onboardingRepositoryProvider).setOnboardingComplete();
    }
  }

  void next() {
    _trackStepTime();

    final currentIndex = _steps.indexOf(state.currentStep);
    final nextIndex = currentIndex + 1;

    if (nextIndex < _steps.length) {
      state = OnboardingProgress(
        currentStep: _steps[nextIndex],
        progress: state.currentStep.countForProgress
            ? state.progress +
                (1.0 / _steps.where((step) => step.countForProgress).length)
            : state.progress,
      );
      _currentStepStartTime = DateTime.now();
    } else {
      ref.read(onboardingRepositoryProvider).setOnboardingComplete();
    }
  }

  // Used Only For Testing Purposes
  void goto(int index) {
    state = OnboardingProgress(
      currentStep: _steps[index],
      progress: state.progress,
    );
  }

  void back() {
    final currentIndex = _steps.indexOf(state.currentStep);
    final nextIndex = currentIndex - 1;

    state = OnboardingProgress(
      currentStep: _steps[nextIndex],
      progress: state.currentStep.countForProgress &&
              _steps[nextIndex].countForProgress
          ? state.progress -
              (1.0 / _steps.where((step) => step.countForProgress).length)
          : state.progress,
    );
  }
}
