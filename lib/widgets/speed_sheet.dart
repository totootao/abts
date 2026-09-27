import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../player/book_player.dart';
import '../utils/format.dart';

/// 播放倍速选择面板（播放页与设置页共用）
///
/// 选中即生效并写入本地偏好；面板内实时响应倍速变化。
Future<void> showSpeedSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: AnimatedBuilder(
          animation: BookPlayer.instance,
          builder: (ctx, _) {
            // 直接读单例：AnimatedBuilder 已监听倍速变化
            final player = BookPlayer.instance;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Row(
                    children: [
                      Icon(Icons.speed_rounded, size: 18, color: AppTheme.accent),
                      const SizedBox(width: 8),
                      Text(
                        '播放倍速',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '当前 ${Fmt.speed(player.speed)}',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSub),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: BookPlayer.speedOptions.map((v) {
                      final active = (player.speed - v).abs() < 0.001;
                      return _SpeedChip(
                        value: v,
                        active: active,
                        onTap: () {
                          player.setSpeed(v);
                          Navigator.of(ctx).pop();
                        },
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Text(
                    '变速不变调，对所有有声书生效；换章与重启后保持。',
                    style: TextStyle(fontSize: 12, color: AppTheme.textHint, height: 1.5),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final double value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = value == 1.0 ? '正常' : Fmt.speed(value);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: active ? AppTheme.accent.withValues(alpha: 0.14) : AppTheme.surface,
          border: Border.all(
            color: active ? AppTheme.accent : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? AppTheme.accent : AppTheme.textMain,
          ),
        ),
      ),
    );
  }
}
