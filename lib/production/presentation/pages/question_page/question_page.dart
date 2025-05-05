import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> _questions = [
    'What is your name?',
    'How old are you?',
    'What is your favorite color?',
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
    // Navigate to summary page or show dialog
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
          Text(_questions[index], style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          TextField(
            onChanged: (value) => _answers[index] = value,
            decoration: InputDecoration(labelText: 'Your answer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == _questions.length - 1;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics:
                  NeverScrollableScrollPhysics(), // control only via buttons
              itemCount: _questions.length,
              itemBuilder: (context, index) => _buildQuestion(index),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (_currentIndex > 0)
                ElevatedButton(
                    onPressed: _prevPage,
                    child: Text(
                      "Previous",
                      style: TextStyle(color: Colors.black),
                    )),
              isLast
                  ? ElevatedButton(
                      onPressed: _complete,
                      child: Text(
                        "Complete",
                        style: TextStyle(color: Colors.black),
                      ))
                  : ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.black),
                      )),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
