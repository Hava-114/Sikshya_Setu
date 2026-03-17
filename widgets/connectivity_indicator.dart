import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';

class ConnectivityIndicator extends StatelessWidget {
  final bool showLabel;

  const ConnectivityIndicator({
    Key? key,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, provider, _) {
        final isOnline = provider.isOnline;
        final color = isOnline ? Colors.green : Colors.red;
        final icon = isOnline ? Icons.cloud_done : Icons.cloud_off;
        final label = isOnline ? 'Online' : 'Offline';

        if (showLabel) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        // Just the icon without label
        return Tooltip(
          message: label,
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        );
      },
    );
  }
}

// Compact version for app bar
class ConnectivityAppBarIndicator extends StatelessWidget {
  const ConnectivityAppBarIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, provider, _) {
        if (provider.isOnline) return const SizedBox.shrink();
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Chip(
            avatar: Icon(
              Icons.cloud_off,
              color: Colors.red.shade700,
              size: 16,
            ),
            label: Text(
              'Offline Mode',
              style: TextStyle(
                fontSize: 11,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.red.shade50,
            side: BorderSide(color: Colors.red.shade200),
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }
}

// Full screen offline banner
class OfflineBanner extends StatelessWidget {
  final Widget child;

  const OfflineBanner({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            child,
            if (!provider.isOnline)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.orange.shade600,
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You are in Offline Mode. Some features may be unavailable.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
