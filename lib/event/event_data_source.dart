// 4
// Cung cấp dữ liệu sự kiện cho widget lịch
import 'dart:ui';

import 'package:event_manager/event/event_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {    // Lấy thời gian ban đầu tại vị trí index    
    EventModel item = appointments!.elementAt(index);   // Lấy sự kiện từ danh sách
    return item.startTime;    // Trả về thời gian bắt đầu của sự kiện
  }

  @override
  DateTime getEndTime(int index) {    // Lấy thời gian kết thúc của sự kiện
    EventModel item = appointments!.elementAt(index);
    return item.endTime;    // Trả về thời gian kết thúc
  }

  @override
  String getSubject(int index) {    // Lấy tiêu đề của sự kiện
    EventModel item = appointments!.elementAt(index);
    return item.subject;    // Trả về tiêu đề sự kiện
  }

  @override
  String? getNotes(int index) {   // Lấy ghi chú sự kiện
    EventModel item = appointments!.elementAt(index);
    return item.notes;    // Trả về ghi chú nếu có
  }

  @override
  bool isAllDay(int index) {    // Kiểm tra xem sự kiện có phải là cả ngày hay không
    EventModel item = appointments!.elementAt(index);
    return item.isAllDay;   // Trả về True nếu là sự kiện cả ngày
  }

  @override
  String? getRecurrenceRule(int index) {    // Lấy quy tắc lặp lại sự kiện
    EventModel item = appointments!.elementAt(index);
    return item.recurrenceRule;   // Trả về quy tắc lặp lại nếu có
  }

  @override
  Color getColor(int index) {   // Lấy màu của sự kiện
    EventModel item = appointments!.elementAt(index);
    return item.isAllDay ? const Color(0xFF8644) : super.getColor(index);    // Nếu cả ngày thì trả về màu đã chọn, nếu không thì là màu mặc định
  }
}
