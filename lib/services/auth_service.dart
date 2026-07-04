import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Récupère l'utilisateur actuellement connecté (null si personne n'est connecté)
  User? get currentUser => _auth.currentUser;

  // Flux qui écoute les changements d'état de connexion (connecté / déconnecté)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inscription avec email et mot de passe
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Connexion avec email et mot de passe
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}