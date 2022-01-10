import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/locator.dart';
import 'package:health/utils/dialogeManager/dialogModels.dart';
import 'package:health/utils/dialogeManager/dialogService.dart';
import 'package:health/utils/enums.dart';
import 'package:health/utils/router/navigationService.dart';
import 'package:health/utils/router/routeNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final ProgressService _progressService = locator<ProgressService>();
  final NavigationService _navigationService = locator<NavigationService>();
  ProgressResponse response;
  String _name;
  String get name => _name;

  String _uid;
  String get uid => _uid;

  String _phoneNumber;
  String get phoneNumber => _phoneNumber;

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map((user) => user.uid);

  // GET UID
  getCurrentUID() {
    var data = _firebaseAuth.currentUser;
    return data.uid.toString();
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('the user id is ${user.uid.toString()}');
      _name = user.displayName.toString();
      _uid = user.uid.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userIdentity', uid);
      // prefs.setString('password', password);
      prefs.setString('userName', user.displayName.toString());
      return LoggedInStatus.loggedIn;
    } else {
      print('error');
      return LoggedInStatus.loggedOut;
    }
  }

  // Email & Password Sign Up
  Future<dynamic> createUserWithEmailAndPassword(
      String email, String password, String name, String phoneNumber) async {
    _progressService.loadingDialog();
    checkSession().then((value) async {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        //FirebaseUser? user = await FirebaseAuth.instance.currentUser.call();
        if (value != null) {
          var user = _firebaseAuth.currentUser;
          updateUserName(name, email, phoneNumber, user)
              .then((value) => user.sendEmailVerification());
          String userIdentity = user.uid;
          _progressService.dialogComplete(response);
          print('Signed up user: $userIdentity');
          _progressService
              .showDialog(
                  title: "SignUp Successful",
                  description: "verfication mail has been to this email")
              .then((value) {
            _navigationService.navigateTo(SignInPageRoute);
          });
        }
      }).catchError((msg) {
        if (msg.code == 'weak-password') {
          //_progressService.dialogComplete(response);
          print('The password provided is too weak');
          _progressService.dialogComplete(response);
          _progressService.showDialog(
              title: '', description: "The password provided is too weak");
        } else if (msg.code == 'email-already-in-use') {
          // _progressService.dialogComplete(response);
          print('user already exist');
          _progressService.showDialog(
              title: '', description: "user already exist");
        } else {
          _progressService.dialogComplete(response);
          print(msg);
          _progressService.showDialog(title: '', description: msg);
        }
      });
    });
  }

  // Email & Password Sign In
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    _progressService.loadingDialog();
    checkSession().then((value) async {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        if (error.code == 'user-not-found') {
          //_progressService.dialogComplete(response);
          print('No user found for this email');
          _progressService.dialogComplete(response);
          _progressService.showDialog(
              title: '', description: "user does not exist");
        } else if (error.code == 'wrong-password') {
          //_progressService.dialogComplete(response);
          print('Wrong password');
          _progressService.dialogComplete(response);
          _progressService.showDialog(
              title: '', description: "Wrong password ");
        } else {
          _progressService.dialogComplete(response);
          print(error);
          _progressService.showDialog(title: '', description: error);
        }
      }).then((value) async {
        print('$value');
        User user = FirebaseAuth.instance.currentUser;
        if (user.displayName != null && !user.emailVerified) {
          _progressService.dialogComplete(response);
          user.sendEmailVerification().then(
              (value) => print("verfication mail has been to this email"));
          return _progressService.showDialog(
              title: "account not verified",
              description: "verfication mail has been to this email");
        } else {
          _progressService.dialogComplete(response);
          _firebaseAuth.authStateChanges().listen((user) async {
            if (user.displayName != null) {
              _name = user.displayName.toString();
              _uid = user.uid.toString();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('userIdentity', uid);
              prefs.setString('password', password);
              prefs.setString('name', user.displayName.toString());
            }
          });
          _navigationService.navigateReplacementTo(HomePageRoute);
        }
      });
    });
  }

  //update user
  Future updateUserName(
      String name, String email, String phoneNumber, User currentUser) async {
    var userId = currentUser.uid;
    await currentUser.updateDisplayName(name);
    await currentUser.reload();
    await firestoreInstance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          firestoreInstance.collection('users').doc(userId);
      await reference.set({
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "userId": userId,
      });
    });
  }

  // Sign Out
  signOut() async {
    await _firebaseAuth.signOut().then((value) => onAuthStateChanged);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Reset Password
  Future<dynamic> forgotpassword(String email) async {
    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .catchError((error) {
      print(error);
      _progressService.showDialog(title: "", description: "invalid email");
    }).then((value) {
      print("Link to reset password has been sent");
    });
    return _progressService.showDialog(
        title: "", description: "Link to reset password has been sent");
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  // Future convertUserWithEmail(
  //     String email, String password, String name) async {
  //   final currentUser = _firebaseAuth.currentUser;

  //   final credential =
  //       EmailAuthProvider.credential(email: email, password: password);
  //   await currentUser.linkWithCredential(credential);
  //   await updateUserName(name, currentUser);
  // }

  resetpassword(String oldPassword, String newPassword) {
    _progressService.loadingDialog();
    checkSession().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String getoldPassword = prefs.getString('password') ?? "";
      if (getoldPassword != oldPassword) {
        _progressService.dialogComplete(response);
        return _progressService.showDialog(
            title: "", description: "wrong old password");
      } else {
        User user = FirebaseAuth.instance.currentUser;
        await user.updatePassword(newPassword).then((value) {
          _progressService.dialogComplete(response);
          prefs.setString('password', newPassword);
          return _progressService.showDialog(
              title: "", description: "password successfully changed");
        }).catchError((error) {
          print(error);
          _progressService.dialogComplete(response);
          return _progressService.showDialog(
              title: "invalid", description: "try later");
        });
      }
    });
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
