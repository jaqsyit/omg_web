import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/features/group_edit/group_edit_screen.dart';
import 'package:omg/features/groups/groups_cubit.dart';
import 'package:omg/features/groups/groups_state.dart';
import 'package:omg/models/groups_list_data.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late GroupsListData bufferData;

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
                bufferData = state.data;
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
                        DataColumn(label: Text('Жұмысшы')),
                      ],
                      rows: state.data.data!.map((item) {
                        String examDuration =
                            '${DateFormat('HH:mm').format(item.start!)}-${DateFormat('HH:mm').format(item.end!)} ${DateFormat('dd.MM.yyyy').format(item.start!)}';
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
                            Text(item.subject!),
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
                            Text(item.chin!),
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
                            Text(item.commission!),
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
                            Text(item.exam!.length.toString()),
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
            bufferData.data!.first.chin = 'ИТР';
            bufferData.data!.first.commission = 'Комиссия';
            bufferData.data!.first.createdAt = DateTime.now();
            bufferData.data!.first.end = DateTime.now();
            bufferData.data!.first.id = null;
            bufferData.data!.first.passedOn = 0;
            bufferData.data!.first.quantity = 30;
            bufferData.data!.first.start = DateTime.now();
            bufferData.data!.first.updatedAt = DateTime.now();
            bufferData.data!.first.userId = 1;
            bufferData.data!.first.exam = null;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupEditScreen(group: bufferData.data!.first),
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
