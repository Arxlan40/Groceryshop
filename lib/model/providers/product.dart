import 'package:flutter/material.dart';
import 'package:groceryapp/model/helpers/user.dart';
import '../helpers/product.dart';
import '../models/products.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  ProductModel product;
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsByRestaurant = [];
  List<ProductModel> productsSearched = [];

  ProductProvider.initialize() {
    loadProducts();
  }

  loadProducts() async {
    products = await _productServices.getProducts();

    notifyListeners();
  }

  loadProduct(String Productid) async {
    product = await _productServices.getProduct(Productid);

    notifyListeners();
  }

  Future loadProductsByCategory({String categoryName}) async {
    productsByCategory =
        await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
  }

  Future loadProductsByRestaurant({int restaurantId}) async {
    productsByRestaurant =
        await _productServices.getProductsByRestaurant(id: restaurantId);
    notifyListeners();
  }

//  likeDislikeProduct({String userId, ProductModel product, bool liked}) async {
//    if (liked) {
//      if (product.userLikes.remove(userId)) {
//        UserServices()
//            .likeOrDislikeProduct(id: product.id, userLikes: product.userLikes);
//      } else {
//        print("THE USER WA NOT REMOVED");
//      }
//    } else {
//      product.userLikes.add(userId);
//      UserServices()
//          .likeOrDislikeProduct(id: product.id, userLikes: product.userLikes);
//    }
//  }

  Future search({String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");

    notifyListeners();
  }
}
