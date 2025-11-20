import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      controller: _nameController,
                      decoration: InputDecoration(hintText: 'Nome Completo'),
                    ),
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
                      decoration: InputDecoration(hintText: 'E-mail'),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: 'Senha'),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(hintText: 'Confirmar Senha'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // 🔴 Fundo vermelho
                              foregroundColor: Colors.white, // ⚪ Texto branco
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // 🔴 Fundo vermelho
                              foregroundColor: Colors.white, // ⚪ Texto branco
                            ),
                            onPressed: () {
                              if(_passwordController.text == _confirmPasswordController.text){
                                _authService.registerUser(name: _nameController.text, email: _emailController.text, pass: _passwordController.text)
                                  .then((String? error) {
                                    if(!context.mounted) return;

                                    if(error != null) {
                                      final snackBar = SnackBar(content: Text(error), backgroundColor: Colors.red);
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }else{
                                      Navigator.pop(context);
                                    }
                                  });
                              }else{
                                final snackBar = SnackBar(content: Text('As senhas não correspondem!'), backgroundColor: Colors.red);
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: Text('Registrar'),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
