import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum AppErrorKind { network, timeout, server, unknown }

class EmptyListScreen extends StatelessWidget {
  final AppErrorKind kind;
  final String? message;
  final VoidCallback? onRetry;

  const EmptyListScreen({
    super.key,
    required this.kind,
    this.message,
    this.onRetry,
  });

  static AppErrorKind classify(Object e) {
    if (e is SocketException) return AppErrorKind.network;

    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return AppErrorKind.timeout;
        case DioExceptionType.badResponse:
          return AppErrorKind.server;
        case DioExceptionType.unknown:
          final msg = e.message?.toLowerCase() ?? '';
          if (msg.contains('socket') || msg.contains('failed host lookup')) {
            return AppErrorKind.network;
          }
          return AppErrorKind.unknown;
        default:
          return AppErrorKind.unknown;
      }
    }

    return AppErrorKind.unknown;
  }

  String get _title {
    switch (kind) {
      case AppErrorKind.network:
        return 'No connection';
      case AppErrorKind.timeout:
        return 'Request timed out';
      case AppErrorKind.server:
        return 'Server error';
      case AppErrorKind.unknown:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gray = theme.colorScheme.onSurface.withOpacity(0.55);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/problem_connection.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: gray,
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Go Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
