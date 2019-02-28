// Author: fertrig
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Mouse test page for the example application.
class MouseTestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MouseTestPageState();
  }
}

class _MouseTestPageState extends State<MouseTestPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: new Text('Mouse events test'),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.red),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Draggable(
                    child: FooBarText(),
                    feedback: FooBarText(),
                    childWhenDragging: FooBarText(),
                    data: 'text',
                  ),
                  Draggable(
                    child: FooBarButton(),
                    feedback: FooBarButton(),
                    childWhenDragging: FooBarButton(),
                    data: 'raised-button',
                  ),
                ],
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.green),
              child: Canvas()
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.blue),
              // @TODO: show callbacks on screen onDragStarted, etc.
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class Canvas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasState();
  }
}

class _CanvasState extends State<Canvas> {
  final List<Widget> _droppedWidgets = [];
  Color targetColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
            builder: (context, List<String> candidateData, rejectedData) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: targetColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _droppedWidgets
                ),
              );
            },
            onWillAccept: (data) {
              setState(() {
                targetColor = Colors.lightGreen;
              });
              return true;
            },
            onLeave: (data) {
              setState(() {
                targetColor = Colors.transparent;
              });
            },
            onAccept: (data) {
              print('onAccept $data');
              if (data == 'text') {
                setState(() {
                  _droppedWidgets.add(Text('some default text'));
                  targetColor = Colors.transparent;
                });
              }
              else if (data == 'raised-button') {
                setState(() {
                  _droppedWidgets.add(
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Default Text')
                    )
                  );
                  targetColor = Colors.transparent;
                });
              }
              else {
                throw Exception('unexpected data');
              }
            },
          );
  }
}

class FooBar extends StatelessWidget {
  final Widget child;
  const FooBar({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      color: Colors.yellowAccent,
      child: child
    );  
  }
}

class FooBarText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FooBar(
      child: Text(
        'Text',
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 14,
          color: Colors.black,
          decoration: TextDecoration.none
        ),
      )
    ); 
  }
}

class FooBarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FooBar(
      child: RaisedButton(
        onPressed: () {},
        child: Text('RaisedButton')
      )
    );
  }
}


