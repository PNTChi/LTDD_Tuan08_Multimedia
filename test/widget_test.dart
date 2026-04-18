import 'package:flutter_test/flutter_test.dart';
import 'package:demo_multimedia/main.dart'; // Đảm bảo tên package đúng với tên project của bạn

void main() {
  testWidgets('Kiểm tra màn hình Menu hiển thị thành công', (WidgetTester tester) async {
    // Build app của chúng ta (bây giờ MyApp đã có const nên gọi const MyApp() sẽ không bị lỗi nữa)
    await tester.pumpWidget(const MyApp());

    // Kiểm tra xem trên màn hình có xuất hiện tiêu đề bài tập không
    expect(find.text('Danh sách Bài tập Tuần 08'), findsWidgets);

    // Kiểm tra xem nút bấm của Bài 1 có xuất hiện không
    expect(find.text('Bài 1: Media Picker'), findsOneWidget);
  });
}