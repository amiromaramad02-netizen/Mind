import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInWithApple();
  Future<UserModel?> signInWithEmail(String email, String password);
  Future<void> signOut();
  UserModel? get currentUser;
}

// Mock implementation for now
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(_currentUser);

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel?> signInWithApple() async {
    _currentUser = const UserModel(id: '1', email: 'apple@example.com', displayName: 'Apple User');
    return _currentUser;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    _currentUser = const UserModel(id: '2', email: 'google@example.com', displayName: 'Google User');
    return _currentUser;
  }

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    _currentUser = UserModel(id: '3', email: email, displayName: email.split('@')[0]);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
