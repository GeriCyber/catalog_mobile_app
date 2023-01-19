import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catalog_design/services/services.dart';
import 'package:catalog_design/ui/input_decoration.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsService = Provider.of<ItemsService>(context);
    return Scaffold(
      body: SingleChildScrollView(
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
                    onPressed: () {},
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
        child: const Icon(Icons.save_rounded),
        onPressed: (){},
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _formDecoration(),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecorationStyle.authInputDecoration(
                  hintText: 'Item name', 
                  labelText: 'Name:'
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorationStyle.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Price:'
                ),
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: true, 
                onChanged: ((value) {
                  
                })
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