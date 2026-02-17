import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: const Text('Landing Page')),
      backgroundColor: const Color(0xFFFBF7F0), //color referenced from initial design
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //adding logo here
              Image.asset(
                'assets/images/LOGO.png',
                height: 120,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 70),
                  const Text(
                    'R',
                    style: TextStyle(
                      fontSize: 42,
                      fontFamily: 'Amoresa',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const Text(
                    'ENTAHANAN',
                    style: TextStyle(
                      fontSize: 42,
                      fontFamily: 'Perandory',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              const Text(
                'BECAUSE A HOME SHOULD NOT BE TOO HARD TO MANAGE.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 0,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height:50),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9B6A44),
                    foregroundColor: Color(0xFFFFFFFF),
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5, //shadow elevation
                  ),
                  child: const Text('GET STARTED')
              )
            ],
          ),
        )
    );
  }
}