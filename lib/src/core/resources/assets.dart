import 'package:flutter_boilerplate/src/core/resources/base.dart';
import 'package:flutter_svg/svg.dart';

class LogoAssets {
  const LogoAssets._();

  static const _base = BasePaths.baseLogoPath;

  static const appleLogo = '$_base/apple-logo.png';
  static const googleLogo = '$_base/google-logo.png';
}

class SvgAssets {
  const SvgAssets._();

  static void svgPrecacheImage() {
    const cacheSvgImages = [];

    for (final element in cacheSvgImages) {
      final loader = SvgAssetLoader(element);
      svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }
}
