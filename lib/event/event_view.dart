// Xây dựng 1 widget lịch có chức năng tùy chỉnh chế độ xem
// Cho phép người dùng chọn các chế độ hiển thị khac nhau như: xem ngày, tuần, tháng, hoặc lịch trình

import 'package:event_manager/event/event_data_source.dart';
import 'package:event_manager/event/event_detail_view.dart';
import 'package:event_manager/event/event_model.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

// Định nghĩa trạng thái cho EventView
class _EventViewState extends State<EventView> {
  final eventService = EventService();
  // Danh sách sự lưu trữ sự kiện
  List<EventModel> items = [];
  // Tạo CalendarController để điều khiển lịch
  final calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    calendarController.view =
        CalendarView.day; //Thiết lập chế độ xem mặc định của lịch là ngày
    loadEvents(); // Gọi hàm để tải sự kiện
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents; // Lấy danh sách sự kiện
    setState(() {
      items = events; // Cập nhật danh sách sự kiện và làm mới giao diện
    });
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      // Phần AppBar
      appBar: AppBar(
        title: Text(al.appTitle), // Hiển thị tiêu đề ứng dụng
        actions: [
          PopupMenuButton<CalendarView>(
            // Tạo nút menu pop-up cho chế độ xem lịch
            onSelected: (value) {
              setState(() {
                calendarController.view = value;
              });
            },
            itemBuilder: (context) => CalendarView.values.map((view) {
              return PopupMenuItem<CalendarView>(
                // Tạo từng mục trong menu
                value: view,
                child: ListTile(
                  title: Text(view.name),
                ),
              );
            }).toList(),
            icon: getCalendarViewIcon(calendarController
                .view!), // Lấy biểu tượng tương ứng với chế độ xem
          ),
          IconButton(
              onPressed: () {
                calendarController.displayDate = DateTime.now();
              },
              icon: const Icon(Icons.today_outlined)),
          IconButton(onPressed: loadEvents, icon: const Icon(Icons.refresh))
        ],
      ),

      // Phần body
      body: SfCalendar(
        // Thêm lịch vào body
        controller: calendarController, // Gán controler cho lịch
        dataSource: EventDataSource(items), // Thiết lập nguồn dữ liệu cho lịch
        monthViewSettings: const MonthViewSettings(
            // Cấu hình thiết lập tháng cho lịch
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        // Nhấn giữ vào cell để thêm sự kiện
        onLongPress: (details) {
          // Không có sự kiện trong cell
          if (details.targetElement == CalendarElement.calendarCell) {
            // Tạo một đối tượng sự kiện tại thời gian lịch theo giao diên
            final newEvent = EventModel(
                startTime: details.date!,
                endTime: details.date!.add(const Duration(hours: 1)),
                subject: ' Sự kiện mới');
            // Điều hướng và định tuyến bằng cách đưa newEvent vào detail view
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EventDetailView(event: newEvent);
            })).then((value) async {
              // Sau khi pop ở detail view
              if (value == true) {
                await loadEvents();
              }
            });
          }
        },
        // Chạm vào sự kiện để xem và cập nhật
        onTap: (details) {
          // Khi chạm vào sự kiện --> sửa hoặc xóa
          if (details.targetElement == CalendarElement.appointment) {
            final EventModel event = details.appointments!.first;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EventDetailView(event: event);
            })).then((value) async {
              // Sau khi pop ở detail view
              if (value == true) {
                await loadEvents();
              }
            });
          }
        },
      ),
    );
  }

  // Hàm lấy icon tương ứng với calendar view
  Icon getCalendarViewIcon(CalendarView view) {
    switch (view) {
      case CalendarView.day:
        return const Icon(
            Icons.calendar_view_day_outlined); // Biểu tượng cho chế độ xem ngày
      case CalendarView.week:
        return const Icon(Icons
            .calendar_view_week_outlined); // Biểu tượng cho chế độ xem tuần
      case CalendarView.workWeek:
        return const Icon(Icons
            .work_history_outlined); // Biểu tượng cho chế độ xem tuần làm việc
      case CalendarView.month:
        return const Icon(Icons
            .calendar_view_month_outlined); // Biểu tượng cho chế độ xem tháng
      case CalendarView.schedule:
        return const Icon(
            Icons.schedule_outlined); // Biểu tượng cho chế độ xem lịch trình
      default:
        return const Icon(Icons.calendar_today_outlined); // Biểu tượng mặc định
    }
  }
}
