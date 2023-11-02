import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/workers/workers_cubit.dart';
import 'package:omg/features/workers/workers_state.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';

class WorkersScreen extends StatelessWidget {

  const WorkersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkersCubit(context: context)..getWorkers(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<WorkersCubit, WorkersState>(
            builder: (context, state) {
              final profileCubit = BlocProvider.of<WorkersCubit>(context);
              if (state is WorkersLoading) {
                return const LoadingWidget();
              } else if (state is WorkersLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Text(state.data.data!.first.surname!),
                    ],
                  ),
                );
              } else if (state is WorkersError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    await profileCubit.getWorkers();
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
