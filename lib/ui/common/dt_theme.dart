import 'package:flutter/material.dart';

class DtTheme {
  // 🎨 Main colors (match DaieTrack UI)
  static const Color headerBlue = Color(0xFFCFE7F3);
  static const Color lightGrey = Color(0xFFE6E6E6);

  // 📝 Input field decoration
  static InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }

  // 🔵 Main rounded button (Sign Up, Save, Login, etc.)
  static Widget primaryButton(
    String text,
    VoidCallback onTap, {
    double width = 160,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: headerBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withOpacity(.25)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ),
    );
  }

  // ⚪ Small pill button (Review, View, Edit)
  static Widget pillButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(.25)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }

  // 🧱 White card container (used in forms)
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
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ✅ Success popup (green tick)
  static Future<void> signupSuccessDialog(
    BuildContext context, {
    VoidCallback? onClose,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // ❌ Close button
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    if (onClose != null) onClose();
                  },
                ),
              ),

              // ✅ Center content
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, size: 90, color: Colors.green),
                    SizedBox(height: 14),
                    Text(
                      "Sign Up\nSuccessful",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
