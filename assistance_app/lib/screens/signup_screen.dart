import 'package:flutter/material.dart';
import 'package:assistance_app/theme.dart';
import 'package:assistance_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isSignupSelected = true;
  bool isLoading = false;
  String? errorMessage;

  void signup() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        usernameController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'Username': usernameController.text,
            'email': emailController.text,
            'createdAt': FieldValue.serverTimestamp(),
          });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Account created!')));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Toggle buttons
                Center(
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        buildTab("Login", false),
                        buildTab("Sign Up", true),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Create an account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'create your new account and find more service',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textsecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                // Username
                TextFormField(
                  controller: usernameController,
                  decoration: inputDecoration('Username'),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter username' : null,
                ),
                SizedBox(height: 16),
                // Email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration('Email'),
                  validator:
                      (value) => value!.isEmpty ? 'Please enter email' : null,
                ),
                SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: inputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                    ),
                  ),
                  validator:
                      (value) =>
                          value!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                ),
                SizedBox(height: 24),
                // Sign up button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonprimary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child:
                        isLoading
                            ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                            : Text('Sign up', style: TextStyle(fontSize: 16)),
                  ),
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: 12),
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 20),
                Text('Or', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialButton('assets/facebook.png'),
                    SizedBox(width: 16),
                    socialButton('assets/google.png'),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already Have an Account? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget socialButton(String assetPath) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(assetPath, width: 24, height: 24),
    );
  }

  Widget buildTab(String label, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => isSignupSelected = label == "Sign Up");
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                (isSignupSelected && label == "Sign Up") ||
                        (!isSignupSelected && label == "Login")
                    ? AppColors.buttonprimary
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color:
                  (isSignupSelected && label == "Sign Up") ||
                          (!isSignupSelected && label == "Login")
                      ? AppColors.cardBackground
                      : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
