import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'error_screen.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

class ConnectivityListener extends ConsumerWidget {
  final Widget child;
  const ConnectivityListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);

    return connectivityAsync.when(
      data: (status) {
        if (status == ConnectivityResult.none) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                child,
                const Positioned.fill(
                  child: ErrorOverlay(),
                ),
              ],
            ),
          );
        }
        return child;
      },
      loading: () => child,
      error: (e, st) => Directionality(
        textDirection: TextDirection.ltr, 
        child: Stack(
          children: [
            child,
            ErrorScreen(
              errorType: ErrorType.generalError,
              message: e.toString(),
              onRetry: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorOverlay extends StatelessWidget {
  const ErrorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: ErrorScreen(
          errorType: ErrorType.noInternet,
          message: "Tidak ada koneksi internet!",
          onRetry: null,
        ),
      ),
    );
  }
}
