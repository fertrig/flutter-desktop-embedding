// Author: fertrig
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
          title: new Text('Butterfree v0.0.1'),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Draggable(
                    child: CatalogText(),
                    feedback: BfDefaultText(),
                    childWhenDragging: CatalogText(),
                    data: 'text',
                  ),
                  Container(height: 25),
                  Draggable(
                    child: CatalogRaisedButton(),
                    feedback: BfDefaultRaisedButton(),
                    childWhenDragging: CatalogRaisedButton(),
                    data: 'raised-button',
                  ),
                  Container(height: 25),
                  // Draggable(
                  //   child: CatalogTextField(),
                  //   feedback: BfDefaultTextField(),
                  //   childWhenDragging: CatalogTextField(),
                  //   data: 'text-field'
                  // )
                  CatalogTextField()
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
              decoration: const BoxDecoration(color: Colors.transparent),
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

      var widgetDisplayName = '';

      if (activeWidget is BfDefaultText) {
        widgetDisplayName = BfDefaultText.displayName;
        textController.text = activeWidget.data;
        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('data:'),
              CupertinoTextField(
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

        const widgetTextProperties = ['style',
          'textAlign',
          'textDirection',
          'locale',
          'softWrap',
          'overflow',
          'textScaleFactor',
          'maxLines'];

        properties.addAll(widgetTextProperties.map((x) => Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [Text('$x:'), Text('...')]))
        );
      }

      if (activeWidget is BfDefaultRaisedButton) {
        widgetDisplayName = BfDefaultRaisedButton.displayName;
        verticalPaddingController.text = (activeWidget.padding.vertical/2).toString();
        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('verticalPadding:'),
              CupertinoTextField(
                controller: verticalPaddingController,
                onChanged: (value) {
                  editedProperty.value = EditedProperty(
                    propertyKey: 'vertical-padding',
                    propertyValue: value
                  );
                },
              ),
            ],
          )
        );

        horizontalPaddingController.text = (activeWidget.padding.horizontal/2).toString();
        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('horizontalPadding:'),
              CupertinoTextField(
                controller: horizontalPaddingController,
                onChanged: (value) {
                  editedProperty.value = EditedProperty(
                    propertyKey: 'horizontal-padding',
                    propertyValue: value
                  );
                },
              ),
            ],
          )
        );

        properties.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('onPressed:'),
              CupertinoTextField(),
            ],
          )
        );

        const widgetRaisedButtonProperties = [
          'onHighlightChanged',
          'textTheme',
          'textColor',
          'disabledTextColor',
          'color',
          'disabledColor',
          'highlightColor',
          'splashColor'
        ];

        properties.addAll(widgetRaisedButtonProperties.map((x) => Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [Text('$x:'), Text('...')]))
        );
      }

      return Container(
        // width: double.infinity,
        // height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widgetDisplayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                      color: Colors.black,
                      decoration: TextDecoration.underline
                    ),
                  ),
                )
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: properties.map((x) => Padding(padding: const EdgeInsets.all(8.0), child: x)).toList()
                )
              )
            ],
          ),
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
    setState(() {
      if (activeCanvasWidgetId > -1) {
        final editedWidget =_droppedWidgets[activeCanvasWidgetId];
        final bfDefaultWidget =editedWidget.child;
        if (bfDefaultWidget is BfDefaultText) {
          if (editedProperty.value.propertyKey == 'text') {
            _droppedWidgets[activeCanvasWidgetId] = CanvasWidget(
              id: activeCanvasWidgetId,
              child: BfDefaultText(
                text: editedProperty.value.propertyValue
              )
            );
          }
        }
        if (bfDefaultWidget is BfDefaultRaisedButton) {
          if (editedProperty.value.propertyKey == 'vertical-padding') {
            _droppedWidgets[activeCanvasWidgetId] = CanvasWidget(
              id: activeCanvasWidgetId,
              child:BfDefaultRaisedButton(
                id: activeCanvasWidgetId,
                verticalPadding: double.parse(editedProperty.value.propertyValue),
                horizontalPadding: bfDefaultWidget.horizontalPadding,
              )
            );
          }
          if (editedProperty.value.propertyKey == 'horizontal-padding') {
            _droppedWidgets[activeCanvasWidgetId] = CanvasWidget(
              id: activeCanvasWidgetId,
              child:BfDefaultRaisedButton(
                id: activeCanvasWidgetId,
                horizontalPadding: double.parse(editedProperty.value.propertyValue),
                verticalPadding: bfDefaultWidget.verticalPadding,
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
  const CatalogWidget({this.child, this.displayName});
  final Widget child;
  final String displayName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          // height: 70,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          color: Colors.lightBlueAccent,
          child: child
        ),
        Text(
          displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 14,
            color: Colors.black,
            decoration: TextDecoration.underline
          ),
        )
      ],
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
  static const displayName = 'Text';
}

class CatalogText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogWidget(
      child: BfDefaultText(),
      displayName: 'Text',
    ); 
  }
}

class BfDefaultRaisedButton extends StatelessWidget {

  const BfDefaultRaisedButton({
    this.id, 
    this.verticalPadding = 10, 
    this.horizontalPadding = 20 
  });

  final int id;
  final double verticalPadding;
  final double horizontalPadding;

  static const displayName = 'RaisedButton';

  EdgeInsetsGeometry get padding {
    return EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding);
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
      child: BfDefaultRaisedButton(),
      displayName: 'RaisedButton',
    );
  }
}

class BfDefaultTextField extends StatelessWidget {
  // const BfDefaultTextField({String text}) : super(text ?? 'Abc', style: defaultTextStyle);
  // static const defaultTextStyle = TextStyle(
  //   fontWeight: FontWeight.bold, 
  //   fontSize: 14,
  //   color: Colors.black,
  //   decoration: TextDecoration.none
  // );
  // static const displayName = 'Text';
  @override
  Widget build(BuildContext context) {
    return TextField();
  }
}

class CatalogTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CatalogWidget(
      child: BfDefaultTextField(),
      displayName: 'TextField',
    ); 
  }
}


