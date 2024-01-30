import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothing App 203082',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClothingApp(),
    );
  }
}

class ClothingApp extends StatefulWidget {
  @override
  _ClothingAppState createState() => _ClothingAppState();
}

class _ClothingAppState extends State<ClothingApp> {
  Map<String, List<String>> categorizedClothes = {
    'Blouses': ['Item 1', 'Item 2'],
    'Pants': ['Item 3', 'Item 4'],
    'Shoes': ['Item 5'],
    'Bags': ['Item 6', 'Item 7'],
  };

  Map<String, Map<String, bool>> selectedClothes = {};
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = categorizedClothes.keys.first;
    _initializeSelection();
  }

  void _initializeSelection() {
    categorizedClothes.forEach((category, items) {
      selectedClothes[category] = {for (var item in items) item: false};
    });
  }

  void _showAddItemDialog() {
    final _itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Add Item', style: TextStyle(color: Colors.blue)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          selectedCategory = newValue ?? selectedCategory;
                        });
                      },
                      items: categorizedClothes.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: TextStyle(color: Colors.blue)),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: _itemController,
                      decoration: InputDecoration(hintText: 'Item Name'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    setState(() {
                      String newItem = _itemController.text;
                      if (newItem.isNotEmpty) {
                        categorizedClothes[selectedCategory]?.add(newItem);
                        selectedClothes[selectedCategory]?[newItem] = false;
                      }
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addClothing() {
    _showAddItemDialog();
  }

  void _removeClothing() {
    setState(() {
      selectedClothes.forEach((category, items) {
        var selectedItems = items.entries.where((item) => item.value).toList();
        for (var selectedItem in selectedItems) {
          categorizedClothes[category]?.remove(selectedItem.key);
          selectedClothes[category]?.remove(selectedItem.key);
        }
      });
    });
  }

  void _editClothing() {
    String? editCategory = selectedCategory;
    String? originalItem;
    final _itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Item', style: TextStyle(color: Colors.blue)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: editCategory,
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          editCategory = newValue;
                          if (categorizedClothes.containsKey(editCategory)) {
                            originalItem =
                                categorizedClothes[editCategory!]?.first;
                          } else {
                            originalItem = null;
                          }
                        });
                      },
                      items: categorizedClothes.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: TextStyle(color: Colors.blue)),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      hint: Text('Select an item',
                          style: TextStyle(color: Colors.blue)),
                      value: originalItem,
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          originalItem = newValue;
                          _itemController.text = newValue ?? '';
                        });
                      },
                      items: (categorizedClothes[editCategory ?? ''] ?? [])
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: TextStyle(color: Colors.blue)),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: _itemController,
                      decoration: InputDecoration(hintText: 'New Item Name'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    if (editCategory != null &&
                        originalItem != null &&
                        _itemController.text.isNotEmpty) {
                      setState(() {
                        categorizedClothes[editCategory!]!
                            .remove(originalItem!);
                        categorizedClothes[editCategory!]!
                            .add(_itemController.text);
                        selectedClothes[editCategory!]!.remove(originalItem!);
                        selectedClothes[editCategory!]![_itemController.text] =
                            false;
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Show an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error',
                                style: TextStyle(color: Colors.red)),
                            content: Text('Please fill in all fields.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK',
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Clothing App 203082', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
      ),
      body: buildClothingList(),
      floatingActionButton: buildActionButtons(),
    );
  }

  ListView buildClothingList() {
    return ListView.builder(
      itemCount: categorizedClothes.keys.length,
      itemBuilder: (context, index) {
        String category = categorizedClothes.keys.elementAt(index);
        return ExpansionTile(
          title: Text(category),
          children: categorizedClothes[category]!
              .map((item) => CheckboxListTile(
                    title: Text(item),
                    value: selectedClothes[category]![item]!,
                    onChanged: (bool? newValue) {
                      setState(() {
                        selectedClothes[category]![item] = newValue!;
                      });
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  Row buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildActionButton(Icons.add, 'Add', _addClothing),
        _buildActionButton(Icons.remove, 'Remove', _removeClothing),
        _buildActionButton(Icons.edit, 'Edit', _editClothing),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.red),
      label: Text(label, style: TextStyle(color: Colors.red)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: Colors.green),
    );
  }
}
