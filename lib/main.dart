import 'package:event_manager/event/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp()); // Hàm main khởi động ứng dụng với widget MainApp
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        // Tự động lấy và hiển thị nội dung phù hợp cho ứng dụng mà không phải tự dịch
        AppLocalizations.delegate, // Dịch văn bản trong file .arb
        GlobalMaterialLocalizations
            .delegate, // Dịch các văn bản mặc định của flutter (Ví dụ như "Cancel")
        GlobalWidgetsLocalizations
            .delegate // Dịch các định dạng khác( như ngày, tháng, số) theo từng ngôn ngữ
      ],
      supportedLocales: [
        Locale('en'), // Hỗ trợ tiếng anh
        Locale('vi'), // Hỗ trợ tiếng việt
      ],
      locale: Locale('vi'), // Ngôn ngữ mặc định
      home: EventView(),
      debugShowCheckedModeBanner: false, // Tắt nhẵn debug
    );
  }
}
