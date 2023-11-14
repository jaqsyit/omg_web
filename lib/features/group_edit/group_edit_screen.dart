import 'dart:convert';

import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/models/group_add_data.dart';
import 'package:omg/models/group_delete_data.dart';
import 'package:omg/models/groups_list_data.dart';
import 'package:omg/models/workers_list_data.dart' as workers;
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupEditScreen extends StatefulWidget {
  final Datum? group;
  GroupEditScreen({Key? key, this.group}) : super(key: key);

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  final TextEditingController commission = TextEditingController();
  final TextEditingController examDuration = TextEditingController();
  final TextEditingController searchWorkerController = TextEditingController();
  String selectedWorker = '1';
  String newChin = '';
  String newSubject = '';
  int quantity = 0;
  int passedOn = 0;
  int workerId = -1;
  late workers.WorkersListData workersList;

  DateTime? selectedDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = args.value;
    });
  }

  @override
  void initState() {
    super.initState();
    examDuration.text = '40';
    quantity = widget.group != null ? widget.group!.quantity! : 0;
    passedOn = widget.group != null ? widget.group!.passedOn! : 0;
    widget.group != null
        ? selectedTime = TimeOfDay(
            hour: widget.group!.start!.hour,
            minute: widget.group!.start!.minute)
        : null;
    widget.group != null ? selectedDate = widget.group!.start : null;
    widget.group != null ? newSubject = widget.group!.subject! : null;
    widget.group != null ? newChin = widget.group!.chin! : null;
    commission.text = widget.group == null ? '' : widget.group!.commission!;
  }

  @override
  void dispose() {
    commission.dispose();
    super.dispose();
  }

  TimeOfDay? selectedTime;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> newGroup(String? idGroup) async {
    DateTime newStart = DateTime(selectedDate!.year, selectedDate!.month,
        selectedDate!.day, selectedTime!.hour, selectedTime!.minute);
    DateTime newEnd =
        newStart.add(Duration(minutes: int.parse(examDuration.text)));

    final response = await NetworkHelper().post(url: GROUPS_URL, body: {
      'idGroup': idGroup != '' ? idGroup : null,
      'start': newStart.toString(),
      'end': newEnd.toString(),
      'subject': newSubject,
      'chin': newChin,
      'commission': commission.text,
      'quantity': quantity.toString(),
      'passed_on': passedOn.toString(),
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      final GroupEditData dataDecoded = GroupEditData.fromJson(decodedResponse);
      if (dataDecoded.success != null) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Емтихан'),
              content: const Text('Емтихан жаңартылды'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } else if (response is String) {
      print(response);
    } else {
      print('object');
    }
  }

  Future<void> newExam(int idGroup, int idWorker) async {
    final response = await NetworkHelper().post(url: EXAM_URL, body: {
      'group_id': idGroup.toString(),
      'worker_id': idWorker.toString(),
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);
      if (decodedResponse.containsKey('success')) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Емтихан'),
              content: const Text('Жұмысшы емтиханға қосылды'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } else if (response is String) {
      print(response);
    } else {
      print('object');
    }
  }

  Future<void> deleteGroup(int idGroup) async {
    final response = await NetworkHelper().delete(url: GROUPS_URL, parameters: {
      'id': idGroup.toString(),
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      final GroupDeleteData dataDecoded =
          GroupDeleteData.fromJson(decodedResponse);
      print(dataDecoded.success);
    } else if (response is String) {
      print(response);
    } else {
      print('object');
    }
  }

  Future<void> getAccessCode(int idGroup) async {
    final response =
        await NetworkHelper().get(url: ACCESS_CODES_URL, parameters: {
      'id': idGroup.toString(),
    });

    if (response is Response) {
      final body = json.decode(response.body);

      if (body['success'] != null) {
        final String fileUrl = body['success'];
        print(fileUrl);

        if (kIsWeb) {
          html.window.open(fileUrl, '_blank');
        } else {
          if (await canLaunch(fileUrl)) {
            await launch(fileUrl);
          } else {
            throw 'Could not launch $fileUrl';
          }
        }
      }
    } else {
      print('Failed to get access code');
    }
  }

  Future<workers.WorkersListData?> getWorkers() async {
    final response = await NetworkHelper().get(url: WORKERS_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);
      if (decodedResponse.containsKey('data')) {
        final workers.WorkersListData dataDecoded =
            workers.WorkersListData.fromJson(decodedResponse);
        return dataDecoded;
      }
    } else if (response is String) {
      print(response);
    } else {
      print('object');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Емтиханды өзгерту'),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // widget.group != null ?
              // Text('№${widget.group!.id} емтихан') :const SizedBox(),
              const SizedBox(height: 20),
              Row(
                children: [
                  DropdownButton<String>(
                    value: newSubject != ''
                        ? newSubject
                        : 'Еңбек қауіпсіздігі және еңбекті қорғау',
                    items: const [
                      DropdownMenuItem(
                        value: 'Еңбек қауіпсіздігі және еңбекті қорғау',
                        child: Text('Еңбек қауіпсіздігі және еңбекті қорғау'),
                      ),
                      DropdownMenuItem(
                        value: 'Өнеркәсіп қауіпсіздігі',
                        child: Text('Өнеркәсіп қауіпсіздігі'),
                      ),
                      DropdownMenuItem(
                        value: 'Өрт-техникалық минимум',
                        child: Text('Өрт-техникалық минимум'),
                      ),
                    ],
                    hint: const Text(
                      'Тобы',
                    ),
                    onChanged: (value) async {
                      setState(() {
                        newSubject = value!;
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: newChin != '' ? newChin : 'ИТР',
                    items: const [
                      DropdownMenuItem(
                        value: 'ИТР',
                        child: Text('ИТР'),
                      ),
                      DropdownMenuItem(
                        value: 'Рабочий',
                        child: Text('Рабочий'),
                      ),
                      DropdownMenuItem(
                        value: 'Администрация',
                        child: Text('Администрация'),
                      ),
                    ],
                    hint: const Text(
                      'Тобы',
                    ),
                    onChanged: (value) async {
                      setState(() {
                        newChin = value!;
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      getAccessCode(widget.group!.id!);
                    },
                    child: const Row(
                      children: [
                        Text('Емтихан кодын алу'),
                        SizedBox(width: 5),
                        Icon(Icons.download),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: commission,
                decoration: InputDecoration(
                  labelText: 'Комиссия',
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
              const SizedBox(height: 20),
              SizedBox(
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
                    DataColumn(label: Text('Емтихан тапсырылды')),
                    DataColumn(label: Text('Нәтиже')),
                  ],
                  rows: widget.group!.exam!.map((item) {
                    String formattedDate = '';
                    if (item.updatedAt != null) {
                      DateTime dateTime = DateTime.parse(item.updatedAt);
                      formattedDate = DateFormat('yyyy-MM-dd kk:mm')
                          .format(dateTime.toLocal());
                    }
                    return DataRow(
                      cells: [
                        DataCell(Text(item.id.toString())),
                        DataCell(Text(
                            '${item.workers!.surname} ${item.workers!.name}')),
                        DataCell(Text(item.workers!.org!.nameKk ?? '')),
                        DataCell(Text(formattedDate)),
                        DataCell(Text(
                          formattedDate != ''
                              ? item.pass == 1
                                  ? 'Өтті'
                                  : 'Құлады'
                              : '',
                          style: TextStyle(
                              color: item.pass == 1 ? Colors.blue : Colors.red),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: FutureBuilder(
                  future: getWorkers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Row(
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Жұмысшы',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: snapshot.data!.data!
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.id.toString(),
                                            child: Text(
                                              '${item.surname!} ${item.name}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedWorker,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedWorker = value!;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    // width: 200,
                                  ),
                                  dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 500,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: searchWorkerController,
                                    searchInnerWidgetHeight: 50,
                                    searchInnerWidget: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 4,
                                        right: 8,
                                        left: 8,
                                      ),
                                      child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        controller: searchWorkerController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'Іздеу',
                                          hintStyle:
                                              const TextStyle(fontSize: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return item.value
                                          .toString()
                                          .contains(searchValue);
                                    },
                                  ),
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      // searchMarkController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                newExam(widget.group!.id!,
                                    int.parse(selectedWorker));
                              },
                              child: const Text('Жаңа жұмысшы қосу'),
                            ),
                          ],
                        );
                      } else {
                        return Text('dasd');
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 250,
                child: Column(
                  children: [
                    SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                    ElevatedButton(
                      child: const Text("Басталу уақытын белгілеу"),
                      onPressed: () => _selectTime(context),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Басталу күні: ${DateFormat('dd.MM.yy').format(selectedDate ?? DateTime.now())}'),
                    const SizedBox(height: 10),
                    Text('Бастау уақыты: ${selectedTime?.format(context)}'),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text('Емтиханға берілетін уақыт'),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: examDuration,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
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
                      const SizedBox(width: 10),
                      const Text('минут'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Берілетін сұрақтар саны'),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              quantity--;
                            });
                          },
                          icon: const Icon(Icons.remove)),
                      Text(quantity.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Емтиханнан өту табалдырығы'),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              passedOn--;
                            });
                          },
                          icon: const Icon(Icons.remove)),
                      Text(passedOn.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            passedOn++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      newGroup(widget.group != null
                          ? widget.group!.id.toString()
                          : null);
                    },
                    child: const Text('Өзгертулерді сақтау'),
                  ),
                  const SizedBox(width: 25),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      // deleteGroup(widget.group!.id);
                    },
                    child: const Text('Емтиханды өшіру'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
