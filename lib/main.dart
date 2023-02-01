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
  Map<String,List>mySelectedEvents={};

  @override
  void initState() {
    _selectedDay = _focusedDay;
  }



  List _listOFDayEvents(DateTime dateTime){
    if(mySelectedEvents[DateFormat('yyyy-mm-dd').format(dateTime)] != null){
        return mySelectedEvents[DateFormat('yyyy-mm-dd').format(dateTime)]!;
    }
    else{
      return[];
    }

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

                    setState(() {
                      if(mySelectedEvents[DateFormat('yyyy-mm-dd').format(_selectedDay!)] != null){

                        mySelectedEvents[DateFormat('yyyy-mm-dd').format(_selectedDay!)]
                            ?.add({
                          "eventTitle":eventTitleController.text,
                          "eventDesc":eventDescriptionController.text,
                        });


                      }else{
                        mySelectedEvents[DateFormat('yyyy-mm-dd')
                            .format(_selectedDay!)] = [
                          {
                            "eventTitle": eventTitleController.text,
                            "eventDesc": eventDescriptionController.text,
                          }
                        ];
                      }
                    });
                    
                    print("New event for backend devloper ${json.encode(mySelectedEvents)}");
                    eventTitleController.clear();
                    eventDescriptionController.clear();
                    
                    

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:Text("Event successfully Added") ));
                    Navigator.pop(context);
                  }
                }, child: const Text("Add Event"))
              ],//action
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
                setState(() {
                  _calendarFormat = abc;
                });
              }
            },

            onPageChanged: (focusedDay){
              _focusedDay=focusedDay;
            },

            eventLoader: _listOFDayEvents,
          ),

          ..._listOFDayEvents(_selectedDay!).map(
                  (mySelectedEvents) => ListTile(
                   leading: const Icon(Icons.done,color: Colors.teal),
                   title: Text("Event Title : ${mySelectedEvents['eventTitle']}"),
                    subtitle: Text("Event Description : ${mySelectedEvents['eventDesc']}"),
                  ),
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