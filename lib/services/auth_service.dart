import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    Future<String?> enterUser({
        required String email,
        required String pass
    }) async {
        try {
            await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
            return 'Login realizado com sucesso';
        } on FirebaseAuthException catch (e) {
            return _handleAuthException(e);
        }

        return null;
    }

    Future<String?> registerUser({
        required String name, 
        required String email, 
        required String pass
    }) async {
        try {
            UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
            await userCredential.user!.updateDisplayName(name);
        } on FirebaseAuthException catch (e) {            
            return _handleAuthException(e);
        }

        return null;
    }

    Future<String?> redefinePassword({required String email}) async {
        try {
            await _firebaseAuth.sendPasswordResetEmail(email: email);
        } on FirebaseAuthException catch (e) {            
            return _handleAuthException(e);
        }

        return null;
    }

    Future<String?> logoutUser() async {
        try {
            await _firebaseAuth.signOut();
        } on FirebaseAuthException catch (e) {            
            return _handleAuthException(e);
        }

        return null;
    }

    Future<String?> deleteUser({
        required String pass
    }) async {
        try {
            await _firebaseAuth.signInWithEmailAndPassword(email: _firebaseAuth.currentUser!.email!, password: pass);
            await _firebaseAuth.currentUser!.delete();
        } on FirebaseAuthException catch (e) {        
            return _handleAuthException(e);
        }

        return null;
    }

    String _handleAuthException(FirebaseAuthException e) {
        switch (e.code) {
            case 'invalid-email':
                return 'Digite um e-mail válido';
            case 'user-not-found':
                return 'Usuário não encontrado';
            case 'wrong-password':
                return 'Senha inválida';
            case 'email-already-in-use':
                return 'O e-mail já está em uso';
            case 'weak-password':
                return 'Senha digitada é fraca';
        }

        return e.code;
    }
}
