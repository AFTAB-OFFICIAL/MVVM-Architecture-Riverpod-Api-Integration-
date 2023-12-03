import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_api_integration/repository/auth_repository.dart';

@immutable
abstract class LoginState {}

final loginProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) => LoginNotifier());

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {}

class LoginErrorState extends LoginState {
  LoginErrorState({required this.message});
  final String message;
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginInitialState());
  AuthRepository _authRepository = AuthRepository();
  Future loginUser(data) async {
    try {
      state = LoginLoadingState();
      var response = await _authRepository.loginApi(data);
      state = LoginLoadedState();
    } catch (e) {
      state = LoginErrorState(message: e.toString());
      // return e;
    }
    print(state);
  }
}
