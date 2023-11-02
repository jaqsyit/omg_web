import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/models/group_add_data.dart';
import 'package:omg/models/group_delete_data.dart';
import 'package:omg/models/groups_list_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GroupEditScreen extends StatefulWidget {
  final Datum? group;
  GroupEditScreen({Key? key, this.group}) : super(key: key);

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  final TextEditingController commission = TextEditingController();
  String newChin = '';
  String newSubject = '';
  int quantity = 0;
  int passedOn = 0;

  DateTime? selectedDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = args.value;
    });
  }

  @override
  void initState() {
    super.initState();
    quantity = widget.group != null ? widget.group!.quantity : 0;
    passedOn = widget.group != null ? widget.group!.passedOn : 0;
    widget.group != null
        ? selectedTime = TimeOfDay(
            hour: widget.group!.start.hour, minute: widget.group!.start.minute)
        : null;
        widget.group != null ?
    selectedDate = widget.group!.start :null;
    widget.group != null ?
    newSubject = widget.group!.subject :null;
    widget.group != null ?
    newChin = widget.group!.chin :null;
    commission.text = widget.group == null ? '' : widget.group!.commission;
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
    DateTime newEnd = newStart.add(const Duration(minutes: 40));

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
      print(dataDecoded.success);
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
                    value: newSubject != '' ? newSubject : 'Еңбек қауіпсіздігі және еңбекті қорғау',
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
              Container(
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
                      // newGroup(widget.group != null ? widget.group!.id.toString() : null);
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
                    child: const Text('Емтиханды кетіру'),
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
