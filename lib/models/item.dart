import 'dart:convert';
class Item {
    Item({
        required this.available,
        this.image,
        required this.name,
        required this.price,
        this.id,
    });

    bool available;
    String? image;
    String name;
    double price;
    String? id;

    Map<String, Item> itemFromMap(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Item>(k, Item.fromMap(v)));

    String itemToMap(Map<String, Item> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())));

    factory Item.fromMap(Map<String, dynamic> json) => Item(
        available: json["available"],
        image: json["image"],
        name: json["name"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "available": available,
        "image": image,
        "name": name,
        "price": price,
    };

    Item copy() => Item(
      available: available,
      name: name,
      image: image,
      price: price,
      id: id
    );
}
