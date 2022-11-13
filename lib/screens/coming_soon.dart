import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({
    super.key,
  });

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: Container(
                height: height,
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("New Features Coming Soon!")),
                  )
                ]))));
  }
}
