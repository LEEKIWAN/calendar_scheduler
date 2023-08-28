import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final bool isTime;
  final String label;
  final FormFieldSetter onSaved;
  const CustomTextField({required this.isTime, required this.label, required this.onSaved, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime) Expanded(child: renderTextField()),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField (
      onSaved: onSaved,
      validator: (String? value) {
        print('val : $value');
        if(value == null || value.isEmpty) {
          return "값을 입력해주세요.";
        }

        if(isTime) {
          final time = int.parse(value);
          if(time < 0) {
            return "0보다 큰 수를 입력해주세요.";
          }
          if(time > 24) {
            return "24보다 작은 수를 입력해주세요.";
          }
        } else {

        }

        return null;
      },
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey.shade300,
      ),
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      maxLines: isTime ? 1 : null,
      expands: !isTime,
    );
  }
}
