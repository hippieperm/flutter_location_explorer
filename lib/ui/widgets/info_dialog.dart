import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoDialog extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onDismissed;
  final Widget? customAction;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconColor = Colors.blue,
    this.onDismissed,
    this.customAction,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.info_outline,
    Color iconColor = Colors.blue,
    VoidCallback? onDismissed,
    Widget? customAction,
  }) async {
    // 햅틱 피드백 추가
    HapticFeedback.mediumImpact();

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '정보 다이얼로그',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder:
          (context, animation1, animation2) => InfoDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: iconColor,
            onDismissed: onDismissed,
            customAction: customAction,
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(curve),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    ).then((_) {
      if (onDismissed != null) {
        onDismissed();
      }
    });
  }

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconAnimation = Tween<double>(
      begin: 0.2,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            AnimatedBuilder(
              animation: _iconAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _iconAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: widget.iconColor.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 40),
              ),
            ),

            // 제목
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // 메시지
            const SizedBox(height: 16),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // 액션 버튼
            const SizedBox(height: 24),
            if (widget.customAction != null)
              widget.customAction!
            else
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.iconColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text('확인', style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}
