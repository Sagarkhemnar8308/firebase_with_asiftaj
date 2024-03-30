import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/view/auth/loginwithphonenumber.dart';
import 'package:firebase_tech/realtimedatabase/view/auth/signup_screen.dart';
import 'package:firebase_tech/realtimedatabase/view/home_screen.dart';
import 'package:firebase_tech/realtimedatabase/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  void login() {
    _auth
        .signInWithEmailAndPassword(
            email: _emailcontroller.text.toString(),
            password: _passwordcontroller.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("Login Successfully", Colors.green, Colors.white);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString(), Colors.red, Colors.white);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Login Screen "),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailcontroller,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return "please enter valid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Email *",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return "please enter password";
                    }
                    return null;
                  },
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password *",
                      prefixIcon: const Icon(Icons.password),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedElevatedButton(
                  text: 'Login',
                  loading: loading,
                  ontap: () {
                    if (_formkey.currentState?.validate() ?? false) {
                      setState(() {
                        loading = true;
                      });
                      login();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account ? "),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ));
                        },
                        child: const Text('Sign up'))
                  ],
                ),
                RoundedElevatedButton(  
                  text: "Login With PhoneNumber",
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginWithPhoneNumber(),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
