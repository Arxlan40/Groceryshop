import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:food_course/scr/models/cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const IMAGE = "profilePicture";
  static const CART = "cart";
  static const WISH = "wishlist";
  static const MOBILE = "mobile";
  static const ADDRESS = "address";
  static const ZIPCODE = "zipcode";
  static const COUNTRY = "country";
  static const CITY = "city";

  String _name;
  String _email;
  String _id;
  String _image;
  double _priceSum = 0;
  double _quantitySum = 0;
  String _address;
  String _mobile;
  String _zipcode;
  String _country;
  String _city;

//  getters
  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get image => _image;
  String get address => _address;
  String get mobile => _mobile;
  String get zipcode => _zipcode;
  String get country => _country;
  String get city => _city;
//  public variable
  List cart;
  List wish;
  double totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data[NAME];
    _email = snapshot.data[EMAIL];
    _id = snapshot.data[ID];
    _address = snapshot.data[ADDRESS];
    _zipcode = snapshot.data[ZIPCODE];
    _mobile = snapshot.data[MOBILE];
    _country = snapshot.data[COUNTRY];
    _city = snapshot.data[CITY];
    _image = snapshot.data[IMAGE];
    cart = snapshot.data[CART] ?? [];
    wish = snapshot.data[WISH] ?? [];
    totalCartPrice = snapshot.data[CART] == null
        ? 0
        : getTotalPrice(cart: snapshot.data[CART]);
  }

  double getTotalPrice({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceSum += cartItem["price"] * cartItem["quantity"];
    }

    double total = _priceSum;

    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");

    return total;
  }

// List<CartItemModel> _convertCartItems(List<Map> cart){
//    List<CartItemModel> convertedCart = [];
//    for(Map cartItem in cart){
//      convertedCart.add(CartItemModel.fromMap(cartItem));
//    }
//    return convertedCart;
//  }
}
