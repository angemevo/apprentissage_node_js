import 'package:flutter/material.dart';
import 'package:note_app/providers/auth_provider.dart';
import 'package:note_app/screens/auth/login_screen.dart';
import 'package:note_app/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if(!_formKey.currentState!.validate()) return;

    print('🟢 Nom: ${_nameController.text}');
    print('🟢 Email: ${_emailController.text}');
    print('🟢 Password: ${_passwordController.text}');
    print('🟢 Password length: ${_passwordController.text.length}');
    
    final authProvider = Provider.of<AuthProvider>(context, listen : false);

    final succes = await authProvider.register(
      nom: _nameController.text.trim(),
      email: _emailController.text.trim(), 
      password: _passwordController.text
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
                    Icons.person_add_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Remplisez les informations ci-dessous',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(height: 48),

                  // Nom
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom complet',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),

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
                    controller: _passwordController,
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
                      if (value.length < 6) {
                        return 'Votre mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24,),

                  // Confirmer le Mot de passe 
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText:  'Confirmé le Mot de passe ',
                      prefixIcon: Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24,),

                  // Bouton d'inscription
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _register,
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
                              'S\'inscrire',
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
                      Text('Déja un compte ?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen()
                            )
                          );
                        },
                        child: Text(
                          'Se connecter',
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