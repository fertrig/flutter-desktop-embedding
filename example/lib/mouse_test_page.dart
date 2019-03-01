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
                    feedback: BfDefaultText(),
                    childWhenDragging: CatalogText(),
                    data: 'text',
                  ),
                  Draggable(
                    child: CatalogRaisedButton(),
                    feedback: BfDefaultRaisedButton(),
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

class EditedProperty {
  const EditedProperty({this.propertyKey, this.propertyValue});
  final String propertyKey;
  final String propertyValue;
}

// Widget activeCanvasWidget;
ValueNotifier<Widget> activeCanvasWidget = ValueNotifier(null);
int activeCanvasWidgetId = -1;
ValueNotifier<EditedProperty> editedProperty = ValueNotifier(null);

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
      // return Text(activeCanvasWidget.value.runtimeType.toString());
      final activeWidget = activeCanvasWidget.value;
      final properties = <Widget>[];

      final textController = TextEditingController();
      final verticalPaddingController = TextEditingController();
      final horizontalPaddingController = TextEditingController();

      if (activeWidget is BfDefaultText) {
        textController.text = activeWidget.data;
        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Text:'),
              TextField(
                controller: textController,
                onChanged: (value) {
                  editedProperty.value = EditedProperty(
                    propertyKey: 'text',
                    propertyValue: value
                  );
                },
              ),
            ],
          )
        );
      }

      if (activeWidget is BfDefaultRaisedButton) {
        verticalPaddingController.text = (activeWidget.padding.vertical/2).toString();
        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Vertical Padding:'),
              TextField(controller: verticalPaddingController),
            ],
          )
        );

        horizontalPaddingController.text = (activeWidget.padding.horizontal/2).toString();
        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Horizontal Padding:'),
              TextField(controller: horizontalPaddingController),
            ],
          )
        );
      }

      return Container(
        // width: double.infinity,
        // height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text('Widget type: ${activeWidget.runtimeType.toString()}')),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: properties
              )
            )
          ],
        ),
      );
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
  final List<CanvasWidget> _droppedWidgets = [];
  Color targetColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    editedProperty.addListener(didEditedPropertyChange);
  }
  
  void didEditedPropertyChange() {
    print('didEditedPropertyChange');
    setState(() {
      print('activeCanvasWidgetId $activeCanvasWidgetId');
      if (activeCanvasWidgetId > -1) {
        final editedWidget =_droppedWidgets[activeCanvasWidgetId];
        print('editedWidget ${editedWidget.id}');
        if (editedWidget.child is BfDefaultText) {
          if (editedProperty.value.propertyKey == 'text') {
            print('setting property $activeCanvasWidgetId ${editedProperty.value.propertyKey} ${editedProperty.value.propertyValue}');
            _droppedWidgets[activeCanvasWidgetId] = CanvasWidget(
              id: activeCanvasWidgetId,
              child: BfDefaultText(
                text:editedProperty.value.propertyValue
              )
            );
          }
        }
      }
    });
  }

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
              final widgetId =_droppedWidgets.length;
              print('onAccept $data');
              if (data == 'text') {
                setState(() {
                  _droppedWidgets.add(CanvasWidget(id: widgetId, child: BfDefaultText()));
                  targetColor = Colors.transparent;
                });
              }
              else if (data == 'raised-button') {
                setState(() {
                  _droppedWidgets.add(CanvasWidget(id: widgetId, child: BfDefaultRaisedButton(id: widgetId)));
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
  const CanvasWidget({this.id, this.child});
  final int id;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        print('clicked ${child.runtimeType.toString()} $id');
        activeCanvasWidgetId = id;
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

class BfDefaultText extends Text {
  const BfDefaultText({String text}) : super(text ?? 'Abc', style: defaultTextStyle);
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
      child: BfDefaultText()
    ); 
  }
}

class BfDefaultRaisedButton extends StatelessWidget {

  const BfDefaultRaisedButton({this.id});

  final int id;

  EdgeInsetsGeometry get padding {
    return EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        print('clicked DefaultRaisedButton $id');
        activeCanvasWidgetId = id;
        activeCanvasWidget.value = this;
      },
      padding: padding,
      child: Text('Button')
    );
  }
}

class CatalogRaisedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogWidget(
      child: BfDefaultRaisedButton()
    );
  }
}


