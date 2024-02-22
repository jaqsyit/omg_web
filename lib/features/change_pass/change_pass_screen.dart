import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/change_pass/change_pass_cubit.dart';

class ChangePassScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final passwordFocus = FocusNode();

  ChangePassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loginController.text = 'm.aqyn';
    passwordController.text = '123123';
    newPasswordController.text = '123132';
    codeController.text = '744021';
    return BlocProvider(
      create: (_) => ChangePassCubit(context: context),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ChangePassCubit, bool>(
            builder: (context, state) {
              final changePassCubit = BlocProvider.of<ChangePassCubit>(context);

              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.blue],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(50),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 900,
                    height: 600,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img/logo_round.jpeg',
                            scale: 2,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Корпоративтік Оқу Орталығы',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 60),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 330,
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: state
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: loginController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Логин',
                                        ),
                                        maxLines: 1,
                                        onEditingComplete: () {
                                          FocusScope.of(context)
                                              .requestFocus(passwordFocus);
                                        },
                                        validator: (text) {
                                          if (text != null) {
                                            if (text.isEmpty) {
                                              return 'Логин еңгізіңіз';
                                            } else if (text.length < 4) {
                                              return 'Кемінде 4 символ';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Құпиясөз',
                                        ),
                                        maxLines: 1,
                                        focusNode: passwordFocus,
                                        validator: (text) {
                                          if (text != null) {
                                            if (text.isEmpty) {
                                              return 'Құпиясөз енгізіңіз';
                                            } else if (text.length < 6) {
                                              return 'Кемінде 6 символ';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: newPasswordController,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Жаңа құпиясөз',
                                        ),
                                        maxLines: 1,
                                        focusNode: passwordFocus,
                                        validator: (text) {
                                          if (text != null) {
                                            if (text.isEmpty) {
                                              return 'Құпиясөз енгізіңіз';
                                            } else if (text.length < 6) {
                                              return 'Кемінде 6 символ';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 40,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                          ),
                                          child: const Text(
                                            'Құпиясөзді өзгерту',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState != null) {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                await changePassCubit.changePass(
                                                    login: loginController
                                                        .value.text,
                                                    password: passwordController
                                                        .value.text,
                                                    newPassword:
                                                        newPasswordController
                                                            .value.text);
                                              } else {
                                                changePassCubit
                                                    .enableAutoValidate();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Тіркелу үшін директорға жолығыңыз',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
