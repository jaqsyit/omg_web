import 'package:omg/models/groups_list_data.dart';

abstract class GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final GroupsListData data;

  GroupsLoaded({required this.data});

  // GroupsData get profileData => null;
}

class GroupsError extends GroupsState {
  final String? errMsg;

  GroupsError({this.errMsg});
}