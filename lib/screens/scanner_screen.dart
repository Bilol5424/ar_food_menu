import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/sample_menu.dart';
import 'menu_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _handled = false;
  bool _permissionDenied = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestAndStart();
  }

  Future<void> _requestAndStart() async {
    setState(() => _checking = true);
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (status.isGranted) {
      setState(() {
        _permissionDenied = false;
        _checking = false;
        _controller = MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
        );
      });
    } else {
      setState(() {
        _permissionDenied = true;
        _checking = false;
      });
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final value = barcodes.first.rawValue ?? '';
    if (value.isEmpty) return;
    _handled = true;
    _controller?.stop();
    _openMenu(scanned: value);
  }

  void _openMenu({String? scanned}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MenuScreen(
          restaurantName: 'Demo Bistro',
          dishes: demoMenu,
          scannedValue: scanned,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _controller;
    if (c == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        c.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        c.stop();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканирование QR')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_checking) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_permissionDenied) {
      return _PermissionDeniedView(
        onRetry: _requestAndStart,
        onOpenSettings: openAppSettings,
        onDemo: () => _openMenu(),
      );
    }
    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        MobileScanner(
          controller: controller,
          onDetect: _onDetect,
          fit: BoxFit.cover,
          errorBuilder: (context, error, child) {
            return _CameraErrorView(
              message:
                  'Ошибка камеры: ${error.errorCode.name}\n${error.errorDetails?.message ?? ''}',
              onRetry: _requestAndStart,
              onDemo: () => _openMenu(),
            );
          },
        ),
        IgnorePointer(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const Positioned(
          bottom: 48,
          left: 24,
          right: 24,
          child: Text(
            'Наведите камеру на QR-код ресторана',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              shadows: [Shadow(blurRadius: 6, color: Colors.black)],
            ),
          ),
        ),
      ],
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;
  final VoidCallback onDemo;
  const _PermissionDeniedView({
    required this.onRetry,
    required this.onOpenSettings,
    required this.onDemo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Нет доступа к камере',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Разрешите доступ к камере, чтобы сканировать QR-коды. '
            'Если запрос не появляется — откройте настройки приложения.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: onRetry, child: const Text('Запросить снова')),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onOpenSettings,
            child: const Text('Открыть настройки'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onDemo,
            child: const Text('Пропустить и открыть демо-меню'),
          ),
        ],
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onDemo;
  const _CameraErrorView({
    required this.message,
    required this.onRetry,
    required this.onDemo,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onDemo,
              child: const Text(
                'Открыть демо-меню',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
