import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';

class TotalPayment extends StatefulWidget {
  const TotalPayment({super.key});

  @override
  State<TotalPayment> createState() => _TotalPaymentState();
}

class _TotalPaymentState extends State<TotalPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: PreferredSize(
              
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/yodha_admin.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              const Text('Admin', 
              style: TextStyle(
                color: Color.fromARGB(255, 247, 245, 245),
                fontWeight: FontWeight.bold,)
              ,)

            ],
          ),
        ),
      ),);
  }
}