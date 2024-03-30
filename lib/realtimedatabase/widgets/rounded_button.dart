import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? ontap;
  final Color? bgColor;
  final bool? loading;

  const RoundedElevatedButton({super.key, this.text, this.ontap, this.loading, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration:  BoxDecoration(
          color: bgColor ?? Colors.red,
          borderRadius:const BorderRadiusDirectional.all(Radius.circular(10))
        ),
        child: Center(
          child:loading ?? false ?const CircularProgressIndicator(color: Colors.white,): Text(
            "$text",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
