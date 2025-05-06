import 'package:ai_coach/config/materials/themes/text_themes.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/presentation/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> _questions = [
    'Çalışman gereken dersler, alt konuları ve son tarihleri nelerdir?',
    'Hangi günler hangi saatlerde çalışmak istiyorsun',
    'Ortalama bir etüt süren, ara süren ve en uzun etüt süren kaç dakikadır?',
  ];

  final List<String?> _answers = [];
  List<Map<String, dynamic>> tasks = [];
  final List<String> days = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];
  Map<String, bool> weeklyAvailabilityStatus = {
    "Pazartesi": true,
    "Salı": true,
    "Çarşamba": true,
    "Perşembe": true,
    "Cuma": true,
    "Cumartesi": true,
    "Pazar": true
  };
  Map<String, List<TimeOfDay>> weeklyAvailability = {
    "Pazartesi": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
    "Salı": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
    "Çarşamba": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
    "Perşembe": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
    "Cuma": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
    "Cumartesi": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
    "Pazar": [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)],
  };
  Map<String, int> studySession = {
    "durationMinutes": 0,
    "breakMinutes": 0,
    "maxSessionMinutes": 0
  };

  @override
  void initState() {
    super.initState();
    _answers.addAll(List.filled(_questions.length, null));
  }

  void _nextPage() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _complete() {
    print("Answers submitted: $_answers");
    List<Map<String, String>> tasksFormat = tasks.map((e) {
      // Deadline'ı kontrol et ve formatla
      String formattedDeadline = '';
      if (e["deadline"] is DateTime) {
        final deadline = e["deadline"] as DateTime;
        formattedDeadline =
            "${deadline.year}-${deadline.month}-${deadline.day}";
      } else {
        // Eğer DateTime değilse, alternatif bir işlem yap veya hata fırlat
        formattedDeadline = "Invalid Date";
        // Veya throw Exception("Deadline must be a DateTime object");
      }

      // Tüm değerlerin String olduğundan emin ol
      return {
        "subject": e["subject"]?.toString() ?? '',
        "topic": e["topic"]?.toString() ?? '',
        "deadline": formattedDeadline,
      };
    }).toList();

    Map<String, String> weeklyAvailabilityFormat = {};
    weeklyAvailabilityStatus.map(
      (key, value) {
        if (value) {
          weeklyAvailabilityFormat.addAll({
            key:
                "${weeklyAvailability[key]![0].hour}:${weeklyAvailability[key]![0].minute}-${weeklyAvailability[key]![1].hour}:${weeklyAvailability[key]![1].minute}"
          });
          return MapEntry(key, value);
        } else {
          weeklyAvailabilityFormat.addAll({key: "Yok"});
          return MapEntry(key, value);
        }
      },
    );
    UserModel updatedUser = UserModel(
        tasks: tasksFormat,
        weeklyAvailability: weeklyAvailabilityFormat,
        studySession: studySession);
    BlocProvider.of<UserBlocBloc>(context).add(UpdateUserRequest(
      user: updatedUser,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == _questions.length - 1;

    return Scaffold(
      backgroundColor: MainColors.backgroundColor1,
      body: Stack(
        children: [
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _questions[0],
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 20,
                                    color: MainColors.primaryTextColor1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 800,
                                  height: 500,
                                  child: ListView.builder(
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index2) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(MainColors
                                                                  .backgroundColor2)),
                                                  onPressed: null,
                                                  icon: Text(
                                                    index2.toString(),
                                                    style: CustomTextStyles
                                                        .aiPageSubHeaderStyle,
                                                  )),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                width: 220,
                                                child: TextFormField(
                                                  initialValue: tasks[index2]
                                                      ["subject"],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      tasks[index2]["subject"] =
                                                          value;
                                                    });
                                                  },
                                                  style: GoogleFonts
                                                      .montserratAlternates(
                                                    color: MainColors
                                                        .primaryTextColor1,
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Ders ismi',
                                                    labelStyle: GoogleFonts
                                                        .montserratAlternates(
                                                      color: MainColors
                                                          .secondaryTextColor,
                                                    ),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                width: 220,
                                                child: TextFormField(
                                                  initialValue: tasks[index2]
                                                      ["topic"],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      tasks[index2]["topic"] =
                                                          value;
                                                    });
                                                  },
                                                  style: GoogleFonts
                                                      .montserratAlternates(
                                                    color: MainColors
                                                        .primaryTextColor1,
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Konu İsmi',
                                                    labelStyle: GoogleFonts
                                                        .montserratAlternates(
                                                      color: MainColors
                                                          .secondaryTextColor,
                                                    ),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                  width: 220,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white70,
                                                          foregroundColor: Colors
                                                              .deepPurpleAccent),
                                                      onPressed: () async {
                                                        DateTime? deadline =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                firstDate:
                                                                    DateTime(
                                                                        2025,
                                                                        4,
                                                                        1),
                                                                lastDate:
                                                                    DateTime(
                                                                        2026,
                                                                        4,
                                                                        1));

                                                        if (deadline != null) {
                                                          setState(() {
                                                            tasks[index2][
                                                                    "deadline"] =
                                                                deadline;
                                                          });
                                                        }
                                                      },
                                                      child: Text(tasks[index2][
                                                                  "deadline"] !=
                                                              ""
                                                          ? "${tasks[index2]["deadline"].year} - ${tasks[index2]["deadline"].month} - ${tasks[index2]["deadline"].day}"
                                                          : "Son Tarih"))),
                                            ],
                                          ),
                                          SizedBox(height: 20)
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                IconButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        MainColors.backgroundColor2),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      tasks.add({
                                        "subject": "",
                                        "topic": "",
                                        "deadline": ""
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              ],
                            ),
                          );
                        case 1:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _questions[1],
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 20,
                                    color: MainColors.primaryTextColor1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 800,
                                  height: 500,
                                  child: ListView.builder(
                                    itemCount: days.length,
                                    itemBuilder: (context, index2) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  style: ButtonStyle(
                                                      fixedSize:
                                                          WidgetStatePropertyAll(
                                                              Size(150, 30)),
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(MainColors
                                                                  .backgroundColor2)),
                                                  onPressed: null,
                                                  icon: Text(
                                                    days[index2],
                                                    style: CustomTextStyles
                                                        .aiPageSubHeaderStyle,
                                                  )),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                width: 220,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        weeklyAvailabilityStatus[
                                                                days[index2]]!
                                                            ? Colors.white
                                                            : Colors.grey[400],
                                                    foregroundColor:
                                                        weeklyAvailabilityStatus[
                                                                days[index2]]!
                                                            ? Colors
                                                                .deepPurpleAccent
                                                            : Colors.grey[600],
                                                  ),
                                                  onPressed:
                                                      weeklyAvailabilityStatus[
                                                              days[index2]]!
                                                          ? () async {
                                                              final TimeOfDay?
                                                                  picked =
                                                                  await showTimePicker(
                                                                      context:
                                                                          context,
                                                                      initialTime:
                                                                          weeklyAvailability[days[index2]]![
                                                                              0]);
                                                              if (picked !=
                                                                  null) {
                                                                setState(() {
                                                                  weeklyAvailability[
                                                                          days[
                                                                              index2]]![
                                                                      0] = picked;
                                                                });
                                                              }
                                                            }
                                                          : null,
                                                  child: Text(
                                                      "Başlangıç Saati: ${weeklyAvailability[days[index2]]![0].hour}:${weeklyAvailability[days[index2]]![0].minute}"),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                width: 220,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        weeklyAvailabilityStatus[
                                                                days[index2]]!
                                                            ? Colors.blue
                                                            : Colors.grey[400],
                                                    foregroundColor:
                                                        weeklyAvailabilityStatus[
                                                                days[index2]]!
                                                            ? Colors.white
                                                            : Colors.grey[600],
                                                  ),
                                                  onPressed:
                                                      weeklyAvailabilityStatus[
                                                              days[index2]]!
                                                          ? () async {
                                                              final TimeOfDay?
                                                                  picked =
                                                                  await showTimePicker(
                                                                      context:
                                                                          context,
                                                                      initialTime:
                                                                          weeklyAvailability[days[index2]]![
                                                                              1]);
                                                              if (picked !=
                                                                  null) {
                                                                setState(() {
                                                                  weeklyAvailability[
                                                                          days[
                                                                              index2]]![
                                                                      1] = picked;
                                                                });
                                                              }
                                                            }
                                                          : null,
                                                  child: Text(
                                                      "Bitiş Saati: ${weeklyAvailability[days[index2]]![1].hour}:${weeklyAvailability[days[index2]]![1].minute}"),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              IconButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          weeklyAvailabilityStatus[
                                                                  days[index2]]!
                                                              ? WidgetStateProperty
                                                                  .all(Colors
                                                                      .green)
                                                              : WidgetStateProperty
                                                                  .all(Colors
                                                                      .red)),
                                                  onPressed: () {
                                                    setState(() {
                                                      weeklyAvailabilityStatus[
                                                              days[index2]] =
                                                          !weeklyAvailabilityStatus[
                                                              days[index2]]!;
                                                    });
                                                  },
                                                  icon:
                                                      weeklyAvailabilityStatus[
                                                              days[index2]]!
                                                          ? Icon(
                                                              FontAwesomeIcons
                                                                  .thumbsUp)
                                                          : Icon(
                                                              FontAwesomeIcons
                                                                  .thumbsDown))
                                            ],
                                          ),
                                          SizedBox(height: 20)
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        case 2:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _questions[2],
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 20,
                                    color: MainColors.primaryTextColor1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 800,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 220,
                                        child: TextFormField(
                                          initialValue:
                                              studySession["durationMinutes"]
                                                  .toString(),
                                          onChanged: (value) {
                                            int? number = int.tryParse(value);
                                            if (number != null) {
                                              setState(() {
                                                studySession[
                                                    "durationMinutes"] = number;
                                              });
                                            }
                                          },
                                          style:
                                              GoogleFonts.montserratAlternates(
                                            color: MainColors.primaryTextColor1,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Etüt Süresi',
                                            labelStyle: GoogleFonts
                                                .montserratAlternates(
                                              color:
                                                  MainColors.secondaryTextColor,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      SizedBox(
                                        width: 220,
                                        child: TextFormField(
                                          initialValue:
                                              studySession["breakMinutes"]
                                                  .toString(),
                                          onChanged: (value) {
                                            int? number = int.tryParse(value);
                                            if (number != null) {
                                              setState(() {
                                                studySession["breakMinutes"] =
                                                    number;
                                              });
                                            }
                                          },
                                          style:
                                              GoogleFonts.montserratAlternates(
                                            color: MainColors.primaryTextColor1,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Ara Süresi',
                                            labelStyle: GoogleFonts
                                                .montserratAlternates(
                                              color:
                                                  MainColors.secondaryTextColor,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      SizedBox(
                                        width: 220,
                                        child: TextFormField(
                                          initialValue:
                                              studySession["maxSessionMinutes"]
                                                  .toString(),
                                          onChanged: (value) {
                                            int? number = int.tryParse(value);
                                            if (number != null) {
                                              setState(() {
                                                studySession[
                                                        "maxSessionMinutes"] =
                                                    number;
                                              });
                                            }
                                          },
                                          style:
                                              GoogleFonts.montserratAlternates(
                                            color: MainColors.primaryTextColor1,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Max Etüt Süresi',
                                            labelStyle: GoogleFonts
                                                .montserratAlternates(
                                              color:
                                                  MainColors.secondaryTextColor,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BlocConsumer<UserBlocBloc, UserBlocState>(
                    listener: (context, state) {
                      BuildContext dialogContext = context;

                      switch (state) {
                        case UserUpdateLoading():
                          showDialog(
                            context: dialogContext,
                            builder: (dialogContext) {
                              return const LoadingDialog();
                            },
                          );
                          break;
                        case UserUpdateDone():
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                          Navigator.of(context).pushNamed("/main");
                          break;
                        case UserUpdateError():
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Hata"),
                                content: Text(state.error!),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  )
                                ],
                              );
                            },
                          );
                          break;
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentIndex > 0)
                            ElevatedButton(
                              onPressed: _prevPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MainColors.backgroundColor2,
                              ),
                              child: Text(
                                "Previous",
                                style: GoogleFonts.montserratAlternates(
                                  color: MainColors.primaryTextColor,
                                ),
                              ),
                            ),
                          SizedBox(width: 20),
                          isLast
                              ? ElevatedButton(
                                  onPressed: _complete,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        MainColors.backgroundColor2,
                                  ),
                                  child: Text(
                                    "Complete",
                                    style: GoogleFonts.montserratAlternates(
                                      color: MainColors.primaryTextColor,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _nextPage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        MainColors.backgroundColor2,
                                  ),
                                  child: Text(
                                    "Next",
                                    style: GoogleFonts.montserratAlternates(
                                      color: MainColors.primaryTextColor,
                                    ),
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
