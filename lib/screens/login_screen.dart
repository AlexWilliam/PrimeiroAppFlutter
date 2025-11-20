import 'package:flutter/material.dart';
import 'package:primeiro_app_fluuter/screens/home_screen.dart';
import 'package:primeiro_app_fluuter/screens/register_screen.dart';
import 'package:primeiro_app_fluuter/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
          color: Colors.blue,
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    FlutterLogo(size: 75),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      onChanged: (value) {
                          _emailController.value = _emailController.value.copyWith(
                          text: value.toLowerCase(),
                          selection: TextSelection.collapsed(offset: value.length),
                        );
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                      )
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                      )
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _authService.enterUser(
                            email: _emailController.text,
                            pass: _passwordController.text
                        ).then((String? error) {
                          if(error != null) {
                            final success = error.contains('sucesso');
                            final snackBar = SnackBar(content: Text(error), backgroundColor: (!success) ? Colors.red : Colors.green);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Entrar'),
                    ),
                    SizedBox(height: 20),
                    /*ElevatedButton(
                      onPressed: () {},
                      child: Text('Entrar com Google'),
                    ),
                    SizedBox(height: 20),*/
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                      }, 
                      child: Text('Ainda não tem conta? Crie uma conta')),
                  ]
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
