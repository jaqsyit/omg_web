import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/worker/worker_cubit.dart';
import 'package:omg/features/worker/worker_state.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class WorkerScreen extends StatefulWidget {
  WorkerScreen({Key? key}) : super(key: key);

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController workNameController = TextEditingController();

  String newSubject = '';

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    return BlocProvider(
      create: (_) => WorkerCubit(context: context)..getOrgsList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Жұмысшы қосу'),
        ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            margin: const EdgeInsets.all(20),
                            child: DropdownButton<String>(
                              elevation: 0,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              value: newSubject != ''
                                  ? newSubject
                                  : '${state.data.data[0].id}',
                              items: state.data.data.map((item) {
                                return DropdownMenuItem(
                                  value: "${item.id}",
                                  child: Text(item.nameKk),
                                );
                              }).toList(),
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
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: phoneNumberController,
                                inputFormatters: [maskFormatter],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '+7 (777) 777 77 77',
                                ),
                                maxLines: 1,
                                validator: (text) {
                                  if (text != null) {
                                    if (text.isEmpty) {
                                      return 'Телефон номеріңізді еңгізіңіз';
                                    } else if (text.length < 12) {
                                      return 'Телефон номеріңіз толық емес';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          _buildTextField(workNameController, 'Жұмысы'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            WorkerCubit(context: context).addNewWorker(
                                name: nameController.text,
                                surname: surnameController.text,
                                lastname: lastnameController.text,
                                phoneNumber: phoneNumberController.text,
                                work: workNameController.text,
                                idOrg: newSubject);
                          },
                          child: const Text('Қосу'))
                    ],
                  ),
                );
              } else if (state is WorkerError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    await profileCubit.getOrgsList();
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
          keyboardType: TextInputType.phone,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
          ),
          maxLines: 1,
          validator: (text) {
            if (text != null) {
              if (text.isEmpty) {
                return 'Толықтырыңыз';
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
