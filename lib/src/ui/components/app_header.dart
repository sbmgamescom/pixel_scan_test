
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.onBack,
    this.actions,
  }) : assert(title != null || titleWidget != null, 'Either title or titleWidget must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ShadIconButton.ghost(
                    icon: const Icon(LucideIcons.arrowLeft, size: 24),
                    onPressed: onBack,
                  ),
                ),
              Expanded(
                child: titleWidget ??
                    Text(
                      title!,
                      style: theme.textTheme.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.muted,
            ),
          ],
        ],
      ),
    );
  }
}
