import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  int selectedColorId = -1;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    print("rebhilded");

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(onStartSaved: onStartSaved, onEndSaved: onEndSaved),
                    SizedBox(
                      height: 16,
                    ),
                    _Content(onContentSaved: onContentSaved),
                    SizedBox(
                      height: 16,
                    ),
                    FutureBuilder<List<CategoryColor>>(
                        future: GetIt.I.get<LocalDatabase>().getCategoryColors(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData && selectedColorId == -1 && snapshot.data!.isNotEmpty) {
                            selectedColorId = snapshot.data!.first.id;
                          }

                          return _ColorPicker(colors: snapshot.hasData ? snapshot.data! : [], selectedColorId: selectedColorId, colorIdSetter: (id) {
                            setState(() {
                              selectedColorId = id;
                            });
                          }, );
                        }),
                    SizedBox(
                      height: 8,
                    ),
                    _SaveButton(
                      onSaveTapped: onSaveTapped,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onStartSaved(dynamic val) {
    startTime = int.parse(val);
  }

  void onEndSaved(dynamic val) {
    endTime = int.parse(val);
  }

  void onContentSaved(dynamic val) {
    content = val;
  }

  void onSaveTapped() {
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      print("$startTime, $endTime, $content");
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter onStartSaved;
  final FormFieldSetter onEndSaved;

  const _Time(
      {required this.onStartSaved, required this.onEndSaved, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            isTime: true,
            label: '시작 시간',
            onSaved: onStartSaved,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: CustomTextField(
            isTime: true,
            label: '마감 시간',
            onSaved: onEndSaved,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter onContentSaved;

  const _Content({required this.onContentSaved, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
      isTime: false,
      label: '내용',
      onSaved: onContentSaved,
    ));
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({required this.colors, required this.selectedColorId, required this.colorIdSetter, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: colors.map((e) {
        return GestureDetector(
            onTap: () {
              colorIdSetter(e.id);
            },
            child: renderColor(e, selectedColorId == e.id));
      }).toList()
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: Color(int.parse('FF${color.hexCode}',
            radix: 16)),
        shape: BoxShape.circle,

        border: isSelected ? Border.all(color: Colors.black, width: 4) : null

      ),
      width: 32,
      height: 32,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onSaveTapped;

  const _SaveButton({required this.onSaveTapped, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSaveTapped,
            child: Text('저장'),
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
