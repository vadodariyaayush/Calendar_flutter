import 'package:flutter/material.dart';
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
      home: MyHomePage(),
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
  var eventTitle = TextEditingController();
  var eventDescription = TextEditingController();

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
                  TextField(controller: eventTitle,
                    decoration: InputDecoration(
                      label: Text("Title"),
                    ),),

                  TextField(controller: eventDescription,
                    decoration:InputDecoration(
                      label: Text("Description")
                    ),
                  ),
                ],
              ),
            ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Calender", textAlign: TextAlign.center,),

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


          )
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