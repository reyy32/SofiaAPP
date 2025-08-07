import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:url_launcher/url_launcher.dart';

/// A screen that encourages users to follow the app's Instagram account.
class FollowInstagramScreen extends StatelessWidget {
  const FollowInstagramScreen({super.key});

  /// Instagram URL for the account to follow.
  static const String instagramUrl = 'https://www.instagram.com/your_account_handle';

  /// Launches the Instagram URL in the user's default browser or app.
  Future<void> _launchInstagramUrl() async {
    final Uri url = Uri.parse(instagramUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (kDebugMode) {
          print('Could not launch $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching Instagram URL: $e');
      }
    }
  }

  /// Builds the app bar with a consistent theme.
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Seguinos en Instagram'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  /// Builds the main content with a centered column layout.
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 80,
            color: Colors.purple,
            semanticLabel: 'Ícono de Instagram',
          ),
          const SizedBox(height: 24),
          Text(
            '¡Seguinos en Instagram!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
            semanticsLabel: 'Título: Seguinos en Instagram',
          ),
          const SizedBox(height: 16),
          Text(
            'Seguí nuestra cuenta para obtener beneficios exclusivos y enterarte de todas nuestras novedades.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
            semanticsLabel: 'Descripción: Seguí nuestra cuenta para obtener beneficios exclusivos.',
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _launchInstagramUrl,
            icon: const Icon(Icons.open_in_new, semanticLabel: 'Abrir enlace'),
            label: const Text('Ir a Instagram'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: Theme.of(context).textTheme.labelLarge,
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }
}