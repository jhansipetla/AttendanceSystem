import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'signin_screen.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Management System',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/dashboard': (context) =>
            const DashboardScreen(userType: '', username: ''),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedUserType = 'Student';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Attendance Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // User Type Selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedUserType = 'Student'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selectedUserType == 'Student'
                                    ? Colors.blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Student',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedUserType == 'Student'
                                      ? Colors.white
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedUserType = 'Faculty'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selectedUserType == 'Faculty'
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Faculty',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedUserType == 'Faculty'
                                      ? Colors.white
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login Form
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${selectedUserType} Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: selectedUserType == 'Student'
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (selectedUserType == 'Student')
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'New Student? Sign In Here',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Register Number',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (usernameController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(
                                      userType: selectedUserType,
                                      username: usernameController.text,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedUserType == 'Student'
                                  ? Colors.blue
                                  : Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              final regNoCtrl = TextEditingController();
                              final phoneCtrl = TextEditingController();
                              final newPassCtrl = TextEditingController();
                              final confirmCtrl = TextEditingController();
                              await showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Reset Password'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: regNoCtrl,
                                            decoration: const InputDecoration(
                                              labelText: 'Register Number',
                                              prefixIcon: Icon(Icons.badge),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: phoneCtrl,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              labelText: 'Phone Number',
                                              prefixIcon: Icon(Icons.phone),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: newPassCtrl,
                                            obscureText: true,
                                            decoration: const InputDecoration(
                                              labelText: 'New Password',
                                              prefixIcon: Icon(Icons.lock_reset),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: confirmCtrl,
                                            obscureText: true,
                                            decoration: const InputDecoration(
                                              labelText: 'Confirm Password',
                                              prefixIcon: Icon(Icons.lock),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final regNo = regNoCtrl.text.trim();
                                          final phone = phoneCtrl.text.trim();
                                          final np = newPassCtrl.text;
                                          final cp = confirmCtrl.text;
                                          if (regNo.isEmpty || phone.isEmpty || np.isEmpty || cp.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('All fields are required')),
                                            );
                                            return;
                                          }
                                          if (np != cp) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Passwords do not match')),
                                            );
                                            return;
                                          }
                                          // TODO: Call backend POST /auth/reset-password with { regNo, phone, newPassword: np }
                                          // On success:
                                          if (context.mounted) Navigator.pop(ctx);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Password reset. Please login.')),
                                            );
                                          }
                                        },
                                        child: const Text('Reset Password'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Forgot password?'),
                          ),
                        ),
                      ],
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
