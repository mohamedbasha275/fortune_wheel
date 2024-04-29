import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class DayWheelViewBody extends StatefulWidget {
  const DayWheelViewBody({super.key});

  @override
  State<DayWheelViewBody> createState() => _DayWheelViewBodyState();
}

class _DayWheelViewBodyState extends State<DayWheelViewBody> {
  StreamController<int>? controller;

  List<String> fortuneTitles = const [
    'صلاة ركعتين شكر',
    'تصدق (١ - ٥ جنيه)',
    '١٠٠ استغفار',
    '١٠٠ صلاة علي النبي',
    '١٠٠ سبحان الله',
    '١٠٠ الحمد لله',
    '١٠٠ الله أكبر',
    'قراءة ٥٠ آية',
    'الدعاء ل ١٠ أصدقاء',
  ];

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>.broadcast();
  }

  @override
  void dispose() {
    controller?.close();
    super.dispose();
  }

  bool isEnd = false;

  @override
  Widget build(BuildContext context) {
    List<FortuneItem> fortuneItems = [
      wheelItem('صلاة ركعتين شكر'),
      wheelItem('تصدق (١ - ٥ جنيه)'),
      wheelItem('١٠٠ استغفار'),
      wheelItem('١٠٠ صلاة علي النبي'),
      wheelItem('١٠٠ سبحان الله'),
      wheelItem('١٠٠ الحمد لله'),
      wheelItem('١٠٠ الله أكبر'),
      wheelItem('قراءة ٥٠ آية'),
      wheelItem('الدعاء ل ١٠ أصدقاء'),
    ];
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/wheel-border.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
            child: FortuneWheel(
              selected: controller!.stream,
              animateFirst: false,
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 1000),
                curve: Curves.decelerate,
              ),
              onFling: () {
                controller!.add(Random().nextInt(fortuneItems.length));
              },
              indicators: <FortuneIndicator>[
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/label.png',
                    width: 40,
                  ),
                ),
              ],
              onAnimationEnd: () {
                setState(() {
                  isEnd = true;
                });
              },
              onAnimationStart: () {
                setState(() {
                  isEnd = false;
                });
              },
              items: fortuneItems,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: 300,
          child: StreamBuilder(
            stream: controller!.stream,
            builder: (context, snapshot) => snapshot.hasData && isEnd
                ? dayWheelChoice(snapshot)
                : Container(),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }

  FortuneItem wheelItem(String title) {
    return FortuneItem(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget dayWheelChoice(var snapshot) {
    var index = snapshot.data.toString();
    String text = fortuneTitles[int.parse(index)];
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
