# A horizontal & vertical tab widget for flutter

## Getting started

A simple example of usage. To see all settings please visit API reference of this package

### HorizontalTabView

```dart
HorizontalTabView(
    initialIndex: 0,
    contentScrollAxis: Axis.horizontal,
    backgroundColor: Colors.grey.shade100,
    tabs: List.generate(10, (idx) => Tab(text: "Flutter")),
    contents:
        List.generate(items.length, (idx) => 
            Container(child: Text('Flutter'), padding: EdgeInsets.all(20))
        )
    ),
);
```

### VerticalTabView

```dart
...

VerticalTabView(
  tabsWidth: 150,
  tabs: <Tab>[
    Tab(child: Text('Flutter'), icon: Icon(Icons.phone)),
    Tab(child: Text('Dart')),
    Tab(child: Text('NodeJS')),
    Tab(child: Text('PHP')),
    Tab(child: Text('HTML 5')),
  ],
  contents: <Widget>[
    Container(child: Text('Flutter'), padding: EdgeInsets.all(20)),
    Container(child: Text('Dart'), padding: EdgeInsets.all(20)),
    Container(child: Text('NodeJS'), padding: EdgeInsets.all(20)),
    Container(child: Text('PHP'), padding: EdgeInsets.all(20)),
    Container(child: Text('HTML 5'), padding: EdgeInsets.all(20))
  ],
),
```
