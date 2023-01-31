import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),//Home page is our first page
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomeState();
}


class MyHomeState extends State<MyHomePage> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; //date select by user
  var eventTitleController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  Map<String,List>mySelecedEvents={};

  String imageLink ="https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aHVtYW58ZW58MHx8MHx8&w=1000&q=80";

  @override
  void initState() {
    _selectedDay = _focusedDay;
  }

  _showAddEventDialog() async {
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Add New Event "),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: eventTitleController,
                    decoration: InputDecoration(
                      label: Text("Title"),
                    ),),

                  TextField(controller: eventDescriptionController,
                    decoration:InputDecoration(
                      label: Text("Description")
                    ),
                  ),
                ],

              ),
              actions: [
                TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("cancel")),
                TextButton(onPressed: (){
                  if(eventTitleController.text.isEmpty&&eventTitleController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Add title and Description"),
                          duration: Duration(seconds: 2),
                      ),
                      );
                      return;
                  }
                  else{

                    if(mySelecedEvents[DateFormat('yyyy-mm-dd').format(_selectedDay!)] != null){

                      mySelecedEvents[DateFormat('yyyy-mm-dd').format(_selectedDay!)]
                          ?.add({
                        "eventTitle":eventTitleController.text,
                          "eventDescp":eventTitleController.text,
                          });
                      

                    }else{
                        mySelecedEvents[DateFormat('yyyy-mm-dd')
                            .format(_selectedDay!)] = [
                              {
                                "eventTitle": eventTitleController.text,
                                "eventDescp": eventDescriptionController.text,
                              }
                        ];
                    }
                    
                    print("New event for backend devloper ${json.encode(mySelecedEvents)}");
                    
                    

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:Text("Event successfully Added") ));
                    Navigator.pop(context);
                  }
                }, child: const Text("Add Event"))
              ],
            )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Calendar", textAlign: TextAlign.center,),

      ),

      body: Column(
        children: [
          Text("My name is ayush"),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2024),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,

            headerStyle: HeaderStyle(
              // formatButtonVisible: false,
              titleTextStyle: TextStyle(color: Colors.purple, fontSize: 20),
              leftChevronIcon: Icon(Icons.arrow_back_ios_sharp, size: 15,),
            ),

            calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.red),
                todayDecoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.green,),
                  shape: BoxShape.circle,
                )
            ),


            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },

            onFormatChanged: (abc) {
              if (_calendarFormat != abc) {
                _calendarFormat = abc;
                setState(() {

                });
              }
            },


          ),

        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          return _showAddEventDialog();
        }, label: Text("Add Event"),
        focusColor: Colors.red,

      ),
    );
  }
}