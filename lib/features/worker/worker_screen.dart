import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/worker/worker_cubit.dart';
import 'package:omg/features/worker/worker_state.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';

class WorkerScreen extends StatefulWidget {
  WorkerScreen({Key? key}) : super(key: key);

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkerCubit(context: context)..loadedState(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<WorkerCubit, WorkerState>(
            builder: (context, state) {
              final profileCubit = BlocProvider.of<WorkerCubit>(context);
              if (state is WorkerLoading) {
                return const LoadingWidget();
              } else if (state is WorkerLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTextField(surnameController, 'Тегі'),
                          _buildTextField(nameController, 'Аты'),
                          _buildTextField(lastnameController, 'Әкесінің аты'),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              } else if (state is WorkerError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    // await profileCubit.loadedState();
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Толықтырыңыз';
            }
            return null;
          },
        ),
      ),
    );
  }
}
