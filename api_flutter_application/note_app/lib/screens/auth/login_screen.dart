import 'package:flutter/material.dart';
import 'package:note_app/providers/auth_provider.dart';
import 'package:note_app/screens/auth/register_screen.dart';
import 'package:note_app/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordControler = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordControler.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if(!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen : false);

    final succes = await authProvider.login(
      email: _emailController.text.trim(), 
      password: _passwordControler.text.trim()
    );

    if (succes && mounted) {
      // Aller à la page d'acceuil 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen())
      );
    } else if (mounted) {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Erreur de connexion'),
          backgroundColor: Colors.red,
        )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo et titre
                  Icon(
                    Icons.note_alt_rounded,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Note App',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Connectez-vous pour continuer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(height: 48),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!value.contains('@')) {
                        return 'Email invalide';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),

                  // Mot de passe 
                  TextFormField(
                    controller: _passwordControler,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText:  'Mot de passe ',
                      prefixIcon: Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 8) {
                        return 'Votre mot de passe doit contenir au moins 8 caractères';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24,),

                  // Bouton de connnexion
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)
                          )
                        ),
                        child: authProvider.isLoading 
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white
                                ),
                              ),
                            )
                            : Text(
                              'Se connecter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            )
                      );
                    }
                  ),
                  SizedBox(height: 16),

                  // Lien vers inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pas encore de compte ?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen()
                            )
                          );
                        },
                        child: Text(
                          'S\'inscrire',
                          style: TextStyle(fontWeight: FontWeight.bold),  
                        ),
                      )
                    ],
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}