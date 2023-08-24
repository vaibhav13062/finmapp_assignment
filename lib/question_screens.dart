import 'dart:convert';

import 'package:finmapp_assignment/display_screen.dart';
import 'package:finmapp_assignment/question_model.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
  });

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen>
    with TickerProviderStateMixin {
  QuestionListModel questionListModel =
      QuestionListModel.fromJson(json.decode(Data().jsonModel));
  late TabController controller;
  @override
  void initState() {
    controller = TabController(
        length: questionListModel.schema!.fields!.length, vsync: this);

    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          questionListModel.title!,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: getTabs(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: controller,
                      children: getQuestions()))),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  if (controller.index > 0) {
                    controller.index = controller.index - 1;
                  }
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                    Text(
                      "Back",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (controller.index < controller.length - 1) {
                    controller.index = controller.index + 1;
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (builder) {
                      return DispalyScreen(
                          questionListModel: questionListModel);
                    }));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.orange),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              )
            ],
          )
        ]),
      ),
    );
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];

    for (int i = 0; i < questionListModel.schema!.fields!.length; i++) {
      tabs.add(Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: controller.index >= i
                  ? Colors.green
                  : Colors.grey.withOpacity(0.4)),
        ),
      ));
    }

    return tabs;
  }

  List<Widget> getQuestions() {
    List<Widget> tabViews = [];

    for (int i = 0; i < questionListModel.schema!.fields!.length; i++) {
      var element = questionListModel.schema!.fields![i];
      tabViews.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            element.schema2!.label!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          getQuestionWidget(element, i)
        ],
      ));
    }

    return tabViews;
  }

  Widget getQuestionWidget(Fields fields, int index) {
    switch (fields.type) {
      case "SingleChoiceSelector":
        return SingleChoiceSelector(
          field: fields,
          onSubmit: (String answer) {
            questionListModel.schema?.fields![index].schema2!.answer = answer;
          },
        );
      case "Section":
        return Section(
          field: fields,
          onSubmit: (List<String> answers) {
            for (int i = 0; i < answers.length; i++) {
              questionListModel.schema!.fields![index].schema2!.fields![i]
                  .schema2!.answer = answers[i];
            }
          },
        );
      case "SingleSelect":
        return SingleChoiceSelector(
          field: fields,
          onSubmit: (String answer) {
            questionListModel.schema?.fields![index].schema2!.answer = answer;
          },
        );
      default:
        return Container();
    }
  }
}

class SingleChoiceSelector extends StatefulWidget {
  final Fields field;
  final bool? showQuestion;
  final Function(String answer) onSubmit;
  const SingleChoiceSelector(
      {super.key,
      required this.field,
      this.showQuestion,
      required this.onSubmit});

  @override
  State<SingleChoiceSelector> createState() => _SingleChoiceSelectorState();
}

class _SingleChoiceSelectorState extends State<SingleChoiceSelector> {
  String selectedKey = "";
  @override
  void initState() {
    setState(() {
      selectedKey = widget.field.schema2!.answer!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.showQuestion ?? false,
          child: Text(
            widget.field.schema2!.label!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: widget.field.schema2!.options!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: selectedKey ==
                              widget.field.schema2!.options![index].value!
                          ? Colors.orange
                          : Colors.grey,
                      width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Radio(
                      activeColor: Colors.orange,
                      value: selectedKey ==
                          widget.field.schema2!.options![index].value!,
                      groupValue: true,
                      onChanged: (value) {
                        if (selectedKey !=
                            widget.field.schema2!.options![index].value!) {
                          setState(() {
                            selectedKey =
                                widget.field.schema2!.options![index].value!;
                            widget.onSubmit(selectedKey);
                          });
                        } else {
                          setState(() {
                            selectedKey = "";
                            widget.onSubmit(selectedKey);
                          });
                        }
                        print(selectedKey);
                      }),
                  Text(
                    widget.field.schema2!.options![index].value!,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: selectedKey ==
                                widget.field.schema2!.options![index].value!
                            ? Colors.orange
                            : Colors.black),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 5,
            );
          },
        ),
      ],
    );
  }
}

class Section extends StatefulWidget {
  final Fields field;
  final Function(List<String> answers) onSubmit;
  const Section({super.key, required this.field, required this.onSubmit});

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.field.schema2!.fields!.length; i++) {
      selectedItems.add(widget.field.schema2!.fields![i].schema2!.answer!);
      // selectedItems[i] = widget.field.schema2!.fields![i].schema2!.answer!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.field.schema2!.fields!.length,
      itemBuilder: (itemBuilder, index) {
        return Container(
          child: widget.field.schema2!.fields![index].type! == "SingleSelect"
              ? SingleChoiceSelector(
                  field: widget.field.schema2!.fields![index],
                  showQuestion: true,
                  onSubmit: (String answer) {
                    selectedItems[index] = answer;
                    widget.onSubmit(selectedItems);
                  },
                )
              : TextFormField(
                  onChanged: (value) {
                    selectedItems[index] = value;
                    widget.onSubmit(selectedItems);
                  },
                  keyboardType:
                      widget.field.schema2!.fields![index].type! == "Numeric"
                          ? TextInputType.number
                          : TextInputType.text,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText:
                        widget.field.schema2!.fields![index].schema2!.label!,
                    fillColor: Colors.orange,
                    focusColor: Colors.orange,
                    border: const OutlineInputBorder(),
                  ),
                ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
