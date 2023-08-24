import 'package:finmapp_assignment/question_model.dart';
import 'package:flutter/material.dart';

class DispalyScreen extends StatelessWidget {
  final QuestionListModel questionListModel;
  const DispalyScreen({super.key, required this.questionListModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Answers",
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: questionListModel.schema!.fields!.length,
            itemBuilder: (itemBuilder, index) {
              return questionListModel.schema!.fields![index].type == "Section"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Section: " +
                              questionListModel
                                  .schema!.fields![index].schema2!.label!,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: questionListModel
                                .schema!.fields![index].schema2!.fields!.length,
                            itemBuilder: (itemBuilder, index2) {
                              return QuestionAnswerWidget(
                                  question: questionListModel
                                      .schema!
                                      .fields![index]
                                      .schema2!
                                      .fields![index2]
                                      .schema2!
                                      .label!,
                                  answer: questionListModel
                                      .schema!
                                      .fields![index]
                                      .schema2!
                                      .fields![index2]
                                      .schema2!
                                      .answer!);
                            }),
                      ],
                    )
                  : QuestionAnswerWidget(
                      question: questionListModel
                          .schema!.fields![index].schema2!.label!,
                      answer: questionListModel
                          .schema!.fields![index].schema2!.answer!);
            }),
      )),
    );
  }
}

class QuestionAnswerWidget extends StatelessWidget {
  final String question;
  final String answer;
  const QuestionAnswerWidget(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Question: $question",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        answer == ""
            ? Text("Not Answered",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
            : Text("Answer: $answer",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
      ],
    );
  }
}
