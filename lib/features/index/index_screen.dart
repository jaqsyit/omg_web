import 'package:flutter/material.dart';
import 'package:omg/constants/styles.dart';

class IndexScreen extends StatelessWidget {
  final String? title;
  final String? selectedDay;

  const IndexScreen({Key? key, this.title, this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth > 600;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(50),
                    width: isLargeScreen
                        ? 1280
                        : MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 50),
                          child: Image.asset(
                            'assets/img/logo_round.jpeg',
                            scale: 2,
                          ),
                        ),
                        const Text(
                          'Қош келдіңіз!!!',
                          style: CustomTextStyles.s20w500cb,
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Коорпоративті Оқу Орталығы',
                          style: CustomTextStyles.s26w700cb,
                        ),
                        const SizedBox(height: 100),
                        Container(
                          margin: const EdgeInsets.only(right: 50),
                          height: 60,
                          width: 250,
                          child: ElevatedButton(
                            style: AppStyles.activeButton,
                            onPressed: () {},
                            child: const Text(
                              'Емтиханды бастау',
                              style: CustomTextStyles.s20w400cw,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
