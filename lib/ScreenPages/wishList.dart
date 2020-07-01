import 'package:flutter/material.dart';
import 'package:groceryapp/model/helpers/order.dart';
import 'package:groceryapp/model/providers/app.dart';
import 'package:groceryapp/model/providers/product.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:groceryapp/product_detail_page/Home_of_page_detail.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../src/Widget/customtext.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    //final app = Provider.of<AppProvider>(context);
    final productprovider = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: Color(0xff27BED1),
        elevation: 0.0,
        title: CustomText(text: "Favourites"),
      ),
      backgroundColor: white,
      body: _loading
          ? Loading()
          : ListView.builder(
              itemCount: user.userModel.wish.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff27BED1).withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            user.userModel.wish[index]["image"],
                            height: 120,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                _loading = true;
                              });

                              await productprovider.loadProduct(
                                  user.userModel.cart[index]["productId"]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                            product: productprovider.product,
                                          )));

                              setState(() {
                                _loading = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: user.userModel.wish[index]
                                                ["name"] +
                                            "\n",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            "\$${user.userModel.wish[index]["price"]} \n\n",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300)),
                                  ]),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: red,
                                    ),
                                    onPressed: () async {
                                      //app.changeLoading();
                                      bool value =
                                          await user.removeFromwishlist(
                                              wishitem:
                                                  user.userModel.wish[index]);
                                      if (value) {
                                        user.reloadUserModel();
                                        print("Item added to cart");
                                        _key.currentState.showSnackBar(SnackBar(
                                            content: Text(
                                                "Removed from wishlist!")));
                                        //app.changeLoading();
                                        return;
                                      } else {
                                        print("ITEM WAS NOT REMOVED");
                                        //app.changeLoading();
                                      }
                                    })
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
