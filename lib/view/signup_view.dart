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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);

 final  FocusNode emailFocusNode = FocusNode();
 final  FocusNode passwordFocusNode = FocusNode();

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
        title: const Text('Sign Up'),
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
            return const Center(
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

          return const Text('No state found');
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
                context,
                emailFocusNode,
                passwordFocusNode,
              );
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
                    prefixIcon: const Icon(
                      Icons.lock_clock_rounded,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        _obsecurePassword.value = !_obsecurePassword.value;
                      },
                      child: const Icon(
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
                Utils.snackBar(
                  'Please enter email',
                  context,
                );
              } else if (_passwordController.text.isEmpty) {
                Utils.snackBar(
                  'Please enter password',
                  context,
                );
              } else if (_passwordController.text.length < 6) {
                Utils.snackBar(
                  'Please enter 6 digit password',
                  context,
                );
              } else {
                Map data = {
                  'email': _emailController.text.toString(),
                  'password': _passwordController.text.toString()
                };
                ref.read(signUpProvider.notifier).createUser(
                      data,
                    );
              }
            },
            text: 'SignUp',
          )
        ],
      ),
    );
  }
}
