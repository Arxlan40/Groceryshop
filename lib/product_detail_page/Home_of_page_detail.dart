import 'package:flutter/material.dart';
import 'package:groceryapp/ScreenPages/checkoutscreen.dart';
import 'package:groceryapp/messages/loading.dart';
import 'package:groceryapp/model/models/products.dart';
import 'package:groceryapp/model/providers/app.dart';
import 'package:groceryapp/model/providers/product.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:provider/provider.dart';
import 'gredients.dart';
import 'header.dart';
import 'footer.dart';
import 'customIcon.dart';

class MyHomePage extends StatefulWidget {
  final ProductModel product;

  const MyHomePage({@required this.product});

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool islike = false;

  bool _loading = false;
  Padding favnprice(price, name, userid, productid, user) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 25.0, bottom: 12.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new IconButton(
                  onPressed: () async {
                    setState(() {
                      islike = true;
                    });
                    bool value =
                        await user.addToCwishlist(product: widget.product);
                    if (value) {
                      print("Item added to cart");
                      _key.currentState.showSnackBar(
                          SnackBar(content: Text("Added to wishlist!")));
                      user.reloadUserModel();
                      //   app.changeLoading();
                      return;
                    } else {
                      print("Item NOT added to cart");
                    }
                    print("lOADING SET TO FALSE");
                  },
                  icon: Icon(
                    islike ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ),
              new Text("Add to wishList")
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "\$",
                  style: new TextStyle(fontSize: 20.0),
                ),
              ),
              new Text(
                price.toString(),
                style: new TextStyle(fontSize: 35.0),
              )
            ],
          )
        ],
      ),
    );
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    //final app = Provider.of<AppProvider>(context);

    return new Scaffold(
        key: _key,
        body: _loading
            ? Loading()
            : new ListView(
                children: <Widget>[
                  new MHeader(
                    prod_detail_pricture: widget.product.image,
                    prod_detail_name: widget.product.name,
                  ),
                  favnprice(widget.product.price, user.userModel.name,
                      user.userModel.id, widget.product.id, user),
                  divider,
                  new Mfooter(
                    prod_detail_description: widget.product.description,
                  ),
                ],
              ),
        bottomNavigationBar: Container(
          height: 80,
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded(
                  child: new InkWell(
                    onTap: () async {
                      setState(() {
                        _loading = true;
                      });
                      await productProvider.loadProduct(widget.product.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                    productModel: productProvider.product,
                                  )));
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: new ClipRRect(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                      child: new Container(
                        decoration: new BoxDecoration(
                            gradient: btnGradient,
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                  blurRadius: 10.0,
                                  color: Colors.black12,
                                  offset: new Offset(0.0, 10.0))
                            ]),
                        height: 60.0,
                        child: new Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48.0),
                          child: new Center(
                            child: new Text(
                              "Buy Now",
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                        gradient: btnGradient,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                              blurRadius: 10.0,
                              color: Colors.black12,
                              offset: new Offset(0.0, 10.0))
                        ]),
                    child: new IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: () async {
//                          app.changeLoading();
                        print("All set loading");

                        bool value = await user.addToCard(
                            product: widget.product, quantity: 1);
                        if (value) {
                          print("Item added to cart");
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("Added ro Cart!")));
                          user.reloadUserModel();
                          //   app.changeLoading();
                          return;
                        } else {
                          print("Item NOT added to cart");
                        }
                        print("lOADING SET TO FALSE");
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
