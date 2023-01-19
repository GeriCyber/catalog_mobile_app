import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/modesl.dart';

class ItemsService extends ChangeNotifier {
  final String _baseURL = 'flutter-catalog-app-2e7e0-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Item> items = [];
  bool isLoading = true;
  Item? selectedItem;

  ItemsService() {
    loadItems();
  }

  Future loadItems() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseURL, 'items.json');
    final response = await http.get(url);
    final Map<String, dynamic> itemsMap = json.decode(response.body);
    itemsMap.forEach((key, value) {
      final tempItem = Item.fromMap(value);
      tempItem.id = key;
      items.add(tempItem);
    });

    isLoading = false;
    notifyListeners();
    return items;
  }
  
}