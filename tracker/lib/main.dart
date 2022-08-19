// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracker/utl/foot_step.dart';


void main() {
  runApp(const Tracker());
}

class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {

  final DateTime date = DateTime.now();
  ThemeData myMode=ThemeData.light();
  String myName='There';
  bool isStart=false;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: myMode,
      title: 'Tracker',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Scaffold(   
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 5,
          title:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(' Tracker',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),),
              myMode==ThemeData.light()?IconButton(onPressed: (){
            setState(() {
              myMode= ThemeData.dark();
            });
          }, icon: const Icon( Icons.dark_mode)):
          IconButton(onPressed: (){
            setState(() {
              myMode= ThemeData.light();
            });
          }, icon: const Icon( Icons.light_mode)),
            ],
          )),
         
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
              height: 30,
             ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 25,bottom:10),
                child: Container(
                  height: 120,
                  width: 400,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(65, 233, 30, 98),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: Text("Hello, $myName!!!\nIt's\n${DateFormat.yMMMEd().format(date)}.",style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ),
              ),
             const MyFootStep(),
             const SizedBox(
              height: 50,
             )
            ],
          ),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const[
                Padding(
                  padding: EdgeInsets.only(bottom: 450),
                  child: DrawerHeader(child: UserAccountsDrawerHeader(accountName: Text('DLTracker',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),), accountEmail: Text('Count your steps.',style: TextStyle(fontSize: 15,)))),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10,right: 10),
                  child: ListTile(
                    subtitle: Text('It counts all step since phone is booted. There are no support of reset pedometer manually. To reset counter restart your device.'
                    ,style: TextStyle(fontSize: 18),textAlign: TextAlign.justify,),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.copyright),
                  title: Text('Pro Win'
                  ,style: TextStyle(fontSize: 18),textAlign: TextAlign.justify,),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}



 