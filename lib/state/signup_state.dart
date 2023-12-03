import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_api_integration/repository/auth_repository.dart';

@immutable
abstract class SignupState {}

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignupState>(
    (ref) => SignUpNotifier());

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupLoadedState extends SignupState {}

class SignupErrorState extends SignupState {
  SignupErrorState({required this.message});
  final String message;
}

class SignUpNotifier extends StateNotifier<SignupState> {
  SignUpNotifier() : super(SignupInitialState());
  AuthRepository _repo = AuthRepository();

  createUser(data) async {
    try {
      state = SignupLoadingState();
      var response = _repo.registerUser(data);
      state = SignupLoadedState();
    } catch (e) {
      state = SignupErrorState(message: e.toString());
    }
  }
}
