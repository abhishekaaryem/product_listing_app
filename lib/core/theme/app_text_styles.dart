import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final heading1 = GoogleFonts.oxygen(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final subtitle1 = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final inputText = GoogleFonts.oxygen(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  static final buttonText = GoogleFonts.oxygen(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.buttonText,
  );

  static final caption = GoogleFonts.oxygen(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );
}
