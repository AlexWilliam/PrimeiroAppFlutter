import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

import '../components/menu.dart';
import '../models/hour.dart';

import '../helpers/hour_helper.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hour> listHours = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(title: Text('Horas Registradas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? const Center(
              child: Text(
                'Nada por aqui!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              padding: EdgeInsets.only(left: 4, right: 4),
              children: List.generate(listHours.length, (index) {
                Hour model = listHours[index];
                return Dismissible(
                  key: ValueKey<Hour>(model),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 15),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    remove(model);
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          onLongPress: () {
                            showFormModal(model: model);
                          },
                          leading: Icon(Icons.list_alt_rounded, size: 56),
                          title: Text(
                            "Data: ${model.date} ${HourHelper.minutesToHour(model.minutes)}",
                          ),
                          subtitle: Text(model.description!),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }

  showFormModal({Hour? model}) {
    String title = "Adicionar hora";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    TextEditingController dateControlller = TextEditingController();
    final dateMaskFormatter = MaskTextInputFormatter(mask: "##/##/####");
    TextEditingController minutesController = TextEditingController();
    final minutesMaskFormatter = MaskTextInputFormatter(mask: "##:##");
    TextEditingController descriptionController = TextEditingController();

    if (model != null) {
      title = "Editando";
      confirmationButton = "Atualizar";
      dateControlller.text = model.date;
      minutesController.text = HourHelper.minutesToHour(model.minutes);
      descriptionController.text = model.description ?? "";
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(14)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(32),
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: dateControlller,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: "01/01/2000",
                  labelText: "Data do registro",
                ),
                inputFormatters: [dateMaskFormatter],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "09:00",
                  labelText: "Hora do registro",
                ),
                inputFormatters: [minutesMaskFormatter],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Descrição do registro",
                  labelText: "Descrição(opcional)",
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Hour hour = Hour(
                        id: const Uuid().v4(),
                        date: dateControlller.text,
                        minutes: HourHelper.hourToMinute(
                          minutesController.text,
                        ),
                      );

                      hour.description = descriptionController.text ?? "";

                      if (model != null) {
                        hour.id = model.id;
                      }

                      _firestore
                          .collection(widget.user.uid)
                          .doc(hour.id)
                          .set(hour.toMap());

                      refresh();

                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void remove(Hour model) {
    _firestore.collection(widget.user.uid).doc(model.id).delete();
    refresh();
  }

  Future<void> refresh() async {
    List<Hour> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(widget.user.uid).get();

    for(var doc in snapshot.docs) {
      temp.add(Hour.fromMap(doc.data()));
    }

    setState(() {
      listHours = temp;
    });
  }
}
