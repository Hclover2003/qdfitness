import 'package:firebase_auth/firebase_auth.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

//define methods that will interact with firebase for us
class AuthService {
  //gets an instance of FirebaseAuth object (_ means private)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user; private function
  AppUser _userFromFirebaseUser(User user) {
    print(user);
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //auth change user stream (get a stream of Users(firebase default) and map each into our own AppUser(model))
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in anon
  Future<AppUser> signInAnon() async {
    try {
      //the signinanon method returns a usercredential object,
      //which has properties that let us access the user object
      //knows where to go because of google.json file

      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future<AppUser> signinWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AppUser> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    // Trigger the authentication flow
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    // Obtain the auth details from the request
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print("wrong password");
        } else if (e.code == 'invalid-credential') {
          print("account doesn't exist");
        }
      } catch (e) {
        print("no!");
      }
    }
    await DatabaseService(uid: user.uid)
        .createUserData(user.displayName, user.uid);
    await DatabaseService(uid: user.uid).createNewSummary();
    return _userFromFirebaseUser(user);
  }

  //register with email & password AND create doc in database
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create new document for user with the uid
      await DatabaseService(uid: user.uid).createUserData(name, user.uid);
      await DatabaseService(uid: user.uid).createNewSummary();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
