import 'package:ai_coach/core/network/custom_response.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  //initialize necessary modules
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;
  FirebaseFunctions cloudFunctions = FirebaseFunctions.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  ///Function for creating a user and adding him to firestore afterwards
  Future<CustomResponse> createUser(
      {required UserModel user, required String password}) async {
    bool checkUsermane = await searchUsername(
        username: user
            .username); //check if username is taken first with cloud functions
    UserCredential userCred;
    if (checkUsermane == false) {
      try {
        userCred = await firebaseAuthInstance.createUserWithEmailAndPassword(
            email: user.mail, password: password);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "weak-password":
            return CustomResponse(
                status: false, error: "The password provided is too weak.");
          case "email-already-in-use":
            return CustomResponse(
                status: false,
                error: 'The account already exists for that email.');
          case "invalid-email":
            return CustomResponse(
                status: false, error: 'The email provided is invalid.');
          case "operation-not-allowed":
            return CustomResponse(
                status: false,
                error: 'Email/password accounts are not enabled');
          default:
            return CustomResponse(
                status: false,
                error: 'Something went wrong while creating user');
        }
      }

      String userUid = userCred.user!.uid;
      await addUserToFirestore(
          user: user, uid: userUid); //Add user to firestore

      return CustomResponse(
          status: true, data: UserModel(username: user.username));
    } else {
      return CustomResponse(status: false, error: 'Username Already Taken');
    }
  }

  ///Function to add an userModel to collection of firestore
  Future<void> addUserToFirestore(
      {required UserModel user, required String uid}) async {
    UserModel userProfile = UserModel(username: user.username);
    await userCollection.doc(uid).set(userProfile.toJson());
  }

  Future<bool> searchUsername({required String username}) async {
    final result = await cloudFunctions.httpsCallable('findUsername').call(
      {
        "username": username,
      },
    );
    Map<String, dynamic> response = result.data as Map<String, dynamic>;
    //response type => {result: true}
    return response["result"];
  }

  ///Function for signing in an user
  Future<CustomResponse> signIn(
      {required UserModel user, required String password}) async {
    try {
      await firebaseAuthInstance.signInWithEmailAndPassword(
          email: user.mail, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-credential":
          return CustomResponse(
              status: false, error: 'Email or password is incorrect');
        case "wrong-password":
          return CustomResponse(
              status: false, error: 'Email or password is incorrect');
        case "user-not-found":
          return CustomResponse(
              status: false, error: 'Email or password is incorrect');
        case "invalid-email":
          return CustomResponse(
              status: false, error: 'Email or password is incorrect');
        default:
          return CustomResponse(
              status: false, error: 'Something went wrong while signing in');
      }
    }
    return await getCurrentUser();
  }

  Future<CustomResponse> signOut() async {
    try {
      await firebaseAuthInstance.signOut();
      return CustomResponse(status: true, data: "Successfully logged out");
    } catch (e) {
      return CustomResponse(status: false, error: e.toString());
    }
  }

  Future<CustomResponse> getCurrentUser() async {
    if (await isLoggedIn()) {
      DocumentSnapshot userDoc =
          await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();
      UserModel userModel =
          UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      return CustomResponse(status: true, data: userModel);
    } else {
      return CustomResponse(status: false, error: "Not Logged in");
    }
  }

  Future<bool> isLoggedIn() async {
    User? currentUser = firebaseAuthInstance.currentUser;
    if (currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
