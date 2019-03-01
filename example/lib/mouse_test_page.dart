// Author: fertrig
import 'package:flutter/material.dart';

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
                    feedback: DefaultText(),
                    childWhenDragging: CatalogText(),
                    data: 'text',
                  ),
                  Draggable(
                    child: CatalogRaisedButton(),
                    feedback: DefaultRaisedButton(),
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
              child: PropertyTab()
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}

// Widget activeCanvasWidget;
ValueNotifier<Widget> activeCanvasWidget = ValueNotifier(null);

class PropertyTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PropertyTabState();
  }
}

class _PropertyTabState extends State<PropertyTab> {
  @override
  void initState() {
    super.initState();
    activeCanvasWidget.addListener(didActiveCanvasWidgetChange);
  }
  
  void didActiveCanvasWidgetChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (activeCanvasWidget.value == null) {
      return Text('select something on the canvas');
    }
    else {
      return Text(activeCanvasWidget.value.runtimeType.toString());  
    }
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
                  _droppedWidgets.add(CanvasWidget(child: DefaultText()));
                  targetColor = Colors.transparent;
                });
              }
              else if (data == 'raised-button') {
                setState(() {
                  _droppedWidgets.add(CanvasWidget(child: DefaultRaisedButton()));
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

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        print('clicked ${child.runtimeType.toString()}');
        activeCanvasWidget.value = child;
      });
  }
}

class CatalogWidget extends StatelessWidget {
  const CatalogWidget({this.child});
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
    return CatalogWidget(
      child: DefaultText()
    ); 
  }
}

class DefaultRaisedButton extends RaisedButton {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        print('clicked DefaultRaisedButton');
        activeCanvasWidget.value = this;
      },
      child: Text('Button')
    );
  }
}

class CatalogRaisedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogWidget(
      child: DefaultRaisedButton()
    );
  }
}


