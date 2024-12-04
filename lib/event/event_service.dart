// 1
import 'package:event_manager/event/event_model.dart';
import 'package:localstore/localstore.dart';

class EventService {
  // Định nghĩa lớp
  final db = Localstore.getInstance(
      useSupportDir:
          true); //Localstore: Cho phép thực hiện các thao tác lưu dữ liệu cục bộ trong flutter

  // Tên collection trong localstore (Giống như tên bảng)
  final path = 'events';

// Hàm lấy danh sách toàn bộ sự kiện từ localstore
  Future<List<EventModel>> get getAllEvents async {
    // Future: đại diện cho 1 giá trị sẽ có trong tương lai,
    // nó thực hiện các tác vụ bất đồng bộ (asynchronous) và sẽ trả về một danh sách (List<EventModel>).
    final eventsMap = await db.collection(path).get(); // Lấy giữ liệu từ events

    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        //entries: là thuộc tính của map cho phép truy cập key-value
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

// Hàm lưu một sự kiện vào localstore
  Future<void> saveEvent(EventModel item) async {
    // Nếu id không tồn tại (tạo mới) thì lấy một id ngẫu nhiên
    item.id ??= db.collection(path).doc().id;
    await db
        .collection(path)
        .doc(item.id)
        .set(item.toMap()); // Thực hiện lưu trữ dữ liệu
  }

// Hàm xóa một sự kiện từ localstore
  Future<void> deleteEvent(EventModel item) async {
    await db.collection(path).doc(item.id).delete();
  }
}
