import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MyFootStep extends StatefulWidget {
  const MyFootStep({Key? key}) : super(key: key);

  @override
  State<MyFootStep> createState() => _MyFootStepState();
}

class _MyFootStepState extends State<MyFootStep> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'Stopped', _steps = '0', _step = '0';
  final List<List<int>> _dailyStepCounts = List.generate(7, (_) => []);
  final List<String> _days = [
    'Today',
    'Yesterday',
    DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 2))),
    DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 3))),
    DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 4))),
    DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 5))),
    DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 6))),
    // DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 7))),
    // DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 8))),
    // DateFormat('EEEE').format(DateTime.now().subtract(const Duration(days: 9))),
  ];

  int _currentDay = 0;

  @override
  void initState() {
    super.initState();
    _currentDay = 0;
    initPlatformState();
  }

  void onStepCount(StepCount event) async {
    setState(() {
      _step = event.steps.toString();
      _dailyStepCounts[_currentDay].add(int.parse(_step));
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('step_count', event.steps);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    // schedule the reset at midnight
    Timer.periodic(const Duration(days: 1), (timer) {
  DateTime now = DateTime.now();
  if (now.hour == 0 && now.minute == 0 && now.second == 0) {
    resetStepCount();
    saveDailyStepCounts();
    _currentDay = 0;
  }
});


    if (!mounted) return;
  }

  Future<void> resetStepCount() async {
    final prefs = await SharedPreferences.getInstance();
    final stepCount = prefs.getInt('step_count') ?? 0;

    DateTime lastReset =
        DateTime.parse(prefs.getString('last_reset') ?? '2000-01-01');
    DateTime now = DateTime.now();
    if (lastReset.year != now.year ||
        lastReset.month != now.month ||
        lastReset.day != now.day) {
      await prefs.setInt('step_count', 0);
      await prefs.setString('last_reset', now.toString());
      setState(() {
        _steps = '0';
      });
    } else {
      setState(() {
        _steps = stepCount.toString();
      });
    }
  }
  


  Future<void> saveDailyStepCounts() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _dailyStepCounts.length; i++) {
      final key = 'day_${i + 1}_step_counts';
      final value = _dailyStepCounts[i].join(',');
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              SizedBox(
                height: 300,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      image: AssetImage(
                        _status == 'walking'
                            ? 'assets/images/panda.gif'
                            : 'assets/images/stop.jpg',
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(
                height: 300,
                child: Container(
                  alignment: const Alignment(0, 1.2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _steps,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Distance Covered',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400),
              ),
              Text(
                int.parse(_steps) * 0.762 < 1000
                    ? '${((int.parse(_steps) * 0.762)).toStringAsFixed(2)} m'
                    : '${((int.parse(_steps) * 0.762) / 1000).toStringAsFixed(2)} km',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.pink.shade800),
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          color: Colors.red.shade800,
          indent: 10,
          endIndent: 10,
        ),
        
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _days.length,
          itemBuilder: (BuildContext context, int index) {
            final String day = _days[index];
            final List<int> steps = _dailyStepCounts[index];
            final int totalSteps = steps.fold(0, (a, b) => a + b);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 1,
                color: Colors.red.shade400,
                child: ListTile(
                  leading:const Icon(Icons.directions_walk,color: Colors.amber,),
                  title: Text(day,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$totalSteps steps',style: const TextStyle(color: Colors.amber),),
                      Text( int.parse('$totalSteps') * 0.762 < 1000
                    ? '${((int.parse('$totalSteps') * 0.762)).toStringAsFixed(2)} m'
                    : '${((int.parse('$totalSteps') * 0.762) / 1000).toStringAsFixed(2)} km',style: const TextStyle(color: Colors.amber),)
                    ],
                  ),
                  trailing:const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
