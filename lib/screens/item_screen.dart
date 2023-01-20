import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catalog_design/services/services.dart';
import 'package:catalog_design/ui/input_decoration.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/item_form_provider.dart';
import '../widgets/widgets.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsService = Provider.of<ItemsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ItemFormProvider(itemsService.selectedItem!),
      child: _ItemBodyScreen(itemsService: itemsService),
    );
  }
}

class _ItemBodyScreen extends StatelessWidget {
  const _ItemBodyScreen({
    Key? key,
    required this.itemsService,
  }) : super(key: key);

  final ItemsService itemsService;

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ItemImage(imageURL: itemsService.selectedItem?.image),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white)
                    )
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile ? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100
                      );
                      if(pickedFile == null) {
                        print('Nothing selected');
                        return;
                      }
                      print(pickedFile.path);
                      itemsService.updateSelectedProductImage(pickedFile.path);
                    },
                    icon: const Icon(Icons.camera_alt_rounded, size: 40, color: Colors.white)
                    )
                ),
              ],
            ),
            const _ItemFormData(),
            const SizedBox(height: 100)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: itemsService.isSaving ? null : () async {
          if(!itemForm.isValidForm()) {
            return;
          }
          final String? imageURL = await itemsService.uploadImage();
          if(imageURL != null) {
            itemForm.item.image = imageURL;
          }
          await itemsService.saveItem(itemForm.item);
        },
        child: itemsService.isSaving ? 
        const CircularProgressIndicator(color: Colors.white) : 
        const Icon(Icons.save_rounded),
      ),
    );
  }
}

class _ItemFormData extends StatelessWidget {
  const _ItemFormData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemFormProvider>(context);
    final item = itemProvider.item;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _formDecoration(),
        child: Form(
          key: itemProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: item.name,
                onChanged: (value) => item.name = value,
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                decoration: InputDecorationStyle.authInputDecoration(
                  hintText: 'Item name', 
                  labelText: 'Name:'
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${item.price}',
                onChanged: (value) {
                  item.price = double.tryParse(value) == null ? 0 : double.parse(value);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorationStyle.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Price:'
                ),
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                title: const Text('Available'),
                value: item.available, 
                onChanged: itemProvider.changeStatus
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _formDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0,5),
          blurRadius: 5
        )
      ]
    );
  }
}