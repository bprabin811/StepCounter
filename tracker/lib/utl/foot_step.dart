import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


String formatDate(DateTime d) {
  return d.toString().substring(0, 18);
}


class MyFootStep extends StatefulWidget {
  const MyFootStep({Key? key}) : super(key: key);
  

  @override
  State<MyFootStep> createState() => _MyFootStepState();
}

class _MyFootStepState extends State<MyFootStep> {
  num myTarget=10000;
  var items =[1000,2000,5000,10000,15000,20000];
  DateTime myTime= DateTime.now();
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'Stopped', _steps = '0',_step = '0';
  List<int> myList=[];
  @override

  void initState() {
    super.initState();
    initPlatformState();
  }
  

  void onStepCount(StepCount event) {
    //print(event);
      setState(() {
      _step = (event.steps).toString();
      myList.add(int.parse(_step));
    });
    
    setState(() {
      _steps = (event.steps).toString();
    });
  }


  

  void onPedestrianStatusChanged(PedestrianStatus event) {
    //print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    //print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    //print(_status);
  }

  void onStepCountError(error) {
    //print('onStepCountError: $error');
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

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                    height: 180,
                                    width: 161,              
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(143, 18, 174, 185),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                     child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children:  [
                                          const Text("Steps\nTaken:",style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(161, 0, 0, 0),
                                         ),),
                                         Text(_steps,style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                         ),),
                                       ],
                                     ),
                                   ),
                          ),
                                 Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Container(
                                height: 180,
                                width: 161,
                                decoration: BoxDecoration(
                                      color: const Color.fromARGB(159, 221, 161, 71),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:  [
                                
                                      const Text("Distance\nCovered:",style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                       color: Color.fromARGB(161, 0, 0, 0),
                                      ),),
                                      Text(int.parse(_steps)*0.762<1000?'${((int.parse(_steps)*0.762)).toStringAsFixed(2)} m':'${((int.parse(_steps)*0.762)/1000).toStringAsFixed(2)} km',style: const TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.white,
                                      ),),
                                    ],
                                ),
                              ),
                                 ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                    height: 180,
                                    width: 161,              
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(166, 56, 230, 91),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                     child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children:  [
                                         const Text("Target\nSteps:",style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(161, 0, 0, 0),
                                         ),),
                                       
                                        DropdownButton(
                                          // Initial Value
                                          value: myTarget,
                                          // Array list of items
                                          items: items.map((num items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text('$items',style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[300],
                                                ),),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (num? newValue) {
                                            setState(() {
                                              myTarget = newValue!;
                                            });
                                          },
                                        ),
                                       ],
                                     ),
                                   ),
                          ),
                                 Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Container(
                                height: 180,
                                width: 161,
                                decoration: BoxDecoration(
                                      color: const Color.fromARGB(190, 216, 213, 206),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:  [
                                
                                       const Text("Current\nStatus:",style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                       color: Color.fromARGB(161, 0, 0, 0),
                                      ),),
                                      Text(_status,style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),),
                                    ],
                                ),
                              ),
                                 ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                   padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                   child: Container(
                    height: 120,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(131, 94, 131, 233),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    
                     child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children:  [
                           const Text("Progress:",style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(161, 0, 0, 0),
                                       ),),
                        
                           Row(
                             children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left:15.0),
                                    child: Icon(Icons.run_circle,size: 30,),
                                  ),
                               Padding(
                               padding: const EdgeInsets.all(15.0),
                               child: LinearPercentIndicator(
                                animation: true,
                                animationDuration: 1000,
                                width: 220,
                                lineHeight: 20,
                                trailing: Text('${((int.parse(_steps)/myTarget)*100).toStringAsFixed(2)}%',style: const TextStyle(
                                  fontSize: 10,
                                ),),
                                percent: int.parse(_steps)/myTarget<1?int.parse(_steps)/myTarget:1,
                                progressColor: ((int.parse(_steps)/myTarget)*100>=0.8)?const Color.fromARGB(201, 118, 166, 64):Colors.red,
                                barRadius: const Radius.circular(10),
                               ),
                         ),
                             ],
                           ),
                        
                         
                          
                         
                       ],
                     )
                   ),
                 ),
                //  Padding(
                //    padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                //    child: Container(
                //     height: 300,
                //     width: 400,
                //     decoration: const BoxDecoration(
                //       color: Color.fromARGB(131, 94, 131, 233),
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //     ),
                    
                //      child:Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //        children:  [
                //            const Text("Today:",style: TextStyle(
                //                         fontSize: 20,
                //                         fontWeight: FontWeight.bold,
                //                         color: Color.fromARGB(161, 0, 0, 0),
                //                        ),),

                //             Padding(
                //               padding: const EdgeInsets.all(10.0),
                //               child: Text('$myList'),
                              
                //               // SfSparkLineChart(
                //               //   marker: const SparkChartMarker(
                //               //     borderColor: Colors.pink,
                //               //     color: Colors.pink,
                //               //     borderWidth: 2,
                //               //         displayMode: SparkChartMarkerDisplayMode.all),
                //               //   //Enable data label
                //               //   labelDisplayMode: SparkChartLabelDisplayMode.all,
                //               //   trackball: const SparkChartTrackball(),
                //               //   axisLineColor: Colors.pink,
                //               //   color: Colors.teal,
                //               //   data: myList,
                //               // ),
                //             )
                        
                           
                        
                         
                          
                         
                //        ],
                //      )
                //    ),
                //  ),
      ],
    );
  }
}