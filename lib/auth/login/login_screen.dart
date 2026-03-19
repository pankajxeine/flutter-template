import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

// i10n
import '../../i10n/i10n.dart';

// core
import '/core/widgets/responsive_form_widget.dart';
import '/core/widgets//submit_button_widget.dart';

// constants
import '/constants/app_constants.dart';
import '/constants/app_key_constants.dart';

// routes
import '/routes/app_routes_constants.dart';
import '/app_router.dart';

//blocs
import 'bloc/login.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _loginFormKey = GlobalKey<FormBuilderState>(
    debugLabel: '__loginFormKey__',
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(
    debugLabel: '__loginScaffoldKey__',
  );

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final i10n = S.of(context)!;
    return ShadcnApp(
      home: Scaffold(
        headers: [
          // Use Shadcn AppBar in the Scaffold header area.
          AppBar(
            title: Text('Studes'),
            trailing: [
              // Trailing actions typically appear on the right.
              OutlineButton(
                density: ButtonDensity.icon,
                onPressed: () {},
                child: const Icon(Icons.search),
              ),
              OutlineButton(
                density: ButtonDensity.icon,
                onPressed: () {},
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
          // A divider beneath the AppBar to separate header and body.
          // Divider(),
        ],
        child: _buildBody(context, i10n),
      ),
    );
  }

  Widget _buildBody(BuildContext context, S i10n) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 980;
          final cardWidth = wide ? 1040.0 : 560.0;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardWidth),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(wide ? 32 : 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildWelcomeSection(context, i10n)),
                        Expanded(child: _buildAuthForm(context, i10n)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, S i10n) {
    return ColumnSuper(
      alignment: Alignment.topLeft,
      innerDistance: 16,
      children: [
        Row(
          children: [
            PrimaryBadge(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.lock,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back').xLarge.bold(),
                Text(
                  'Use the mock credentials to explore the admin shell.',
                ).small.muted(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthForm(BuildContext context, S i10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status == LoginStatus.loading ||
            state.status == LoginStatus.failure ||
            state.status == LoginStatus.success) {
          debugPrint("Latest status ${state.status}");
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Sign In').medium.bold(),
              const SizedBox(height: 6),
              Text(
                'Sign in to continue to ${AppConstants.appName}.',
              ).medium(color: Theme.of(context).colorScheme.primary),
              Form(
                onSubmit: (context, values) {
                  final String? username = loginTextFieldUsernameKey[values];
                  final String? password = loginTextFieldPasswordKey[values];
                  debugPrint("BEGIN: login form onSubmit with values $values");
                  if (username != null && password != null) {
                    debugPrint(
                      "BEGIN: submit event with values $username, $password",
                    );
                    _submitEvent(
                      context,
                      username: username,
                      password: password,
                    );
                  }
                },
                child: Column(
                  children: [
                    FormField<String>(
                      key: loginTextFieldUsernameKey,
                      label: Text(i10n.login_user_name).small,
                      // Compose validators with & (AND): both must pass.
                      validator:
                          const LengthValidator(min: 8) &
                          const SafePasswordValidator(
                            requireSpecialChar: false,
                            requireUppercase: false,
                            requireLowercase: false,
                          ),
                      showErrors: const {
                        FormValidationMode.changed,
                        FormValidationMode.submitted,
                      },
                      child: const TextField(obscureText: true),
                    ),
                    FormField<String>(
                      key: loginTextFieldPasswordKey,
                      label: Text(i10n.login_password).small,
                      // Cross-field validation: must equal the password field.
                      // CompareWith automatically re-validates when the
                      // referenced field (_passwordKey) changes.
                      validator: const NonNullValidator(
                        message: 'Please enter a password',
                      ),
                      showErrors: {
                        FormValidationMode.changed,
                        FormValidationMode.submitted,
                      },
                      child: TextField(obscureText: true),
                    ),
                    const Gap(24),
                    _submitButton(context, i10n),
                    // FormErrorBuilder(
                    //   builder: (context, errors, child) {
                    //     return PrimaryButton(
                    //       onPressed: errors.isEmpty
                    //           ? () => context.submitForm()
                    //           : null,
                    //       child: const Text('Submit'),
                    //     );
                    //   },
                    // ),
                    // FormInline<CheckboxState>(
                    //   key: loginTextFieldAgreeKey,
                    //   label: const Text('I agree to the terms'),
                    //   validator: const CompareTo.equal(
                    //     CheckboxState.checked,
                    //     message: 'You must agree',
                    //   ),
                    //   child: Align(
                    //     alignment: AlignmentDirectional.centerEnd,
                    //     child: Checkbox(
                    //       state: CheckboxState.unchecked,
                    //       onChanged: (value) {},
                    //     ),
                    //   ),
                    // ),
                    // const Gap(24),
                  ],
                ).gap(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _register(context, i10n),
                  _forgotPasswordLink(context, i10n),
                ],
              ),
              _orDivider(context, i10n),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_otpLoginButton(context, i10n)],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _forgotPasswordLink(BuildContext context, S i10n) {
    return SizedBox(
      child: TextButton(
        key: loginButtonForgotPasswordKey,
        onPressed: () => AppRouter().push(
          context,
          ApplicationRoutesConstants.forgotPassword,
        ),
        child: Text(i10n.password_forgot),
      ),
    );
  }

  Widget _submitButton(BuildContext context, S i10n) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        debugPrint(
          "BEGIN: login submit button listener username${state.username}",
        );
        if (state.status == LoginStatus.loading ||
            state.status == LoginStatus.failure ||
            state.status == LoginStatus.success) {
          showToast(
            context: context,
            builder: (BuildContext context, ToastOverlay overlay) {
              if (state is LoginLoadingState) {
                return SurfaceCard(
                  child: Basic(
                    title: Text(i10n.loading),
                    trailingAlignment: Alignment.center,
                  ),
                );
              } else if (state is LoginLoadedState) {
                debugPrint(
                  "BEGIN: login submit button listener LoginLoadedState",
                );
                return SurfaceCard(
                  child: Basic(
                    title: Text(i10n.success),
                    trailingAlignment: Alignment.center,
                  ),
                );
              } else if (state is LoginErrorState) {
                debugPrint(
                  "BEGIN: login submit button listener LoginErrorState",
                );
                return SurfaceCard(
                  child: Basic(
                    title: Text(i10n.failed),
                    trailingAlignment: Alignment.center,
                  ),
                );
              }
              overlay.close();
              return SizedBox.shrink();
            },
            // Position top-right.
            location: ToastLocation.topRight,
          );
          debugPrint(
            "END: login submit button listener username${state.username}",
          );
        }
      },
      child: FormErrorBuilder(
        builder: (context, errors, child) {
          return PrimaryButton(
            onPressed: errors.isEmpty ? () => context.submitForm() : null,
            child: const Text('Submit'),
          );
        },
      ),
      // child: SizedBox(
      //   width: double.infinity,
      //   child: PrimaryButton(
      //     key: loginButtonSubmitKey,
      //     child: Text(i10n.login_button),
      //     onPressed: () {
      //       debugPrint("BEGIN: login submit button onPressed");
      //       if (_loginFormKey.currentState!.saveAndValidate()) {
      //         final username = _loginFormKey.currentState!.value['username'];
      //         final password = _loginFormKey.currentState!.value['password'];
      //         _submitEvent(context, username: username, password: password);
      //       }
      //     },
      //   ),
      // ),
    );
  }

  void _submitEvent(
    BuildContext context, {
    required String username,
    required String password,
  }) {
    context.read<LoginBloc>().add(
      LoginFormSubmitted(username: username, password: password),
    );
  }

  Widget _validationZone(S i10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => current is LoginErrorState,
      builder: (context, state) {
        final font = Theme.of(context).typography.large.fontSize ?? 16;
        // final color = Theme.of(context).colorScheme.red;
        return Visibility(
          visible: state is LoginErrorState,
          child: Center(
            child: Text(
              i10n.failed,
              style: TextStyle(fontSize: font, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _orDivider(BuildContext context, S i10n) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Or continue with').medium(color: color),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }

  Widget _otpLoginButton(BuildContext context, S i10n) {
    return TextButton(
      key: const Key('loginButtonOtpKey'),
      onPressed: () =>
          AppRouter().push(context, ApplicationRoutesConstants.loginOtp),
      child: Text(i10n.login_with_email),
    );
  }

  Widget _register(BuildContext context, S i10n) {
    return SizedBox(
      child: TextButton(
        key: loginButtonRegisterKey,
        onPressed: () =>
            AppRouter().push(context, ApplicationRoutesConstants.register),
        child: Text(i10n.register),
      ),
    );
  }
}
