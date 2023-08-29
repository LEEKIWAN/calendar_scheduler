import 'dart:developer';

import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/model/schedule_with_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now().toUtc();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(selectedDay);

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
            TodayBanner(selectedDay: selectedDay),
            SizedBox(height: 12),
            _ScheduleList(selectedDay: selectedDay,),
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
        return ScheduleBottomSheet(selectedDay: selectedDay,);
      });
    }, child: Icon(Icons.add), backgroundColor: PRIMARY_COLOR,);
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDay;

  const _ScheduleList({required this.selectedDay, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<ScheduleWithColor>>(
          stream: GetIt.I<LocalDatabase>().watchSchedule(selectedDay),
          builder: (context, snapshot) {
            print(snapshot.data);

            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(child: Text('스케쥴이 없습니다.'),);
            }


            return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 12,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final data = snapshot.data![index];
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      GetIt.I<LocalDatabase>().removeSchedule(data.schedule.id);
                    },
                    key: ObjectKey(data.schedule.id),
                    child: ScheduleCard(
                        startTime: data.schedule.startTime,
                        endTime: data.schedule.endTime,
                        content: data.schedule.content,
                        color: Color(int.parse('FF${data.categoryColor.hexCode}', radix: 16))),
                  );
                });
          }
        ),
      ),
    );
  }
}
