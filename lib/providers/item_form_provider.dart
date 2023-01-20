import 'package:flutter/material.dart';

import '../models/modesl.dart';

class ItemFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Item item;

  ItemFormProvider(this.item);

  changeStatus(bool value) {
    item.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(item.name);
    print(item.price);
    print(item.available);
    return formKey.currentState?.validate() ?? false;
  }
}