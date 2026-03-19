import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SimpleUseExample extends StatefulWidget {
  const SimpleUseExample({super.key});

  @override
  State<SimpleUseExample> createState() => _NewWidgetExampleState();
}

class _NewWidgetExampleState extends State<SimpleUseExample> {
  DateTime _selectedDate = DateTime.now();
  late final EasyDatePickerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = EasyDatePickerController();
  }

  @override
  void dispose() {
    // do not forget to dispose the controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EasyDateTimeLinePicker(
          controller: _controller,
          firstDate: DateTime(2024, 3, 18),
          lastDate: DateTime(2030, 3, 18),
          focusedDate: _selectedDate,
          onDateChange: (selectedDate) {
            setState(() {
              _selectedDate = selectedDate;
            });
          },
        ),
      ],
    );
  }
}
