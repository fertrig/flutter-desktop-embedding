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
                    child: CatalogText(),
                    feedback: CatalogText(),
                    childWhenDragging: CatalogText(),
                    data: 'text',
                  ),
                  Draggable(
                    child: CatalogRaisedButton(),
                    feedback: CatalogRaisedButton(),
                    childWhenDragging: CatalogRaisedButton(),
                    data: 'raised-button',
                  ),
                ],
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.green),
              child: Canvas()
            ),
            flex: 3,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.blue),
              // @TODO: do rough properties tab? the clean it up a bit for monday's demo
            ),
            flex: 2,
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

class CatalogWidgetContainer extends StatelessWidget {
  const CatalogWidgetContainer({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      color: Colors.yellowAccent,
      child: child
    );  
  }
}

class DefaultText extends Text {
  const DefaultText() : super('Abc', style: defaultTextStyle);
  static const defaultTextStyle = TextStyle(
    fontWeight: FontWeight.bold, 
    fontSize: 14,
    color: Colors.black,
    decoration: TextDecoration.none
  );
}

class CatalogText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogWidgetContainer(
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


class CatalogRaisedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogWidgetContainer(
      child: RaisedButton(
        onPressed: () {},
        child: Text('RaisedButton')
      )
    );
  }
}


