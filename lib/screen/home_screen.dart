import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 12),
            TodayBanner(selectedDay: selectedDay, scheduleCount: 5),
            SizedBox(height: 12),
            _ScheduleList(),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(onPressed: () {
      showModalBottomSheet(isScrollControlled: true, context: context, builder: (context) {
        return ScheduleBottomSheet();
      });
    }, child: Icon(Icons.add), backgroundColor: PRIMARY_COLOR,);
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 12,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ScheduleCard(
                  startTime: 12,
                  endTime: 14,
                  content: "프로그래밍 공부하기",
                  color: Colors.red);
            }),
      ),
    );
  }
}
