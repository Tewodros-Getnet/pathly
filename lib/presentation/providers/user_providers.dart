import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref){
  return UserRepository();
});

// family provider to fetch AppUser by uid
final userByIdProvider = FutureProvider.family<AppUser?,
       String>((ref, uid) async {
       final repo = ref.read(userRepositoryProvider);
       return await repo.getUser(uid);
});
