import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_listing_app/features/auth/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/bloc/auth_state.dart';
import 'package:product_listing_app/features/auth/views/name_entry_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  late Timer _timer;
  int _timeLeft = 15; // 15 seconds countdown
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _timeLeft = 15;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _enteredOtp {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NameScreen(phoneNumber: state.phoneNumber),
              ),
            );
          } else if (state is PhoneVerified) {
            // Show success message when OTP is resent
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP has been resent')),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              _buildBackButton(),
              const SizedBox(height: 40),
              _buildTitleSection(),
              const SizedBox(height: 16),
              _buildPhoneNumberSection(),
              const SizedBox(height: 25),
              _buildOtpHintSection(),
              const SizedBox(height: 25),
              _buildOtpInputSection(),
              const SizedBox(height: 30),
              _buildTimerResendSection(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Text(
      "OTP VERIFICATION",
      style: GoogleFonts.oxygen(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildPhoneNumberSection() {
    return RichText(
      text: TextSpan(
        text: "Enter the OTP sent to - ",
        style: GoogleFonts.oxygen(
          fontSize: 14,
          color: const Color(0xFF4E4D4D),
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: "+91-${widget.phoneNumber}",
            style: GoogleFonts.oxygen(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpHintSection() {
    return Text(
      "Enter 4 digit OTP",
      style: GoogleFonts.oxygen(
        fontSize: 14,
        color: const Color(0xFF4E4D4D),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildOtpInputSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 75.5,
          height: 75,
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            onChanged: (value) => _onOtpChanged(index, value),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF6C63FF),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            style: GoogleFonts.oxygen(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTimerResendSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "00:${_timeLeft.toString().padLeft(2, '0')} Sec",
          style: GoogleFonts.oxygen(
            fontSize: 14,
            color: const Color(0xFF464646),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't receive code? ",
              style: GoogleFonts.oxygen(
                fontSize: 14,
                color: const Color(0xFF5A5A5A),
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: _canResend
                  ? () {
                      context
                          .read<AuthBloc>()
                          .add(VerifyPhone(widget.phoneNumber));
                      startTimer(); // Restart timer on resend
                    }
                  : null,
              child: Text(
                "Re-send",
                style: GoogleFonts.oxygen(
                  fontSize: 14,
                  color: _canResend
                      ? const Color(0xFF00E5A4)
                      : const Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: state is AuthLoading
                ? null
                : () {
                    if (_enteredOtp.length == 4) {
                      context.read<AuthBloc>().add(
                            VerifyOtp(_enteredOtp, widget.phoneNumber),
                          );
                    }
                  },
            child: state is AuthLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Submit",
                    style: GoogleFonts.oxygen(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
