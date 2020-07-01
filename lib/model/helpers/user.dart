import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceryapp/model/models/user.dart';

class UserServices {
  String collection = "users";
  Firestore _firestore = Firestore.instance;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).document(id).setData(values);
  }

//
//  void likeOrDislikeProduct({String id, String userLikes}) {
//    _firestore.collection(collection).document(id).updateData({
//      "wishlist": FieldValue.arrayUnion([userLikes])
//    });
//  }
  void addTowishlist({String userId, Map wisitem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${wisitem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "wishlist": FieldValue.arrayUnion([wisitem])
    });
  }

  void removeFromwishlist({String userId, Map wisitem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${wisitem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "wishlist": FieldValue.arrayRemove([wisitem])
    });
  }

  void addToCart({String userId, Map cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayUnion([cartItem])
    });
  }

  void removeFromCart({String userId, Map cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayRemove([cartItem])
    });
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).document(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
