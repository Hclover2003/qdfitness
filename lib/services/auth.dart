import 'package:firebase_auth/firebase_auth.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/services/database.dart';

//define methods that will interact with firebase for us
class AuthService {
  //gets an instance of FirebaseAuth object (_ means private)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user; private function
  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid, dailyCalorieTotal: 0) : null;
  }

  //auth change user stream (get a stream of Users and map each into our own AppUser)
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
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
  Future signinWithEmailAndPassword(String email, String password) async {
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

  //register with email & password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create new document for user with the uid
      await DatabaseService(uid: user.uid).updateUserData(name);
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
