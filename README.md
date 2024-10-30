# event_manager

### 1. Thêm các thư viện (kiểm tra trong file pubspec.yaml)
File **pubspec.yaml** là nơi cấi hình các thông tin và yêu cầu cho dự án
- ``flutter pub add flutter_localizations --sdk=flutter ``
  - **Là gói** do Flutter cung cấp và hỗ trợ tích hợp các bản dịch và định dạng phù hợp cho ngôn ngữ người dùng
  - Mục đích: Tự động cung cấp các bản dịch cho những thành phần giao diện mặc định của Flutter như nút bấm, hộp thoại, định dạng ngày tháng.
  - Ví dụ: Nút "Cancel" sẽ tự động chuyển thành "Hủy" nếu hệ thống dùng tiếng Việt.
- ``flutter pub add intl:any``
**Là thư viện** dùng để dịch, định dạng số, ngày giờ và tiền tệ
  - Mục đích: Dùng để dịch văn bản tùy chỉnh trong ứng dụng của bạn mà không có sẵn trong Flutter, ví dụ như các thông báo hoặc đoạn văn mà bạn tự tạo.
  - Ví dụ:"Chào mừng bạn đến với ứng dụng",sẽ tự tạo bản dịch cho nó bằng intl để ứng dụng hiển thị thành "Welcome to the app" khi người dùng chọn tiếng Anh.
- ``` flutter pub add localstore ```
**Là gói** dùng để lưu trữ dữ liệu cục bộ trong ứng dụng Flutter
    -   Cho phép thực hiện các thao tác tạo, đọc, cập nhật và xóa dữ liệu mà không cần **internet**
- ``flutter pub add syncfusion_flutter_calendar  ``
**Là gói** cung cấp các widget để tạo lịch và quản lý sự kiện
    - Hiển thị lịch theo nhiều dạng khác nhau
    - Hỗ trợ thêm, sửa đổi và xóa các sự kiện trong lịch
    - Tùy chỉnh giao diện
## 2. Tạo file l10n trong file lib
### 1. Thiết lập ngôn ngữ: 
- Cấu hình cho ngôn ngữ tiếng anh và ngôn ngữ tiếng việt: 
    - Tạo 2 file `app_en.arb` và `app_vi.arb`: lưu trữ các chuỗi văn bản mà muốn dịch sang tiếng nào đấy
## 2. Tạo Folder event
### 1. Tạo file service.dart
- Dùng để **Quản Lý Các Thao Tác** liên quan đến dữ liệu sự kiện. Cụ thể nó là 1 lớp dịch vụ **service class** dùng để tương tác với dữ liệu sự kiện, có thể bao gồm việc thêm, lấy, cập nhật và xóa sự kiện từ nguồn lưu trữ
-  Các chức năng chính thường có trong **event_service.dart**
   - Lấy danh sách sự kiện: phương thức ``getAllEvents`` để tải toàn bộ sựu kiện và trả về dưới dạng List()
   - Thêm sự kiện, cập nhật, xóa ... 
### 2. Tạo file model.dart
- Dùng để **Định Nghĩa Các Lớp**, bao gồm các thuộc tính và phương thức để quản lý sự kiện như: tiêu đề, thời gian bắt đầu, kết thúc, ghi chú, ...

### 3. Tạo file detail_view.dart
- Dùng để ****Tạo Ra Giao Diện**** cho việc thêm mới hoặc chỉnh sửa thông tin sự kiện. Trong giao diện này, người dùng có thể:
  1. Nhập thông tin sự kiện: bao gồm ghi tiêu đề và ghi chú sự kiện
  2. Chọn thời gian bắt đầu và kết thúc: Hộp thoại chọn ngày giờ
  4. Xóa sự kiện
  5. Quay lại màn hình chính
### 4. Tạo file data_source.dart
- Dùng để cung cấp dữ liệu sự kiện cho widget lịch trong ứng dụng bằng cách sử dụng `EventDataSource` - 1 lớp kế thừ từ `CalendarDataSource`
- Chức năng cụ thẻ của file:
  - Cung cấp các thuộc tính quant trọng cho sự kiện như ngày bắt đầu, thời gian kết thúc, tiêu đề, ghi chú và quy tắc lặp lại và thông tin sự kiện cả ngày
  - Tùy chỉnh màu sự kiện
  