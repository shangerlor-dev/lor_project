
import 'package:flutter/material.dart';
import '../widgets/animated_tech_background.dart';

const Color _blue = Color(0xFF4D8DFF);
const Color _teal = Color(0xFF35D6C4);
const Color _white = Color(0xFFF4F7FF);
const Color _muted = Color(0xFFA8B5D0);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // UI prototype only. No account is saved to a database yet.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'UI demo only. Connect your registration API to create an account.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTechBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 850;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 36 : 18,
              vertical: 28,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 56,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101B31).withValues(alpha: 0.83),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.13),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _blue.withValues(alpha: 0.12),
                        blurRadius: 70,
                        spreadRadius: 2,
                      ),
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 35,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _brandingPanel(),
                            ),
                            Expanded(
                              flex: 4,
                              child: _registerForm(),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _mobileBranding(),
                            _registerForm(),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _logo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_blue, _teal],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _blue.withValues(alpha: 0.3),
                blurRadius: 22,
              ),
            ],
          ),
          child: const Icon(
            Icons.remove_red_eye_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 13),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PUV VISION',
              style: TextStyle(
                color: _white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'PASSENGER INTELLIGENCE',
              style: TextStyle(
                color: _teal,
                fontSize: 8,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _brandingPanel() {
    return Container(
      constraints: const BoxConstraints(minHeight: 650),
      padding: const EdgeInsets.all(38),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B3769).withValues(alpha: 0.85),
            const Color(0xFF101B31).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(),
          const SizedBox(height: 65),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: _teal.withValues(alpha: 0.25)),
            ),
            child: const Text(
              'JOIN THE PLATFORM',
              style: TextStyle(
                color: _teal,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Your journey\nto smarter\nmobility starts here.',
            style: TextStyle(
              color: _white,
              fontSize: 39,
              height: 1.15,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Create your PUV Vision profile and explore '
            'a smarter approach to passenger monitoring.',
            style: TextStyle(
              color: _muted,
              fontSize: 15,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 36),
          _benefit(
            Icons.insights_rounded,
            'Intelligent monitoring',
            'Computer-vision powered passenger insights.',
          ),
          const SizedBox(height: 20),
          _benefit(
            Icons.directions_bus_rounded,
            'Transportation-focused',
            'Designed around public utility vehicles.',
          ),
          const SizedBox(height: 20),
          _benefit(
            Icons.admin_panel_settings_outlined,
            'Role-based workspace',
            'For authorized administrators and operators.',
          ),
        ],
      ),
    );
  }

  Widget _mobileBranding() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 5),
      child: Column(
        children: [
          _logo(),
          const SizedBox(height: 24),
          const Text(
            'Create your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Join the PUV Vision platform.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _benefit(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: _blue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: _blue.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: _teal, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _registerForm() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 22 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Create account',
                style: TextStyle(
                  color: _white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fill in your details to get started.',
                style: TextStyle(color: _muted, height: 1.6),
              ),
              const SizedBox(height: 28),
              _label('FULL NAME'),
              const SizedBox(height: 9),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: _white),
                decoration: _decoration(
                  'Enter your full name',
                  Icons.person_outline_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _label('EMAIL ADDRESS'),
              const SizedBox(height: 9),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: _white),
                decoration: _decoration(
                  'you@example.com',
                  Icons.alternate_email_rounded,
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Please enter your email.';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(email)) {
                    return 'Enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _label('PASSWORD'),
              const SizedBox(height: 9),
              TextFormField(
                controller: _passwordController,
                obscureText: _hidePassword,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: _white),
                decoration: _decoration(
                  'At least 6 characters',
                  Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() => _hidePassword = !_hidePassword);
                    },
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _muted,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Use at least 6 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _label('CONFIRM PASSWORD'),
              const SizedBox(height: 9),
              TextFormField(
                controller: _confirmController,
                obscureText: _hideConfirm,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _register(),
                style: const TextStyle(color: _white),
                decoration: _decoration(
                  'Re-enter your password',
                  Icons.verified_user_outlined,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() => _hideConfirm = !_hideConfirm);
                    },
                    icon: Icon(
                      _hideConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _muted,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password.';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              _submitButton(),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: _teal,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'PUV VISION  •  SMART MOBILITY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF687A9A),
                    fontSize: 9,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _muted,
        fontSize: 10,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  InputDecoration _decoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF65738D), fontSize: 13),
      prefixIcon: Icon(icon, color: _muted, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF080F20).withValues(alpha: 0.75),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_blue, Color(0xFF5A6CFF), _teal],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _blue.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _loading ? null : _register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
