import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fake_store/app/core/constants/app_images.dart';
import 'package:fake_store/app/core/constants/app_strings.dart';
import 'package:fake_store/app/core/theme/app_colors.dart';
import 'package:fake_store/app/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

enum AppErrorKind { network, timeout, server, unknown }

class ErrorScreen extends StatelessWidget {
  final AppErrorKind kind;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  const ErrorScreen({
    super.key,
    required this.kind,
    this.message,
    this.onRetry,
    this.onGoHome,
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
        return AppStrings.noConnection;
      case AppErrorKind.timeout:
        return AppStrings.requestTimeOut;
      case AppErrorKind.server:
        return AppStrings.serveError;
      case AppErrorKind.unknown:
        return '';
    }
  }

  String get _subtitle {
    if (message != null && message!.trim().isNotEmpty) return message!;
    switch (kind) {
      case AppErrorKind.network:
        return AppStrings.checkInternt;
      case AppErrorKind.timeout:
        return AppStrings.problemServer;
      case AppErrorKind.server:
        return AppStrings.processingRequest;
      case AppErrorKind.unknown:
        return AppStrings.tryAgainMoment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.connectionProblem,
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  if (onRetry != null)
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text(AppStrings.tryAgain),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (r) => false);
                    },
                    child: const Text(
                      AppStrings.goHome,
                      style: AppFonts.buttonText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
