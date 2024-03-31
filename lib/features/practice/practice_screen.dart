import 'package:flutter/material.dart';
import 'package:omg/constants/styles.dart';

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
                width: 300,
                child: Form(
                  key: _dropdownFormKey,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? "Select a country" : null,
                    value: selectedValueLang,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValueLang = newValue!;
                      });
                    },
                    items: dropdownItemsLang,
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
      DropdownMenuItem(child: Text("Еңбек қауіпсіздігі және еңбекті қорғау"), value: "Еңбек қауіпсіздігі және еңбекті қорғау"),
      DropdownMenuItem(child: Text("Өнеркәсіп қауіпсіздігі"), value: "Өнеркәсіп қауіпсіздігі"),
      DropdownMenuItem(child: Text("Өрт-техникалық минимум"), value: "Өрт-техникалық минимум"),
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
