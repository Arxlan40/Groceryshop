import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/model/helpers/screen_navigation.dart';
import 'package:groceryapp/model/providers/product.dart';
import 'package:provider/provider.dart';

import 'categoryproducts.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(fontFamily: "OpenSans"),
        ),
        backgroundColor: Color(0xff4dd0e1),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  await productProvider.loadProductsByCategory(
                      categoryName: "Vegetable");
                  changeScreen(
                      context,
                      CategoryProductList(
                        //product: productProvider.productsByCategory,
                        title: "Vegetables",
                      ));
                },
                child: CategoryWidget(
                  title: 'Vegetables',
                  assetimgae: "images/grocery/veg.png",
                ),
              ),
              InkWell(
                onTap: () async {
                  await productProvider.loadProductsByCategory(
                      categoryName: "Meat");
                  changeScreen(
                      context,
                      CategoryProductList(
                        // product: productProvider.productsByCategory,
                        title: "Meat",
                      ));
                },
                child: CategoryWidget(
                  title: 'Meat & Fish',
                  assetimgae: "images/grocery/meat.png",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  await productProvider.loadProductsByCategory(
                      categoryName: "Oil");
                  changeScreen(
                      context,
                      CategoryProductList(
                        //product: productProvider.productsByCategory,
                        title: "Oil",
                      ));
                },
                child: CategoryWidget(
                  title: 'Oil',
                  assetimgae: "images/grocery/oil.png",
                ),
              ),
              InkWell(
                onTap: () async {
                  await productProvider.loadProductsByCategory(
                      categoryName: "Dairy");
                  changeScreen(
                      context,
                      CategoryProductList(
                        //product: productProvider.productsByCategory,
                        title: "Dairy & Eggs",
                      ));
                },
                child: CategoryWidget(
                  title: 'Dairy & Eggs',
                  assetimgae: "images/grocery/dairy.png",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String title;
  final String assetimgae;
  CategoryWidget({this.title, this.assetimgae});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 120,
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
              child: Image.asset(
                "$assetimgae",
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
