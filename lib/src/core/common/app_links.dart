class AppLinks {
  static const String scheme = 'https';

  static Uri get discordUri => Uri(
        scheme: scheme,
        host: 'discord.gg',
        path: '/test',
      );
}
