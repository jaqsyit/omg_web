import 'package:flutter/material.dart';

class AppStyles {
  Color color1 = const Color(0xFF398FA3);
  Color color2 = const Color(0xFF8BE1DE);

  static const TextStyle dropdownTextStyle = TextStyle(
    color: Colors.black,
  );

  static const TextStyle dropdownHintStyle = TextStyle(
    color: Colors.grey,
  );

  static const BoxDecoration dropdownDecoration = BoxDecoration(
    color: Colors.white,
  );

  static const TextStyle nonActiveButtonText = TextStyle(
    color: Colors.grey,
  );

  static const TextStyle activeButtonText = TextStyle(
    color: Colors.white,
  );

  static ButtonStyle activeButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      const Size(20, 40),
    ),
  );

  static ButtonStyle nonActiveButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      const Size(20, 40),
    ),
  );
}

class CustomTextStyles {
  static const TextStyle s10w600cw = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w600,
  );
  static const TextStyle s12w700cb = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle s20w500cb = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s20w500cw = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s20w400cb = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s20w400cw = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s14w400cb = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s14w300cgItalic = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.grey,
    fontSize: 14,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w300,
  );
  static const TextStyle s14w700cb = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle s13w400cg = TextStyle(
    color: Colors.grey,
    fontSize: 13,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s14w400cw = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s26w700cb = TextStyle(
    color: Colors.black,
    fontSize: 26,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle s32w500cb = TextStyle(
    color: Colors.black87,
    fontSize: 32,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s16w500cb = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s12w400cg = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s12w400cw = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s16w400cb = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s16w400cw = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s12w500cb = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s18w500cb = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s18w400cb = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s18w500cw = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle s17w400cg = TextStyle(
    color: Colors.grey,
    fontSize: 17,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s12w400cb = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
  );
}