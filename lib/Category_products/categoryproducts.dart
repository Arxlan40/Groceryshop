import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/ScreenPages/product_detail.dart';
import 'package:groceryapp/model/models/products.dart';
import 'package:groceryapp/model/providers/product.dart';
import 'package:groceryapp/product_detail_page/Home_of_page_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CategoryProductList extends StatelessWidget {
  //final List product;

  final String title;
  CategoryProductList({this.title, });
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${title.toString()}"),
        backgroundColor: Color(0xff4dd0e1),
      ),
      body: GridView.builder(
          shrinkWrap: true,
          itemCount: productProvider.productsByCategory.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
//                  for (int i = 0;
//                      i <
//                          snapshot
//                              .data.documents[index].data['imageUrl'].length;
//                      i++) {
//                    _listOfImages.add(NetworkImage(
//                        snapshot.data.documents[index].data['imageUrl'][0]));
//                  }
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              //shadowColor: Colors.blue,
              child: InkWell(
                onTap: () {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                product:
                                    productProvider.productsByCategory[index],
                              )));
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Image.network(
                          productProvider.productsByCategory[index].image ??
                              "id null",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        productProvider.productsByCategory[index].name ??
                            "id null",

                        //textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            " Price:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${productProvider.productsByCategory[index].price.toString()}\$",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
