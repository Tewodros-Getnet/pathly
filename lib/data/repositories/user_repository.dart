import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  /// Save new profile
  Future<void> saveUser(AppUser user) async {
    await _db.collection("users").doc(user.id).set(user.toMap());
  }

  /// Fetch one user by ID
  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }

  /// 🔥 THIS WAS THE BUG — FIXED HERE
  Future<AppUser?> getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _db.collection("users").doc(user.uid).get(); // <- FIXED
    return doc.exists ? AppUser.fromDoc(doc) : null;
  }

  /// Stream Firestore user in real-time
  Stream<AppUser?> streamCurrentUser() async* {
    await for (var user in FirebaseAuth.instance.authStateChanges()) {
      if (user == null) {
        yield null;
        continue;
      }

      final doc = await _db.collection("users").doc(user.uid).get(); // <- FIXED

      if (!doc.exists) {
        print("⚠ Creating missing profile for new user…");

        final newUser = AppUser(
          id: user.uid,
          name: user.email?.split("@")[0] ?? "User",
          email: user.email ?? "",
          role: "student",
          photoUrl: null,
          createdAt: DateTime.now(),
        );

        await saveUser(newUser);
        yield newUser;
      } else {
        yield AppUser.fromDoc(doc);
      }
    }
  }
}
