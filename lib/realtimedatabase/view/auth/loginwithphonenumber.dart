import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tech/realtimedatabase/utils/utils.dart';
import 'package:firebase_tech/realtimedatabase/view/home_screen.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading1 = false;
  bool loading2 = false;
  final auth = FirebaseAuth.instance;
  String? verifyId;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: "Enter Your Mobile Number ex.+914545454554",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          setState(() {
                            loading1 = true;
                          });
                          await auth.verifyPhoneNumber(
                            phoneNumber:
                                _phoneNumberController.text.toString().trim(),
                            verificationCompleted: (v) {
                              setState(() {
                                loading1 = false;
                              });
                            },
                            verificationFailed: (v) {
                              Utils().toastMessage(
                                  "Getting a $v", Colors.red, Colors.white);
                              setState(() {
                                loading1 = false;
                              });
                            },
                            codeSent: (verificationId, forceResendingToken) {
                              setState(() {
                                loading1 = false;
                                verifyId = verificationId;
                              });
                            },
                            codeAutoRetrievalTimeout: (verificationId) {
                              Utils().toastMessage(verificationId,
                                  Colors.transparent, Colors.white);
                              setState(() {
                                loading1 = false;
                              });
                            },
                          );
                        },
                        icon: loading1
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.navigate_next_sharp)))),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter 6 digit otp ex.543454",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        setState(() {
                          loading2 = true;
                        });
                        final credential = PhoneAuthProvider.credential(
                          verificationId: verifyId ?? "",
                          smsCode: _otpController.text.toString(),
                        );

                        await auth
                            .signInWithCredential(credential)
                            .then((value) {
                          setState(() {
                            loading2 = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        });
                      },
                      icon: const Icon(Icons.navigate_next_sharp))),
              controller: _otpController,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
