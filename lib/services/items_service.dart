import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/modesl.dart';

class ItemsService extends ChangeNotifier {
  final String _baseURL = 'flutter-catalog-app-2e7e0-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Item> items = [];
  bool isLoading = true;
  bool isSaving = false;
  Item? selectedItem;
  File? newImageFile;
  final storage = FlutterSecureStorage();

  ItemsService() {
    loadItems();
  }

  Future loadItems() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseURL, 'items.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
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

  Future saveItem(Item item) async {
    isSaving = true;
    notifyListeners();

    if(item.id == null) {
      await createItem(item);
    } else {
      await updateItem(item);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateItem(Item item) async {
    final url = Uri.https(_baseURL, 'items/${item.id}.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });

    final response = await http.put(url, body: json.encode(item.toMap()));
    final decodedData = response.body;
    final index = items.indexWhere((element) => element.id == item.id);
    items[index] = item;

    return item.id!;
  }
  
  Future<String> createItem(Item item) async {
    final url = Uri.https(_baseURL, 'items.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });

    final response = await http.post(url, body: json.encode(item.toMap()));
    final decodedData = json.decode(response.body);
    item.id = decodedData['name'];
    items.add(item);

    return item.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedItem?.image = path;
    newImageFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if(newImageFile == null) {
      return null;
    }

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dffifouti/image/upload?upload_preset=ejaeetwt');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newImageFile!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if(response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }

    newImageFile = null;
    final decodedData = json.decode(response.body);
    return decodedData['secure_url'];
  }
  
}