import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/change_pass/change_pass_screen.dart';
import 'package:omg/features/login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final passwordFocus = FocusNode();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // loginController.text = 'm.aqyn';
    // passwordController.text = '123123';
    // codeController.text = '744021';
    return BlocProvider(
      create: (_) => LoginCubit(context: context),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LoginCubit, bool>(
            builder: (context, state) {
              final loginCubit = BlocProvider.of<LoginCubit>(context);

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
                            'Коорпоративтік Оқу Орталығы',
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
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: codeController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Емтиханды бастау коды',
                                      ),
                                      maxLines: 1,
                                      validator: (text) {
                                        if (text != null) {
                                          if (text.isEmpty) {
                                            return 'Код еңгізіңіз';
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
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green),
                                        ),
                                        child: const Text(
                                          'Емтиханды бастау',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        onPressed: () async {
                                          await loginCubit.startTest(
                                              code: codeController.value.text);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200,
                                width: 2,
                                color: Colors.grey,
                              ),
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
                                          hintText: 'Пароль',
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
                                            'Кіру',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState != null) {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                await loginCubit.login(
                                                    login: loginController
                                                        .value.text,
                                                    password: passwordController
                                                        .value.text);
                                              } else {
                                                loginCubit.enableAutoValidate();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Тіркелу үшін директорға жолығыңыз',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePassScreen(),
                                            ),
                                          );
                                        },
                                        child:
                                            const Text('Құпиясөзді ауыстыру'),
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
