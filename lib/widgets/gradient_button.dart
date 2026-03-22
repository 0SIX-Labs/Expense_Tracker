import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool isLoading;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.padding,
    this.textStyle,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              gradientColors ??
              [const Color(0xFF667eea), const Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (gradientColors?.first ?? const Color(0xFF667eea))
                .withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[icon!, const SizedBox(width: 8)],
                        Text(
                          text,
                          style:
                              textStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool isLoading;
  final Widget? icon;

  const GlassGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.padding,
    this.textStyle,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  gradientColors ??
                  [const Color(0xFF667eea), const Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding:
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              icon!,
                              const SizedBox(width: 8),
                            ],
                            Text(
                              text,
                              style:
                                  textStyle ??
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
