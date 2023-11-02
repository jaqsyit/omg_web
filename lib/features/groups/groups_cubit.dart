import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/groups/groups_state.dart';
import 'package:omg/models/groups_list_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final BuildContext context;
  GroupsCubit({required this.context}) : super(GroupsLoading());

  Future<void> getGroups() async {
    if (state is! GroupsLoading) {
      emit(GroupsLoading());
    }

    final response = await NetworkHelper().get(url: GROUPS_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      final GroupsListData dataDecoded =
          GroupsListData.fromJson(decodedResponse);

      emit(GroupsLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(GroupsError(errMsg: response));
    } else {
      emit(GroupsError(errMsg: 'Unknown error!'));
    }
  }
}
