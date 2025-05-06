import 'dart:convert';

import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:ai_coach/config/materials/themes/text_themes.dart';
import 'package:ai_coach/config/variables/doubles/main_doubles.dart';
import 'package:ai_coach/config/variables/strings/auth_strings.dart';
import 'package:ai_coach/core/extensions/sizes.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final model =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');
  Map<String, dynamic> answerFromGemini = {};
  UserModel dummyUser = UserModel();
  List<Content> history = [];
  @override
  void initState() {
    startChattin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = context.getWidth();
    double screenHeight = context.getHeigth();

    return answerFromGemini.isNotEmpty
        ? Scaffold(
            backgroundColor: MainColors.backgroundColor1,
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 10,
                  child: SizedBox(
                    width: IconSizes.authIconWidthSize,
                    height: IconSizes.authIconHeightSize,
                    child: Image.asset(MainStrings.image1),
                  ),
                ),
                Positioned(
                  top: 230,
                  left: 50,
                  child: Container(
                    width: 1000,
                    height: 600,
                    decoration: BoxDecoration(
                      color: MainColors.backgroundColor2,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, 9),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GridView.builder(
                        itemCount:
                            (answerFromGemini['studyPlan']['schedule'] as List)
                                .length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1, // 1:1 oranında kare kartlar
                        ),
                        itemBuilder: (context, index) {
                          final daySchedule =
                              answerFromGemini['studyPlan']['schedule'][index];
                          String date = daySchedule['date'];
                          String day = daySchedule['day'];
                          List<dynamic> sessions = daySchedule['sessions'];

                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: Card(
                              margin: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      day,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    SizedBox(height: 8),
                                    if (sessions.isEmpty)
                                      Text('Ders yok')
                                    else
                                      Expanded(
                                        child: ListView(
                                          children:
                                              sessions.map<Widget>((session) {
                                            return ListTile(
                                              trailing: TextButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(MainColors
                                                                  .buttonColor2)),
                                                  onPressed: () {},
                                                  child: Text(
                                                    "Ai ile Öğren",
                                                    style: CustomTextStyles
                                                        .aiPageSubHeaderStyle4,
                                                  )),
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(session['subject']),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(session['topic']),
                                                  Text(
                                                    '${session['startTime']} - ${session['endTime']} • ${session['duration']} dk',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 150,
                    right: 175,
                    child: Container(
                      width: 460,
                      height: 700,
                      child: Column(
                        children: [
                          Text(
                            "PROGRAMINI DÜZENLE",
                            style: CustomTextStyles.aiPageHeaderStyle,
                          ),
                          SizedBox(height: 40),
                          Container(
                            width: 300,
                            height: 80,
                            decoration: BoxDecoration(
                              color: MainColors.backgroundColor2,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset(0, 9),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "AI YARDIMI İLE TAKVİMİ DÜZENLE",
                                textAlign: TextAlign.center,
                                style: CustomTextStyles.aiPageSubHeaderStyle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 315,
                            decoration: BoxDecoration(
                                color: MainColors.backgroundColor3,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    "Programında değişmesini istediğin şeyler: ",
                                    textAlign: TextAlign.center,
                                    style:
                                        CustomTextStyles.aiPageSubHeaderStyle2,
                                  ),
                                ),
                                Container(
                                  width: 240,
                                  height: 150,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Değişiklikleri Yazın',
                                      filled: true,
                                      fillColor: MainColors.primaryTextColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      contentPadding: const EdgeInsets.all(
                                          10), // İç boşluğu sıfırla
                                    ),
                                    style: CustomTextStyles
                                        .aiPageSubHeaderStyle2, // Yazı boyutu
                                    expands: true, // Tüm alanı kapla
                                    maxLines: null,
                                    minLines: null,
                                  ),
                                ),
                                Container(
                                  width: 270,
                                  height: 70,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        elevation:
                                            const WidgetStatePropertyAll(10),
                                        shape: WidgetStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)))),
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                                MainColors.buttonColor2)),
                                    onPressed: () {},
                                    child: Text(
                                      "AI YARDIMINA GÖNDER",
                                      textAlign: TextAlign.center,
                                      style: CustomTextStyles
                                          .aiPageSubHeaderStyle3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                Positioned(
                  top: 120,
                  left: 120,
                  right: 0,
                  child: SizedBox(
                    width: IconSizes.authIconWidthSize,
                    height: IconSizes.authIconHeightSize,
                    child: Image.asset(MainStrings.image3),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  right: -20,
                  child: SizedBox(
                    width: IconSizes.authIconWidthSize,
                    height: IconSizes.authIconHeightSize,
                    child: Image.asset(MainStrings.image2),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    style: ButtonStyle(
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(15)),
                        backgroundColor: WidgetStateProperty.all(Colors.red)),
                    color: Colors.white,
                    icon: const Row(
                      children: [
                        Icon(FontAwesomeIcons.arrowRightFromBracket),
                        SizedBox(width: 10),
                        Text(
                          "Ana Sayfaya Dön",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Container(
                width: screenWidth,
                height: screenHeight,
                color: MainColors.backgroundColor1,
                child: LoadingDialog()));
  }

  startChattin() async {
    const jsonString = '''
{
  "tasks": [
    {
      "subject": "Bilgisayar Ağları",
      "topic": "Socket Programlama",
      "deadline": "2025-05-20"
    },
    {
      "subject": "Sinyal İşleme",
      "topic": "Fourier Transformu",
      "deadline": "2025-05-28"
    },
    {
      "subject": "İngilizce",
      "topic": "Kelime Ezberi (300 kelime)",
      "deadline": "süreklilik"
    }
  ],
  "weeklyAvailability": {
    "Pazartesi": "18:00-20:00",
    "Salı": "Yok",
    "Çarşamba": "17:00-20:00",
    "Perşembe": "19:00-21:00",
    "Cuma": "Yok",
    "Cumartesi": "10:00-13:00",
    "Pazar": "16:00-18:00"
  },
  "studySession": {
    "durationMinutes": 40,
    "breakMinutes": 10,
    "maxSessionMinutes": 90
  }
}
''';
    const answerStrutcure = '''
 {
  "studyPlan": {
    "startDate": "YYYY-AA-GG",
    "endDate": "YYYY-AA-GG",
    "schedule": [
      {
        "date": "YYYY-AA-GG",
        "day": "HaftanınGünü",
        "sessions": [
          {
            "subject": "DersAdı",
            "topic": "Konu",
            "duration": DakikaCinsindenSüre,
            "startTime": "SS:DD",
            "endTime": "SS:DD"
          }
        ]
      }
    ],
    
  }
}
''';

/*
Content("user", [
        TextPart(
            'Bana kişiye özel bir çalışma tablosu üretmen için sana json formatında bilgi vereceğim. '
            'Bana bu jsona göre cevap olarak json formatında bir çalışma takvimi oluştur.\n$jsonString')
      ]), */

    final chat = model.startChat(history: history);
// Provide a prompt that contains text
    final prompt = [
      Content.text(
          'Bana kişiye özel bir çalışma tablosu üretmen için sana json formatında bilgi vereceğim. Bilgi jsonu : $jsonString '
          'Bana bu jsona göre cevap olarak json formatında ve son tarihlerine dikkat ederek birden çok haftalıysa ona göre bir çalışma takvimi oluştur. Cevap olarak vereceğin örnek json formatı => $answerStrutcure '
          'Cevap olarak sadece bu json u bana gönder.\n')
    ];

    //final response = await chat.sendMessageStream(prompt[0]);
    final response = await chat.sendMessage(prompt[0]);
    final cleanedMessage =
        response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
    final Map<String, dynamic> data =
        jsonDecode(cleanedMessage) as Map<String, dynamic>;
    print(data);
    setState(() {
      answerFromGemini = data;
      history.addAll([
        Content("user", [
          TextPart(
              'Bana kişiye özel bir çalışma tablosu üretmen için sana json formatında bilgi vereceğim. Bilgi jsonu : $jsonString '
              'Bana bu jsona göre cevap olarak json formatında ve son tarihlerine dikkat ederek birden çok haftalıysa ona göre bir çalışma takvimi oluştur. Cevap olarak vereceğin örnek json formatı => $answerStrutcure '
              'Cevap olarak sadece bu json u bana gönder.\n')
        ]),
        Content("model", [TextPart(data.toString())])
      ]);
    });
    final response2 = await chat.sendMessage(Content.text(
        "Pazartesi günlerini de boş bırak ve oluşturulan yeni takvimi bana önceden örnek olarak vermiş olduğum json formatında sadece json olarak cevap ver."));
    final cleanedMessage2 =
        response2.text!.replaceAll('```json', '').replaceAll('```', '').trim();
    final Map<String, dynamic> data2 =
        jsonDecode(cleanedMessage2) as Map<String, dynamic>;
    print(data2);
    setState(() {
      answerFromGemini = data2;
    });
    /*await for (final chunk in response) {
      print(chunk.text);
    }*/
  }
}
/* 
{
  "studyPlan": {
    "startDate": "2025-05-06",
    "endDate": "2025-05-28",
    "schedule": [
      {
        "date": "2025-05-06",
        "day": "Salı",
        "sessions": [
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "16:00",
            "endTime": "16:40"
          }
        ]
      },
      {
        "date": "2025-05-07",
        "day": "Çarşamba",
        "sessions": [
          {
            "subject": "Bilgisayar Ağları",
            "topic": "Socket Programlama",
            "duration": 40,
            "startTime": "17:00",
            "endTime": "17:40"
          },
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "18:00",
            "endTime": "18:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "19:00",
            "endTime": "19:40"
          }
        ]
      },
      {
        "date": "2025-05-08",
        "day": "Perşembe",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "19:00",
            "endTime": "19:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "20:00",
            "endTime": "20:40"
          }
        ]
      },
      {
        "date": "2025-05-10",
        "day": "Cumartesi",
        "sessions": [
          {
            "subject": "Bilgisayar Ağları",
            "topic": "Socket Programlama",
            "duration": 40,
            "startTime": "10:00",
            "endTime": "10:40"
          },
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "11:00",
            "endTime": "11:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "12:00",
            "endTime": "12:40"
          }
        ]
      },
      {
        "date": "2025-05-12",
        "day": "Pazartesi",
        "sessions": [
          {
            "subject": "Bilgisayar Ağları",
            "topic": "Socket Programlama",
            "duration": 40,
            "startTime": "18:00",
            "endTime": "18:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "19:00",
            "endTime": "19:40"
          }
        ]
      },
      {
        "date": "2025-05-14",
        "day": "Çarşamba",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "17:00",
            "endTime": "17:40"
          },
          {
            "subject": "Bilgisayar Ağları",
            "topic": "Socket Programlama",
            "duration": 40,
            "startTime": "18:00",
            "endTime": "18:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "19:00",
            "endTime": "19:40"
          }
        ]
      },
      {
        "date": "2025-05-17",
        "day": "Cumartesi",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "10:00",
            "endTime": "10:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "11:00",
            "endTime": "11:40"
          }
        ]
      },
      {
        "date": "2025-05-19",
        "day": "Pazartesi",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "18:00",
            "endTime": "18:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "19:00",
            "endTime": "19:40"
          }
        ]
      },
      {
        "date": "2025-05-21",
        "day": "Çarşamba",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "17:00",
            "endTime": "17:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "18:00",
            "endTime": "18:40"
          }
        ]
      },
      {
        "date": "2025-05-24",
        "day": "Cumartesi",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "10:00",
            "endTime": "10:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "11:00",
            "endTime": "11:40"
          }
        ]
      },
      {
        "date": "2025-05-25",
        "day": "Pazar",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "16:00",
            "endTime": "16:40"
          },
          {
            "subject": "İngilizce",
            "topic": "Kelime Ezberi (300 kelime)",
            "duration": 40,
            "startTime": "17:00",
            "endTime": "17:40"
          }
        ]
      },
      {
        "date": "2025-05-26",
        "day": "Pazartesi",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "18:00",
            "endTime": "18:40"
          }
        ]
      },
      {
        "date": "2025-05-27",
        "day": "Salı",
        "sessions": [
          {
            "subject": "Sinyal İşleme",
            "topic": "Fourier Transformu",
            "duration": 40,
            "startTime": "16:00",
            "endTime": "16:40"
          }
        ]
      }
    ],
    "summary": {
      "Bilgisayar Ağları": {
        "totalSessions": 4,
        "lastSessionDate": "2025-05-14"
      },
      "Sinyal İşleme": {
        "totalSessions": 8,
        "lastSessionDate": "2025-05-27"
      },
      "İngilizce": {
        "totalSessions": 10,
        "lastSessionDate": "2025-05-25"
      }
    }
  }
}


*/
/*{
  "studyPlan": {
    "startDate": "YYYY-AA-GG",
    "endDate": "YYYY-AA-GG",
    "schedule": [
      {
        "date": "YYYY-AA-GG",
        "day": "HaftanınGünü",
        "sessions": [
          {
            "subject": "DersAdı",
            "topic": "Konu",
            "duration": DakikaCinsindenSüre,
            "startTime": "SS:DD",
            "endTime": "SS:DD"
          }
        ]
      }
    ],
    "summary": {
      "DersAdı": {
        "totalSessions": ToplamOturumSayısı,
        "lastSessionDate": "YYYY-AA-GG"
      }
    }
  }
}*/