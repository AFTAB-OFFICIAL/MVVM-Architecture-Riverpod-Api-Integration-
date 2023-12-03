import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_api_integration/res/components/round_button.dart';
import 'package:riverpod_api_integration/state/login_state.dart';
import 'package:riverpod_api_integration/utils/utils.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _obsecurePassword.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          LoginState state = ref.watch(loginProvider);
          if (state is LoginInitialState) {
            return loginUI(context);
          }
          if (state is LoginLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoginErrorState) {
            Future.delayed(Duration.zero, () {
              Utils.snackBar(state.message, context);
            });

            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          if (state is LoginLoadedState) {
            Future.delayed(Duration.zero, () {
              context.go('/home');
            });
          }

          return Text('State not found');
        },
      ),
    );
  }

  Widget loginUI(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _emailController,
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email',
            labelText: 'Email',
            prefixIcon: Icon(
              Icons.alternate_email,
            ),
          ),
          onFieldSubmitted: (value) {
            Utils.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
          },
        ),
        ValueListenableBuilder(
            valueListenable: _obsecurePassword,
            builder: (context, value, child) {
              return TextFormField(
                obscureText: _obsecurePassword.value,
                obscuringCharacter: '*',
                controller: _passwordController,
                focusNode: passwordFocusNode,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_clock_rounded,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      _obsecurePassword.value = !_obsecurePassword.value;
                    },
                    child: Icon(
                      Icons.visibility_off,
                    ),
                  ),
                ),
              );
            }),
        SizedBox(
          height: height * 0.1,
        ),
        RoundButton(
            onpressed: () {
              if (_emailController.text.isEmpty) {
                Utils.snackBar('Please enter the email', context);
              } else if (_passwordController.text.isEmpty) {
                Utils.snackBar('Please enter the password', context);
              } else if (_passwordController.text.length < 6) {
                Utils.snackBar('Please enter 6 digit password', context);
              } else {
                Map data = {
                  'email': _emailController.text,
                  'password': _passwordController.text,
                };
                ref.read(loginProvider.notifier).loginUser(data);
              }
            },
            text: 'Login'),
        // RoundButton(
        //   title: 'Login',
        //   // loading: authViewModel.loading,
        //   onpress: () {
        //     if (_emailController.text.isEmpty) {
        //       Utils.flashBarErrorMessage('Please enter email', context);
        //     } else if (_passwordController.text.isEmpty) {
        //       Utils.flashBarErrorMessage('Please enter password', context);
        //     } else if (_passwordController.text.length < 6) {
        //       Utils.flashBarErrorMessage(
        //           'Please enter 6 digit password', context);
        //     } else {
        //       // Map data = {
        //       //   'email': _emailController.text.toString(),
        //       //   'password': _passwordController.text.toString()
        //       // };
        //       Map data = {
        //         'email': 'eve.holt@reqres.in',
        //         'password': 'cityslicka'
        //       };
        //       // authViewModel.loginApi(data, context);
        //       print('APi hit');
        //     }
        //   },
        // ),

        SizedBox(
          height: height * 0.02,
        ),
        InkWell(
          onTap: () {
            context.go('/signup');
            // Navigator.pushNamed(context, RoutesName.signUp);
          },
          child: Text(
            'Dont have an account? Sign Up',
          ),
        ),
      ],
    );
  }
}
