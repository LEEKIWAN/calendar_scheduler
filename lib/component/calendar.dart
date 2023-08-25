import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const Calendar({required this.selectedDay, required this.focusedDay, required this.onDaySelected, super.key});

  @override
  Widget build(BuildContext context) {

    final defaultBoxDeco = BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(6),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w600,
    );


    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        defaultDecoration: defaultBoxDeco,
        weekendDecoration: defaultBoxDeco,
        selectedDecoration: defaultBoxDeco.copyWith(
          color: Colors.white,
          border: Border.all(color: PRIMARY_COLOR, width: 1),
        ),

        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: PRIMARY_COLOR,
        )

      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: (DateTime day) {
        if (selectedDay == null) {
          return false;
        }
        return day.year == selectedDay!.year &&
            day.month == selectedDay!.month &&
            day.day == selectedDay!.day;
      },
      pageJumpingEnabled: true,
    );
  }
}
