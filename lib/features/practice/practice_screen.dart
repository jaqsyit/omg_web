import 'package:flutter/material.dart';
import 'package:omg/features/practise/practise_screen.dart';
// import 'package:omg/constants/styles.dart';

class PracticeScreen extends StatefulWidget {
  final String? title;
  final String? selectedDay;

  const PracticeScreen({Key? key, this.title, this.selectedDay})
      : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String? selectedValueLang = null;
  String? selectedValueSubject = null;
  String? selectedValueChin = null;
  String? selectedValueQuantity = null;
  final _dropdownFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Практика',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 400,
                child: Form(
                  key: _dropdownFormKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value == null ? "Пәні" : null,
                        value: selectedValueSubject,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueSubject = newValue!;
                          });
                        },
                        items: dropdownItemsSubject,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value == null ? "Тобы" : null,
                        value: selectedValueChin,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueChin = newValue!;
                          });
                        },
                        items: dropdownItemsChin,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) => value == null ? "Тіл" : null,
                        value: selectedValueLang,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueLang = newValue!;
                          });
                        },
                        items: dropdownItemsLang,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: const Text(
                            'Практиканы бастау',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PractiseScreen(
                                  subject: selectedValueSubject,
                                  chin: selectedValueChin,
                                  language: selectedValueLang,
                                  quantity: '40',
                                ),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItemsLang {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Қазақша"), value: "kk"),
      DropdownMenuItem(child: Text("Руский"), value: "ru"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsSubject {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Еңбек қауіпсіздігі және еңбекті қорғау"),
          value: "Еңбек қауіпсіздігі және еңбекті қорғау"),
      DropdownMenuItem(
          child: Text("Өнеркәсіп қауіпсіздігі"),
          value: "Өнеркәсіп қауіпсіздігі"),
      DropdownMenuItem(
          child: Text("Өрт-техникалық минимум"),
          value: "Өрт-техникалық минимум"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsChin {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("ИТР"), value: "ИТР"),
      DropdownMenuItem(child: Text("Жұмысшы"), value: "Жұмысшы"),
    ];
    return menuItems;
  }
}
