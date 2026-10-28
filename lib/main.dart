import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HauntedMansionApp());
}

class HauntedMansionApp extends StatelessWidget {
  const HauntedMansionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Haunted Signup Mansion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F1FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E1065), Color(0xFF14101F)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('\u{1F987}', style: TextStyle(fontSize: 72)),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'The Haunted Mansion',
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 120),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              const Text(
                'Sign the guest book... if you dare.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text('Enter If You Dare'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to read what the user types
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _dateController = TextEditingController();
  DateTime? _birthDate;

  bool _hidePassword = true;
  bool _submitting = false;
  bool _loading = false;
  String _category = 'password_help';
  String _tip = '';
  String _tipError = '';

  final Map<String, String> _tips = {
    'password_help':
        'Use a unique password with letters, numbers, and symbols.',
    'email_help':
        'Double-check your email address before signing up.',
    'account_help':
        'Keep your account information private and never share your password.',
  };

  @override
  void initState() {
    super.initState();
    // Rebuild the UI whenever the password changes so strength updates live
    _passwordController.addListener(_updatePassword);
  }

  void _updatePassword() {
    setState(() {});
  }

  // Clean up controllers when the page is removed
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _passwordStrength() {
    String password = _passwordController.text;

    if (password.isEmpty) {
      return 'No password entered';
    }

    if (password.length < 8) {
      return 'Weak';
    }

    return 'Good';
  }

  String _passwordAdvice() {
    String password = _passwordController.text;

    if (password.isEmpty) {
      return 'Enter a password to see a tip.';
    }

    if (password.length < 8) {
      return 'Try using at least 8 characters.';
    }

    return 'Good length! Adding numbers and symbols can make it stronger.';
  }

  Color _strengthColor() {
    if (_passwordController.text.isEmpty) {
      return Colors.grey;
    }

    if (_passwordController.text.length < 8) {
      return Colors.red;
    }

    return Colors.green;
  }

  // Simulates loading a tip with a short delay
  Future<void> _getTip() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
      _tip = '';
      _tipError = '';
    });

    await Future.delayed(const Duration(seconds: 1));

    // Stop if the page was closed while waiting
    if (!mounted) {
      return;
    }

    String? result = _tips[_category];

    setState(() {
      _loading = false;

      // Missing category (the "Test Error" option) shows an error
      if (result == null || result.isEmpty) {
        _tipError = 'Tip is not available. Please try again.';
      } else {
        _tip = result;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  Future<void> _signup() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Signup Laboratory'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          // Limit width so the form looks good on wide screens
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Create Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'Join us today!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field with a simple format check
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }

                          String email = value.trim();

                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(email)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password field with show/hide toggle
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Live password strength feedback
                      Text(
                        'Password Strength: ${_passwordStrength()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _strengthColor(),
                        ),
                      ),
                      const SizedBox(height: 5),

                      Text(
                        _passwordAdvice(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _confirmController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }

                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Birth Date',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        validator: (_) =>
                            _birthDate == null ? 'Pick your birth date' : null,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 25),

                      ElevatedButton(
                        onPressed: _submitting ? null : _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Join the Mansion',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                      const SizedBox(height: 28),

                      const Divider(),
                      const SizedBox(height: 15),

                      // Signup Coach section with preset tips and fake loading
                      const Text(
                        'Signup Coach',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 6),

                      const Text(
                        'Get helpful signup tips. These are preset demo tips, not live AI responses.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 18),

                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Choose a tip category',
                          prefixIcon: Icon(Icons.lightbulb),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'password_help',
                            child: Text('Password Help'),
                          ),
                          DropdownMenuItem(
                            value: 'email_help',
                            child: Text('Email Help'),
                          ),
                          DropdownMenuItem(
                            value: 'account_help',
                            child: Text('Account Safety'),
                          ),
                          DropdownMenuItem(
                            value: 'missing_tip',
                            child: Text('Test Error'),
                          ),
                        ],
                        // Disabled while a tip is loading
                        onChanged: _loading
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() {
                                    _category = value;
                                    _tip = '';
                                    _tipError = '';
                                  });
                                }
                              },
                      ),
                      const SizedBox(height: 16),

                      OutlinedButton.icon(
                        onPressed: _loading ? null : _getTip,
                        icon: const Icon(Icons.tips_and_updates),
                        label: const Text('Get a Signup Tip'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Loading spinner
                      if (_loading)
                        const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Loading a sample tip...'),
                          ],
                        ),

                      // Tip result box
                      if (_tip.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE7F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Preset Demo Tip',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(_tip),
                            ],
                          ),
                        ),

                      // Error message with a retry button
                      if (_tipError.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              _tipError,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: _getTip,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Choose another category and try again.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      const Text(
                        'This app is a local demo. No personal information is sent to an AI service.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, required this.userName});

  final String userName;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('\u{1F383}', style: TextStyle(fontSize: 72)),
                Text(
                  'Welcome, ${widget.userName}!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Your haunted guest pass is confirmed.'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Back to the Foyer'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
        ],
      ),
    );
  }
} 