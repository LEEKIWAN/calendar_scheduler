
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/foundation.dart';

class ScheduleWithColor {
  final CategoryColor categoryColor;
  final Schedule schedule;

  ScheduleWithColor({
    required this.categoryColor, required this.schedule
  });
}