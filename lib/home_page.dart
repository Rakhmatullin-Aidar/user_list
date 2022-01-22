import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of users'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Text('Нет пользователей');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return Card(
                child: TextButton(
                  child: ListTile(
                    title: Text('${snapshot.data!.docs[index].get('userName')}'),
                    trailing: IconButton(
                      onPressed: (){
                        FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index].id).delete();
                      },
                      icon: const Icon(Icons.delete, color: Colors.black),
                    ),
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Column(
                            children: [
                              Text('username: ${snapshot.data!.docs[index].get('userName')}'),
                              Text('Фамилия: ${snapshot.data!.docs[index].get('Фамилия')}'),
                              Text('Имя: ${snapshot.data!.docs[index].get('Имя')}'),
                              Text('Номер телефона: ${snapshot.data!.docs[index].get('Номер телефона')}'),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async{
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      UserPage(
                                        boolVar: true,
                                        index: snapshot.data!.docs[index].reference,
                                        userNameValue: snapshot.data!.docs[index].get('userName'),
                                        lastNameValue: snapshot.data!.docs[index].get('Фамилия'),
                                        firstNameValue: snapshot.data!.docs[index].get('Имя'),
                                        phoneNumberValue: snapshot.data!.docs[index].get('Номер телефона'),
                                      )
                                  ));
                                },
                                child: const Text('Редактировать'),
                              )
                            ],
                          ),
                        );
                      }
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: addUser()
    );
  }




  Widget addUser() => IconButton(
    iconSize: 40,
    color: Colors.black,
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
      const UserPage(
        boolVar: false,
        userNameValue: '',
        lastNameValue: '',
        firstNameValue: '',
        phoneNumberValue: '',
      )
      ));
    },
    icon: const Icon(Icons.add),
  );


}
