import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/progress.dart';
import '../widgets/header.dart';

class Timeline extends StatelessWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true, titleText: ''),
        body: linearProgress());
  }
}

// import 'package:flutter/material.dart';
// import 'package:fluttershare/widgets/header.dart';

// import '../widgets/header.dart';

// class Timeline extends StatefulWidget {
//   @override
//   _TimelineState createState() => _TimelineState();
// }

// class _TimelineState extends State<Timeline> {
//   @override
//   Widget build(context) {
//     return Scaffold(
//       appBar: header(context, isAppTitle: true),
//       body: Text("Timeline"),
//     );
//   }
// }
