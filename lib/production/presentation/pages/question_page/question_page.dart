import 'package:flutter/material.dart';
import 'package:ai_coach/config/materials/colors/main_colors.dart';
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
    'Bir konuyu tam olarak anlayabilmen için ortalama kaç kez tekrar etmen gerekiyor?',
    'Günde toplam kaç saat verimli çalışabiliyorsun?',
    'Ortalama bir etüt süren kaç dakika?',
    'Müsait olduğun günler nelerdir?',
    'Sınav tarihlerin nelerdir?',
    'Çalışman gereken konular nelerdir?'
  ];
  final List<String?> _answers = [];

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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Completed"),
        content: Text("Thanks for your answers!"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  Widget _buildQuestion(int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _questions[index],
            style: GoogleFonts.montserratAlternates(
              fontSize: 20,
              color: MainColors.primaryTextColor1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            onChanged: (value) => _answers[index] = value,
            style: GoogleFonts.montserratAlternates(
              color: MainColors.primaryTextColor1,
            ),
            decoration: InputDecoration(
              labelText: 'Your answer',
              labelStyle: GoogleFonts.montserratAlternates(
                color: MainColors.secondaryTextColor,
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == _questions.length - 1;

    return Scaffold(
      backgroundColor: MainColors.backgroundColor1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) => _buildQuestion(index),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
                            backgroundColor: MainColors.backgroundColor2,
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
                            backgroundColor: MainColors.backgroundColor2,
                          ),
                          child: Text(
                            "Next",
                            style: GoogleFonts.montserratAlternates(
                              color: MainColors.primaryTextColor,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
