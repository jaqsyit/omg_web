import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/features/group_edit/group_edit_screen.dart';
import 'package:omg/features/groups/groups_cubit.dart';
import 'package:omg/features/groups/groups_state.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupsCubit(context: context)..getGroups(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<GroupsCubit, GroupsState>(
            builder: (context, state) {
              final profileCubit = BlocProvider.of<GroupsCubit>(context);
              if (state is GroupsLoading) {
                return const LoadingWidget();
              } else if (state is GroupsLoaded) {
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
                        DataColumn(label: Text('Басталуы')),
                        DataColumn(label: Text('Пән')),
                        DataColumn(label: Text('Тобы')),
                        DataColumn(label: Text('Комиссия')),
                      ],
                      rows: state.data.data.map((item) {
                        String examDuration =
                            '${DateFormat('HH:mm').format(item.start)}-${DateFormat('HH:mm').format(item.end)} ${DateFormat('dd.MM.yyyy').format(item.start)}';
                        return DataRow(cells: [
                          DataCell(
                            Text(item.id.toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupEditScreen(group: item)),
                              );
                            },
                          ),
                          DataCell(
                            Text(examDuration),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupEditScreen(group: item)),
                              );
                            },
                          ),
                          DataCell(
                            Text(item.subject),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupEditScreen(group: item)),
                              );
                            },
                          ),
                          DataCell(
                            Text(item.chin),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupEditScreen(group: item)),
                              );
                            },
                          ),
                          DataCell(
                            Text(item.commission),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupEditScreen(group: item)),
                              );
                            },
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              } else if (state is GroupsError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    await profileCubit.getGroups();
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
                builder: (context) => GroupEditScreen(),
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
