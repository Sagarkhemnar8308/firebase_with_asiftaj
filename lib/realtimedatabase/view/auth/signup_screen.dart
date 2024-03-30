import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/view/auth/login_screen.dart';
import 'package:firebase_tech/realtimedatabase/view/home_screen.dart';
import 'package:firebase_tech/realtimedatabase/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final _message = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Signup Screen "),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
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
                text: 'Sign up',
                loading: loading,
                ontap: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    auth
                        .createUserWithEmailAndPassword(
                            email: _emailcontroller.text.toString(),
                            password: _passwordcontroller.text.toString())
                        .then((value) => {
                              _message.toastMessage("Successfully signup",
                                  Colors.green, Colors.white),
                              setState(() {
                                loading = false;
                              }),
                            })
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(
                          error.toString(), Colors.red, Colors.white);
                      setState(() {
                        loading = false;
                      });
                      return Future.delayed(Duration.zero);
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text('Log in'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
