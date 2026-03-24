import 'package:intl/intl.dart';

/// Utility class for date calculations based on billing cycle
class BillingDateUtils {
  /// Get the start of the current billing cycle based on monthStartDay
  /// 
  /// For example, if monthStartDay is 15:
  /// - If today is 2024-01-20, returns 2024-01-15
  /// - If today is 2024-01-10, returns 2023-12-15
  static DateTime getCurrentCycleStart(int monthStartDay) {
    final now = DateTime.now();
    
    // Clamp monthStartDay to valid range (1-28)
    final startDay = monthStartDay.clamp(1, 28);
    
    // If we haven't reached the start day this month yet, cycle started last month
    if (now.day < startDay) {
      final lastMonth = DateTime(now.year, now.month - 1, startDay);
      return lastMonth;
    }
    
    // Otherwise, current cycle started on startDay of this month
    return DateTime(now.year, now.month, startDay);
  }
  
  /// Get the end of the current billing cycle
  static DateTime getCurrentCycleEnd(int monthStartDay) {
    final nextCycleStart = getNextCycleStart(monthStartDay);
    // Subtract one day to get the last day of current cycle
    return nextCycleStart.subtract(const Duration(days: 1));
  }
  
  /// Get the start of the next billing cycle
  static DateTime getNextCycleStart(int monthStartDay) {
    final now = DateTime.now();
    final startDay = monthStartDay.clamp(1, 28);
    
    if (now.day < startDay) {
      // Next cycle starts this month
      return DateTime(now.year, now.month, startDay);
    } else {
      // Next cycle starts next month
      final nextMonth = DateTime(now.year, now.month + 1, startDay);
      return nextMonth;
    }
  }
  
  /// Check if a date falls within the current billing cycle
  static bool isInCurrentCycle(DateTime date, int monthStartDay) {
    final cycleStart = getCurrentCycleStart(monthStartDay);
    final cycleEnd = getCurrentCycleEnd(monthStartDay);
    
    return date.isAfter(cycleStart.subtract(const Duration(days: 1))) &&
        date.isBefore(cycleEnd.add(const Duration(days: 1)));
  }
  
  /// Get billing cycle start and end for a given date
  static MapEntry<DateTime, DateTime> getCycleForDate(DateTime date, int monthStartDay) {
    final startDay = monthStartDay.clamp(1, 28);
    
    DateTime cycleStart;
    if (date.day < startDay) {
      // Date is before start day, so cycle started last month
      cycleStart = DateTime(date.year, date.month - 1, startDay);
    } else {
      // Cycle starts this month
      cycleStart = DateTime(date.year, date.month, startDay);
    }
    
    // Next cycle start is one month after current cycle start
    final nextMonthDate = DateTime(cycleStart.year, cycleStart.month + 1, 1);
    final cycleEnd = DateTime(nextMonthDate.year, nextMonthDate.month, startDay)
        .subtract(const Duration(days: 1));
    
    return MapEntry(cycleStart, cycleEnd);
  }
  
  /// Format billing cycle display (e.g., "Dec 15 - Jan 14")
  static String formatBillingCycle(int monthStartDay) {
    final cycleStart = getCurrentCycleStart(monthStartDay);
    final cycleEnd = getCurrentCycleEnd(monthStartDay);
    
    final dateFormat = DateFormat('MMM d');
    return '${dateFormat.format(cycleStart)} - ${dateFormat.format(cycleEnd)}';
  }
}
