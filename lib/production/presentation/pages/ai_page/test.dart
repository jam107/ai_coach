import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> answerFromGemini = {};
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Container(
          width: 1000,
          height: 800,
          child: GridView.count(
            crossAxisCount: 3,
            children: (answerFromGemini['studyPlan']['schedule'] as List)
                .map((daySchedule) {
              String date = daySchedule['date'];
              String day = daySchedule['day'];
              List<dynamic> sessions = daySchedule['sessions'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            date,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (sessions.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Ders yok'),
                      )
                    else
                      ...sessions
                          .map((session) => ListTile(
                                title: Text(session['subject']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(session['topic']),
                                    SizedBox(height: 4),
                                    Text(
                                      '${session['startTime']} - ${session['endTime']} • ${session['duration']} dakika',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
