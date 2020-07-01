import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/home.dart';
import 'package:groceryapp/model/models/products.dart';
import 'package:groceryapp/model/providers/product.dart';
import 'package:groceryapp/product_detail_page/Home_of_page_detail.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  final prodref = Firestore.instance.collection('products');

  handleSearch(String query) {
    Future<QuerySnapshot> product = prodref
        .where("Product Name", isGreaterThanOrEqualTo: query.toUpperCase())
        .getDocuments();
    setState(() {
      searchResultsFuture = product;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Color(0xff27BED1),
      title: Expanded(
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xffE1E2E4).withAlpha(100),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Expanded(
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for a Product",
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  size: 28.0,
                ),
              ),
              onFieldSubmitted: handleSearch,
            ),
          ),
        ),
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Find Products",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        List<ProductResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          ProductModel productModel = ProductModel.fromSnapshot(doc);
          ProductResult searchResult = ProductResult(productModel);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class ProductResult extends StatelessWidget {
  final ProductModel productModel;

  ProductResult(this.productModel);

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);

    return Container(
      decoration: BoxDecoration(
          color: Color(0xff27BED1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              return Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            product: productModel,
                          )));
            },
            child: ListTile(
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(productModel.image),
              ),
              title: Text(
                "Product Name: ${productModel.name}",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Price: \$${productModel.price.toString()}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
