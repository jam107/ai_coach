import 'dart:convert';

import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:ai_coach/config/materials/themes/text_themes.dart';
import 'package:ai_coach/config/variables/doubles/main_doubles.dart';
import 'package:ai_coach/config/variables/strings/auth_strings.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:ai_coach/production/presentation/pages/ai_page/widgets/chatbot.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String chatString = "";
  bool isAiAnswering = true;
  bool isChatbotVisible = false;
  String answerStrutcure = '''
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
  @override
  void initState() {
    startChattin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: isAiAnswering
                  ? LoadingDialog()
                  : Padding(
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
                                                  onPressed: () {
                                                    setState(() {
                                                      isChatbotVisible = true;
                                                    });
                                                  },
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Text(
                              "Programında değişmesini istediğin şeyler: ",
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.aiPageSubHeaderStyle2,
                            ),
                          ),
                          Container(
                            width: 240,
                            height: 150,
                            child: TextFormField(
                              initialValue: chatString,
                              onChanged: (value) {
                                setState(() {
                                  chatString = value;
                                });
                              },
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
                                  elevation: const WidgetStatePropertyAll(10),
                                  shape: WidgetStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14)))),
                                  backgroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          MainColors.buttonColor2)),
                              onPressed: () {
                                if (chatString != "" || chatString.isNotEmpty) {
                                  updateSchedule();
                                }
                              },
                              child: Text(
                                "AI YARDIMINA GÖNDER",
                                textAlign: TextAlign.center,
                                style: CustomTextStyles.aiPageSubHeaderStyle3,
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
                  padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
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
          if (isChatbotVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 600,
                  height: 600,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: MainColors.backgroundColor2,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, -4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MainColors.buttonColor2,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "AI Asistan",
                              style: CustomTextStyles.aiPageSubHeaderStyle4,
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  isChatbotVisible = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ChatBot(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  updateSchedule() async {
    setState(() {
      isAiAnswering = true;
    });
    final chat = model.startChat(history: history);
    String promptString =
        "$chatString. Oluşturulan yeni takvimi bana önceden örnek olarak vermiş olduğum json formatında sadece json olarak cevap ver.";
    Content prompt = Content.text(promptString);
    final response = await chat.sendMessage(prompt);
    final cleanedMessage =
        response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
    final Map<String, dynamic> data =
        jsonDecode(cleanedMessage) as Map<String, dynamic>;
    setState(() {
      answerFromGemini = data;
      history.addAll([
        Content("user", [TextPart(promptString)]),
        Content("model", [TextPart(data.toString())])
      ]);
    });
    setState(() {
      isAiAnswering = false;
    });
  }

  startChattin() async {
    setState(() {
      isAiAnswering = true;
    });
    String jsonString = BlocProvider.of<UserBlocBloc>(context)
        .state
        .data
        .toAiPropmt()
        .toString();

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
    setState(() {
      isAiAnswering = false;
    });
  }
}
