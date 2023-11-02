import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/profile/profile_cubit.dart';
import 'package:omg/features/profile/profile_state.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(context: context)..getProfile(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final profileCubit = BlocProvider.of<ProfileCubit>(context);
              if (state is ProfileLoading) {
                return const LoadingWidget();
              } else if (state is ProfileLoaded) {
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
                            Text(
                                '${state.data.surname} ${state.data.name} ${state.data.lastname}'),
                            Text(state.data.email),
                            Text(state.data.status),
                            ElevatedButton(
                              onPressed: () {
                                ProfileCubit(context: context).logout();
                              },
                              child: const Text('Шығу'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ProfileCubit(context: context).newUser();
                              },
                              child: const Text('Жаңа мұғалім тіркеу'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ProfileCubit(context: context).goToGroups();
                              },
                              child: const Text('Емтихандар'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    await profileCubit.getProfile();
                  },
                );
              } else {
                return const ErrorColumn();
              }
            },
          ),
        ),
      ),
    );
  }
}
