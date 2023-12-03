import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_api_integration/res/components/round_button.dart';
import 'package:riverpod_api_integration/state/signup_state.dart';
import 'package:riverpod_api_integration/utils/utils.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          SignupState state = ref.watch(signUpProvider);
          if (state is SignupInitialState) {
            return signupUI(context);
          }

          if (state is SignupLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SignupLoadedState) {
            Future.delayed(Duration.zero, () {
              context.go('/home');
            });
          }

          if (state is SignupErrorState) {
            return Text(state.message.toString());
          }

          return Text('No state found');
        },
      ),
    );
  }

  Widget signupUI(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

    return SafeArea(
      child: Column(
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
              Utils.fieldFocusChange(
                  context, emailFocusNode, passwordFocusNode);
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
                  Utils.snackBar('Please enter email', context);
                } else if (_passwordController.text.isEmpty) {
                  Utils.snackBar('Please enter password', context);
                } else if (_passwordController.text.length < 6) {
                  Utils.snackBar('Please enter 6 digit password', context);
                } else {
                  Map data = {
                    'email': _emailController.text.toString(),
                    'password': _passwordController.text.toString()
                  };
                  ref.read(signUpProvider.notifier).createUser(data);
                }
              },
              text: 'SignUp')
          // RoundButton(
          //   title: 'Sign Up',
          //   // loading: authViewModel.signUpLoading,
          //   onpress: () {
          //     if (_emailController.text.isEmpty) {
          //       Utils.flashBarErrorMessage('Please enter email', context);
          //     } else if (_passwordController.text.isEmpty) {
          //       Utils.flashBarErrorMessage('Please enter password', context);
          //     } else if (_passwordController.text.length < 6) {
          //       Utils.flashBarErrorMessage(
          //           'Please enter 6 digit password', context);
          //     } else {
          //       Map data = {
          //         'email': _emailController.text.toString(),
          //         'password': _passwordController.text.toString()
          //       };
          //       authViewModel.registerApi(data, context);

          //       print('-----------user Registered----------');
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
