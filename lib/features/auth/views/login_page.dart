import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_listing_app/features/auth/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/bloc/auth_state.dart';
import 'package:product_listing_app/features/auth/views/otp_verification_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PhoneVerified) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationPage(
                  phoneNumber: state.phoneNumber,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              _buildTitleSection(),
              const SizedBox(height: 40),
              _buildPhoneInputSection(),
              const SizedBox(height: 30),
              _buildContinueButton(),
              const SizedBox(height: 20),
              _buildTermsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: GoogleFonts.oxygen(
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Let's Connect with Lorem Ipsum..!",
          style: GoogleFonts.manrope(
            fontSize: 16,
            color: const Color(0xFF4E4D4D),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            readOnly: true,
            controller: TextEditingController(text: "+91"),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: "+91",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              contentPadding: EdgeInsets.only(bottom: 12.0),
              isDense: true,
            ),
            style: GoogleFonts.oxygen(
              color: const Color(0xFF646363),
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              hintText: "Enter Phone",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              contentPadding: EdgeInsets.only(bottom: 12.0),
              isDense: true,
              counterText: "",
            ),
            style: GoogleFonts.oxygen(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
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
                    if (_phoneController.text.length == 10) {
                      context
                          .read<AuthBloc>()
                          .add(VerifyPhone(_phoneController.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid phone number'),
                        ),
                      );
                    }
                  },
            child: state is AuthLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Continue",
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

  Widget _buildTermsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: "By Continuing you accepting the ",
            style: GoogleFonts.oxygen(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF4E4D4D),
            ),
            children: [
              TextSpan(
                text: "Terms of Use",
                style: GoogleFonts.oxygen(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF4E4D4D),
                  decoration: TextDecoration.underline,
                ),
              ),
              const TextSpan(text: " & "),
              TextSpan(
                text: "Privacy Policy",
                style: GoogleFonts.oxygen(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF4E4D4D),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
