import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/features/worker/worker_screen.dart';
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
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.blue),
                      headingTextStyle: CustomTextStyles.s16w400cw,
                      columns: const [
                        DataColumn(
                          label: Text('№'),
                          numeric: true,
                        ),
                        DataColumn(label: Text('ФИО')),
                        DataColumn(label: Text('Мекеме')),
                        DataColumn(label: Text('Жұмысы')),
                        DataColumn(label: Text('Телефон')),
                        DataColumn(label: Text('Құжаты берілді')),
                      ],
                      rows: state.data.data!.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.id.toString())),
                            DataCell(Text('${item.surname} ${item.name}')),
                            DataCell(Text(item.org!.nameKk ?? '')),
                            DataCell(Text(item.job ?? '')),
                            DataCell(Text(item.phone ?? '')),
                            DataCell(Text(item.crust?.updatedAt ?? '')),
                          ],
                        );
                      }).toList(),
                    ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerScreen(),
              ),
            );
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
