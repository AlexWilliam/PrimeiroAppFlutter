import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:primeiro_app_fluuter/screens/home_screen.dart';
import 'package:primeiro_app_fluuter/screens/register_screen.dart';
import 'package:primeiro_app_fluuter/screens/reset_password_modal.dart';
import 'package:primeiro_app_fluuter/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

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
                      controller: _emailController,
                      onChanged: (value) {
                        _emailController.value = _emailController.value
                            .copyWith(
                              text: value.toLowerCase(),
                              selection: TextSelection.collapsed(
                                offset: value.length,
                              ),
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
                    ElevatedButton(
                      onPressed: () {
                        _authService
                            .enterUser(
                              email: _emailController.text,
                              pass: _passwordController.text,
                            )
                            .then((String? error) {
                              if (error != null) {
                                final success = error.contains('sucesso');
                                final snackBar = SnackBar(
                                  content: Text(error),
                                  backgroundColor: (!success)
                                      ? Colors.red
                                      : Colors.green,
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
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
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final credential = await signingWithGoogle();

                          if (context.mounted && credential.user != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(user: credential.user!),
                              ),
                            );
                          }
                        } on PlatformException catch (e) {
                          // Usuário cancelou o fluxo de login.
                          if (e.code == GoogleSignIn.kSignInCanceledError) {
                            return;
                          }

                          if (context.mounted) {
                            String msg;
                            // Erro 10 = DEVELOPER_ERROR: SHA-1 ou nome do pacote incorretos no Firebase.
                            if (e.code == '10') {
                              msg =
                                  'Configuração incorreta. Adicione a impressão digital SHA-1 do app '
                                  'no Firebase (Configurações do projeto > Seus apps > Android). '
                                  'No terminal: cd android && ./gradlew signingReport';
                            } else {
                              msg = 'Falha ao entrar com Google: ${e.message ?? e.code}';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 6),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro inesperado: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Entrar com Google'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text('Ainda não tem conta? Crie uma conta'),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ResetPasswordModal();
                          },
                        );
                      },
                      child: Text('Esqueceu sua senha?'),
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

  /// Web Client ID do Firebase (obrigatório para o token ser aceito pelo Firebase Auth).
  static const _serverClientId =
      '605253573366-r0pgq2aa1j2ke70ojaolm18obq2csljt.apps.googleusercontent.com';

  Future<UserCredential> signingWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: ['email'],
      serverClientId: _serverClientId,
    ).signIn();

    if (googleUser == null) {
      throw PlatformException(
        code: GoogleSignIn.kSignInCanceledError,
        message: 'Login com Google cancelado pelo usuário',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
