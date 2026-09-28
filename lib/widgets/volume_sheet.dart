import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../player/book_player.dart';

/// 音量等级中文标签：5 -> 正五级，-3 -> 负三级，0 -> 关闭
const List<String> _cnNums = ['一', '二', '三', '四', '五', '六', '七', '八', '九'];

String volumeLevelLabel(int level) {
  if (level == 0) return '关闭';
  final n = level.abs();
  final cn = n <= 9 ? _cnNums[n - 1] : '$n';
  return '${level > 0 ? '正' : '负'}$cn级';
}

/// 等级对应的音量百分比：5 -> 150%，-3 -> 70%
String volumeLevelPercent(int level) => '${100 + level * 10}%';

/// 音量增减幅选择面板（播放页）
///
/// 选中即生效并写入本地偏好；面板内实时响应等级变化。
Future<void> showVolumeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: AnimatedBuilder(
          animation: BookPlayer.instance,
          builder: (ctx, _) {
            // 直接读单例：AnimatedBuilder 已监听等级变化
            final player = BookPlayer.instance;
            final level = player.volumeLevel;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.volume_up_rounded, size: 18, color: AppTheme.accent),
                      const SizedBox(width: 8),
                      Text(
                        '音量增减幅',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '当前 ${volumeLevelPercent(level)}',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSub),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Text(
                    '正数表示增幅，负数表示降幅',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSub),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: BookPlayer.volumeLevels.map((v) {
                      final active = v == level;
                      return _LevelChip(
                        value: v,
                        active: active,
                        onTap: () {
                          player.setVolumeLevel(v);
                          Navigator.of(ctx).pop();
                        },
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Text(
                    '增幅为软件放大，音源偏小时可适当调高，级别过高可能出现破音；'
                    '负级相应降低音量。设置对所有有声书生效，换章与重启后保持。',
                    style: TextStyle(
                        fontSize: 12, color: AppTheme.textHint, height: 1.5),
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

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final int value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = value == 0 ? '关闭' : volumeLevelLabel(value);
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
