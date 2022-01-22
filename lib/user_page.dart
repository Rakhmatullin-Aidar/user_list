import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_list/validation.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key,required this.boolVar, this.index, this.userNameValue, this.lastNameValue, this.firstNameValue, this.phoneNumberValue}) : super(key: key);

  final bool boolVar;
  final index;
  final userNameValue;
  final lastNameValue;
  final firstNameValue;
  final phoneNumberValue;


  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {


  final formKey = GlobalKey<FormState>();


  late final userNameField = TextEditingController();
  late final lastNameField = TextEditingController();
  late final firstNameField = TextEditingController();
  late final phoneNumberField = TextEditingController();



  void setValueForm(){
    userNameField.text = widget.userNameValue;
    lastNameField.text = widget.lastNameValue;
    firstNameField.text = widget.firstNameValue;
    phoneNumberField.text = widget.phoneNumberValue;
  }

  @override
  void initState() {
    setValueForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: const Text('User info'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SizedBox(
            width: 350,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: userNameField,
                    decoration: const InputDecoration(labelText: 'username'),
                    validator: validate
                  ),
                  TextFormField(
                    controller: lastNameField,
                    decoration: const InputDecoration(labelText: 'Фамилия'),
                    validator: validate
                  ),
                  TextFormField(
                    controller: firstNameField,
                    decoration: const InputDecoration(labelText: 'Имя'),
                    validator: validate
                  ),
                  TextFormField(
                    controller: phoneNumberField,
                    decoration: const InputDecoration(labelText: 'Номер телефона'),
                    validator: validate
                  ),
                ],
              ),
            ),
          ),
        ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          saveButton(),
          const SizedBox(width: 100),
          cancelButton(),
        ],
      ),

    );
  }



  Widget saveButton() => ElevatedButton(
    onPressed: (){
      final form = formKey.currentState;
      if(form!.validate()){
        form.save();
        if(widget.boolVar == true) {
          editUser();
        }else if(widget.boolVar == false) {
          createUser();
        }
        Navigator.pop(context);
      }
    },
    child: const Text('Сохранить'),
  );


  Widget cancelButton() => ElevatedButton(
    onPressed: (){
      Navigator.pop(context);
    },
    child: const Text('Отменить'),
  );


  void editUser(){
    FirebaseFirestore.instance.runTransaction((Transaction tr) async {
      DocumentSnapshot snapshot = await tr.get(widget.index);
      tr.update(snapshot.reference, {
        'userName': userNameField.text,
        'Фамилия': lastNameField.text,
        'Имя': firstNameField.text,
        'Номер телефона': phoneNumberField.text,
      });
    });
  }

  void createUser(){
    FirebaseFirestore.instance.collection('users').add(
      {
        'userName': userNameField.text,
        'Фамилия': lastNameField.text,
        'Имя': firstNameField.text,
        'Номер телефона': phoneNumberField.text,
      },
    );
  }


}

