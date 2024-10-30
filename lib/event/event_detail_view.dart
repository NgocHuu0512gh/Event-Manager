// File này cho phép người dùng thêm hoặc sửa thông tin của sự kiện
import 'package:event_manager/event/event_model.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Màn hình chi tiết sự kiện, cho phép thêm mới hoặc cập nhật
class EventDetailView extends StatefulWidget {
  final EventModel event; // Đối tượng được sự kiện truyền vào
  const EventDetailView({super.key, required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final subjectController =
      TextEditingController(); // Bộ điều khiển cho ô tiêu đề sự kiện
  final notesController =
      TextEditingController(); // Bộ điều khiển cho ô ghi chú
  final eventService =
      EventService(); // Đối tượng để thao tác với dữ liệu trong localStore

  @override
  void initState() {
    // Khởi tạo thiết lập dữ liệu ban đầu cho các bộ điều khiển
    super.initState();
    subjectController.text = widget.event.subject; // Lấy và gán tiêu đề sự kiện
    notesController.text =
        widget.event.notes ?? ''; // Lấy và gán ghi chú nếu có
  }

// Hàm hiển thị hộp thoại chọn ngày và giờ
  Future<void> _pickDateTime({required bool isStart}) async {
    // Hiển thị hộp thoại chọn ngày
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? widget.event.startTime : widget.event.endTime,
      firstDate: DateTime(2000), // Ngày bắt đầu có thể chọn
      lastDate: DateTime(2101), // Ngày cuối cùng có thể chọn
    );

    if (pickedDate != null) {
      // Kiểm tra người dùng đã chọn ngày hay chưa
      if (!mounted) return;
      // Hiển hộp thoại chọn giờ sau khi chọn ngày
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStart
              ? widget.event.startTime
              : widget.event
                  .endTime, // Giờ mặc định là startTime và endTime của sự kiện
        ),
      );

      if (pickedTime != null) {
        // Kiểm tra người dùng đã chọn giờ hay chưa
        setState(() {
          // Gộp ngày và giờ thành một 'DateTime'
          final newDateTime = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
          if (isStart) {
            // Nếu người dùng chọn startTime
            widget.event.startTime =
                newDateTime; // Cập nhật thời gian bắt đầu sự kiện
            if (widget.event.startTime.isAfter(widget.event.endTime)) {
              // Tự thiết lập endTime 1 tiếng sau startTime
              widget.event.endTime =
                  widget.event.startTime.add(const Duration(hours: 1));
            }
          }
        });
      }
    }
  }

// Hàm lưu sự kiện vào localStore
  Future<void> _saveEvent() async {
    widget.event.subject = subjectController.text; // Cập nhật tiêu đề sự kiện
    widget.event.notes = subjectController.text; // Cập nhật ghi chú sự kiện
    await eventService
        .saveEvent(widget.event); // Gọi hàm lưu sự kiện trong Localstore
    if (!mounted) return;
    Navigator.of(context).pop(true); // Trở về màn hình trước đó
  }

// Hàm xóa sự kiện localstore
  Future<void> _deleteEvent() async {
    await eventService
        .deleteEvent(widget.event); // Gọi hàm xóa sự kiện trong localstore
    if (!mounted) return;
    Navigator.of(context).pop(true); // Trở về màn hình trước đó
  }

// Tạo giao diện cho màn hình sự kiện
  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(
        context)!; // Dấu '!' Chắc chắn có giá trị không thể null - nếu null là lỗi
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.event.id == null ? al.addEvent : al.eventDetails),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'Tên sự kiện'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Sự kiện cả ngày'),
                  trailing: Switch(
                      value: widget.event.isAllDay,
                      onChanged: (value) {
                        setState(() {
                          widget.event.isAllDay = value;
                        });
                      }),
                ),
                // Sử dụng toán tử trải rộng trong Dart
                if (!widget.event.isAllDay) ...[
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                        'Bắt đầu: ${widget.event.formatedStartTimeString}'),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () => _pickDateTime(isStart: true),
                  ),
                  ListTile(
                    title:
                        Text('Kết thúc: ${widget.event.formatedEndTimeString}'),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () => _pickDateTime(isStart: false),
                  ),
                  TextField(
                    controller: notesController,
                    decoration:
                        const InputDecoration(labelText: 'Ghi chú sự kiện'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Chỉ hiện thị nút xóa nếu không phải sự kiện mới
                      if (widget.event.id != null)
                        FilledButton.tonalIcon(
                            onPressed: _deleteEvent,
                            label: const Text('Xóa sự kiện')),
                      FilledButton.icon(
                          onPressed: _saveEvent,
                          label: const Text('Lưu sự kiện'))
                    ],
                  )
                ]
              ],
            ),
          ),
        ));
  }
}
