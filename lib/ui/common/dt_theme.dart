import 'package:flutter/material.dart';

class DtTheme {
  // 🎨 Main colors
  static const Color headerBlue = Color(0xFFCFE7F3);
  static const Color lightBlue = Color(0xFFBEE3F8);
  static const Color lightGrey = Color(0xFFE6E6E6);

  // 📝 Input field
  static InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }

  // 🔵 MAIN button (Login, Save, Register)
  static Widget primaryButton(
    String text,
    VoidCallback onTap, {
    double width = 160,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // 🔵 SMALL pill button (View, Review, Edit, Back)
  static Widget pillButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // 🧱 Card
  static Widget screenCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ✅ SUCCESS popup (used for Edit Profile)
  static Future<void> successDialog(
    BuildContext context,
    String message,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 70, color: Colors.green),
                const SizedBox(height: 14),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                DtTheme.primaryButton("OK", () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // ❌ Error snackbar
  static void errorSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
