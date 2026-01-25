import 'package:flutter/material.dart';
import 'package:note_app/providers/auth_provider.dart';
import 'package:note_app/providers/note_provider.dart';
import 'package:note_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les notes au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Provider.of<NoteProvider>(context, listen: false).fetchNote();
      } catch (e) {
        print('🔴 Erreur chargement notes: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur de chargement des notes'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  Future<void> _showCreateNoteDialog() async {
    final titreController = TextEditingController();
    final contenuController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nouvelle Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titreController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contenuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
                maxLines: 3,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titreController.text.isNotEmpty && contenuController.text.isNotEmpty) {
                  final noteProvider = Provider.of<NoteProvider>(context, listen: false);

                  final success = await noteProvider.createNote(
                    titre: titreController.text.trim(),
                    contenu: contenuController.text.trim()
                  );

                  Navigator.pop(context);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note crée avec succès'),
                        backgroundColor: Colors.green,
                      )
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(noteProvider.erromessage ?? 'Erreur'),
                        backgroundColor: Colors.red,
                      )
                    );
                  }
                }
              }, 
              child: Text('Créer'),
            )
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Notes'),
        centerTitle: true,
        actions: [
          // bouton de déconnexion
          IconButton(
            onPressed: () async {
              authProvider.logout();

              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen())
                );
              }
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),

      body: Consumer<NoteProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (notesProvider.notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined, 
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune Note',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Appuyer sur + pour créer une note',
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  )
                ],
              ),
            );
          }
          return RefreshIndicator(
              onRefresh: () => notesProvider.fetchNote(),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: notesProvider.notes.length,
                itemBuilder: (context, index) {
                  final note = notesProvider.notes[index];

                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        note.titre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: note.complete
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            note.contenu,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Crée le ${note.createdeAt.day}/${note.createdeAt.month}/${note.createdeAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600]
                            ),
                          )
                        ],
                      ),
                      leading: Checkbox(
                        value: note.complete,
                        onChanged: (value) {
                          notesProvider.updatedNote(id: note.id, complete: value);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Suppreime la note'
                              ),
                              content: Text(
                                'Etes-vous sûr de vouloir supprimer cette note ?'
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Annuler'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  child: Text(
                                    'Supprimer'
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red
                                  ),
                                )
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await noteProvider.deletedNote(id: note.id);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
        } ,
      ),
              
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateNoteDialog,
        icon: Icon(Icons.add),
        label: Text('Nouvelle Note'),
      ),
    );
  }
}