import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/Category_products/categories.dart';
import 'package:groceryapp/Category_products/categoryproducts.dart';
import 'package:groceryapp/ScreenPages/MessagesScreen.dart';
import 'package:groceryapp/ScreenPages/ProfileScreen.dart';
import 'package:groceryapp/ScreenPages/SearchResult.dart';
import 'package:groceryapp/ScreenPages/Settings.dart';
import 'package:groceryapp/ScreenPages/orders.dart';
import 'package:groceryapp/ScreenPages/wishList.dart';
import 'package:groceryapp/model/helpers/screen_navigation.dart';
import 'package:groceryapp/model/providers/product.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:groceryapp/product_detail_page/gredients.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import 'package:imagebutton/imagebutton.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'CartScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool loading = false;

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xff27BED1),
      title: _search(),
    );
  }

  Future signout() async {
    firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  void changeScreenReplacement(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  Widget _search() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search()));
      },
      child: Container(
        // margin: AppTheme.padding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  //color: Colors.white,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xffE1E2E4).withAlpha(100),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    height: 60,
                    width: 300,
                    child: Card(
                        //color: Color(0xff27BED1),
                        child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )),
                  )),
            ),
            SizedBox(width: 20),
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                }),
          ],
        ),
      ),
    );
  }

  Container imageCarousel() {
    return Container(
      // color: Colors.blue,
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        borderRadius: true,
        radius: Radius.circular(20),
        images: [
          AssetImage('images/image2.jpg'),
          //  AssetImage('images/c1.jpg'),
          AssetImage('images/image1.jpg'),
          AssetImage('images/image2.jpg'),
        ],
        autoplay: false,
//        animationCurve: Curves.fastOutSlowIn,
//        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
  }

  Widget category(productProvider) {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InkWell(
            onTap: () async {
              setState(() {
                loading = true;
              });
              await productProvider.loadProductsByCategory(
                  categoryName: "Vegetable");

              changeScreen(
                  context,
                  CategoryProductList(
                    //product: productProvider.productsByCategory,
                    title: "Vegetables",
                  ));
              setState(() {
                loading = false;
              });
            },
            child: CategoryWidget(
              title: 'Vegetables',
              assetimgae: "images/grocery/veg.png",
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() {
                loading = true;
              });
              await productProvider.loadProductsByCategory(
                  categoryName: "Meat");

              changeScreen(
                  context,
                  CategoryProductList(
                    //product: productProvider.productsByCategory,
                    title: "Meat",
                  ));
              setState(() {
                loading = false;
              });
            },
            child: CategoryWidget(
              title: 'Meat & Fish',
              assetimgae: "images/grocery/meat.png",
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() {
                loading = true;
              });
              await productProvider.loadProductsByCategory(categoryName: "Oil");

              changeScreen(
                  context,
                  CategoryProductList(
                    //product: productProvider.productsByCategory,
                    title: "Oil",
                  ));
              setState(() {
                loading = false;
              });
            },
            child: CategoryWidget(
              title: 'Oil',
              assetimgae: "images/grocery/oil.png",
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() {
                loading = true;
              });
              await productProvider.loadProductsByCategory(
                  categoryName: "Dairy");

              changeScreen(
                  context,
                  CategoryProductList(
                    //product: productProvider.productsByCategory,
                    title: "Dairy & Eggs",
                  ));
              setState(() {
                loading = false;
              });
            },
            child: CategoryWidget(
              title: 'Dairy & Eggs',
              assetimgae: "images/grocery/dairy.png",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: appBar(),
        drawer: Drawer(
          //  semanticLabel: "wwww",
          child: new ListView(
            children: <Widget>[
//            header
              new UserAccountsDrawerHeader(
                accountName: Text(
                    "${user.userModel.name == null ? "Name" : user.userModel.name}"),
                accountEmail: Text(
                    '${user.userModel.email == null ? "email" : user.userModel.email}'),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: NetworkImage(user.userModel.image == null
                        ? "https://firebasestorage.googleapis.com/v0/b/groceryapp-8164c.appspot.com/o/post_f8d3d859-181f-4c83-a9bc-d8c712690344.jpg?alt=media&token=efd779b1-e3eb-4e2f-9278-410c1d6a9a93"
                        : user.userModel.image),
                    backgroundColor: Colors.grey,
                  ),
                ),
                decoration: new BoxDecoration(gradient: btnGradient),
              ),

//            body

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: ListTile(
                  title: Text('My account'),
                  leading: Icon(Icons.person),
                ),
              ),

              InkWell(
                onTap: () {
                  user.getOrders();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersScreen(
                                userID: user.userModel.id,
                              )));
                },
                child: ListTile(
                  title: Text('My Orders'),
                  leading: Icon(Icons.shopping_basket),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Categories()));
                },
                child: ListTile(
                  title: Text('Categoris'),
                  leading: Icon(Icons.dashboard),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wishlist()));
                },
                child: ListTile(
                  title: Text('Favourites'),
                  leading: Icon(Icons.favorite),
                ),
              ),

              Divider(),

              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                child: ListTile(
                  title: Text('Settings'),
                  leading: Icon(
                    Icons.settings,
                    color: Colors.blue,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  user.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: ListTile(
                  title: Text('LogOut'),
                  leading: Icon(Icons.power_settings_new, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        body: loading
            ? Loading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
//                GestureDetector(
//                    child: Text(
//                      'abc',
//                      style: TextStyle(fontSize: 30),
//                    ),
//                    onTap: () {
//                      print(productProvider.products.length);
//                    }),
                  Padding(padding: EdgeInsets.all(10), child: imageCarousel()),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Categories",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  category(productProvider),

                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Featured Products",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Flexible(child: ProductsList()),
                ],
              ));
  }
}

class CategoryWidget extends StatelessWidget {
  final String title;
  final String assetimgae;
  CategoryWidget({this.title, this.assetimgae});
  @override
  Widget build(BuildContext context) {
    //final users = Provider.of<User>(context);
    return Container(
      width: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // color: Colors.pink,
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('$title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w700,
                      fontSize: 10)),
            ),
            Flexible(
              //flex: 5,
              child: Image.asset(
                "$assetimgae",
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}
