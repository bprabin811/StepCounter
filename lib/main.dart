
import 'package:flutter/material.dart';
import 'package:tracker/homepage.dart';
import 'package:permission_handler/permission_handler.dart';



void main() {
  runApp(const Tracker());
}

class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  Color myColor= Colors.grey.shade300;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
  }

   void _fetchPermissionStatus() {
    Permission.activityRecognition.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

  
  @override
  Widget build(BuildContext context) {

    
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DLTracker',
      
      home: Scaffold(   
        backgroundColor: myColor,
        body: Builder(
          builder: (context) {
            if (_hasPermissions) {
              return const MyHomePage();
            } else {
              return _buildPermissionSheet();
            }
          },
        ),
      ),
    );
  }
  Widget _buildPermissionSheet() {
    return Center(
      child: ElevatedButton(
        child: const Text('Request Permissions'),
        onPressed: () {
          Permission.activityRecognition.request().then((ignored) {
            _fetchPermissionStatus();
          });
        },
      ),
    );
  }
}


class Style{
  static TextStyle heading1 = const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,);
}


 