import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/src/Widget/customtext.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:groceryapp/model/models/products.dart';
import 'package:uuid/uuid.dart';
import 'package:groceryapp/model/helpers/order.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductModel productModel;
  CheckoutScreen({this.productModel});
  @override
  _CheckoutScreenState createState() =>
      _CheckoutScreenState(productModel: productModel);
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  OrderServices _orderServices = OrderServices();

  final ProductModel productModel;
  _CheckoutScreenState({this.productModel});
  TextEditingController PormoController = TextEditingController();
  GlobalKey<FormState> _pormokey = GlobalKey();
  String payment = "Select Payment Method";
  void _pormocode() {
    var alert = new AlertDialog(
      content: Form(
        key: _pormokey,
        child: TextFormField(
          controller: PormoController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(color: Colors.black),
              ),
              hintText: "Add Pormo Code"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (PormoController.text != null) {
                //   _categoryService.createCategory(categoryController.text);
              }
              //  Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: Text('ADD')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  //String gender = 'male';

  String groupValue = "Cash On Delivery";
  valueChanged(e) {
    setState(() {
      if (e == "Cash On Delivery") {
        groupValue = e;
        payment = e;
        Navigator.pop(context);
      } else if (e == "Payment Via MasterCard") {
        groupValue = e;
        payment = e;
        Navigator.pop(context);
      }
    });
  }

  Widget buildbottomshett(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      height: 200,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Select Payment Method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text("Cash On Delivery"),
            trailing: Radio(
                value: "Cash On Delivery",
                groupValue: groupValue,
                onChanged: (e) => valueChanged(e)), //
          ),
          ListTile(
            title: Text("Payment Via Master Card"),
            trailing: Radio(
                value: "Payment Via MasterCard",
                groupValue: groupValue,
                onChanged: (e) => valueChanged(e)), //  Divider(),
            //
          )
        ],
      ),
    );
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    var cart = [
      {
        "image": productModel.image,
        "name": productModel.name,
        "price": productModel.price,
        "quantity": 1,
      }
    ];

    return Scaffold(
      key: _key,
      appBar: AppBar(
          backgroundColor: Color(0xff27BED1),
          title: Text(
            "Confirm Order",
            style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),
          )),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 155,
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text(user.userModel.name),
                            subtitle: Text(
                              "${user.userModel.address}, \n${user.userModel.city}, \n${user.userModel.country}, \n${user.userModel.zipcode}, \n${user.userModel.mobile}",
                              textAlign: TextAlign.left,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                print("chnage");
                              },
                              child: Text(
                                "CHANGE",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 60,
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.payment),
                        title: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context, builder: buildbottomshett);
                            },
                            child: Text(
                              payment,
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: 400.0,
                      maxWidth: 400.0,
                      minWidth: 400.0,
                      minHeight: 200.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text(
                          "Products",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (_, index) {
                            return ListTile(
                              leading: Image.network(
                                productModel.image,
                                scale: 5,
                              ),
                              title: Text(
                                productModel.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text("Price:${productModel.price}"),
                            );
                          }),

//                      Flexible(
//                        child: ListTile(
//                          leading: Image.network(
//                            user.userModel.image,
//                            scale: 10,
//                          ),
//                          title: Text(
//                            user.userModel.name,
//                            style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 16,
//                                fontWeight: FontWeight.w600),
//                          ),
//                          subtitle: Text("${user.userModel.country}"),
//                        ),
//                      ),
//                      Flexible(
//                        child: ListTile(
//                          leading: Image.network(
//                            user.userModel.image,
//                            scale: 10,
//                          ),
//                          title: Text(
//                            user.userModel.name,
//                            style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 16,
//                                fontWeight: FontWeight.w600),
//                          ),
//                          subtitle: Text("${user.userModel.country}"),
//                        ),
//                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 250,
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.swap_horiz),
                        title: Text(
                          "Order Summary",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Text('SubTotal:'),
                        trailing: Text(
                          "\$${productModel.price}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      ListTile(
                          leading: Text('Promo Code:'),
                          trailing: Text(
                            "Add Promo Code Here",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () {
                            _pormocode();
                          }),
                      ListTile(
                        leading: Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          "\$${productModel.price}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " \$${productModel.price}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.red),
                child: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0)), //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'You will be charged \$${productModel.price / 10} upon delivery!',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            var uuid = Uuid();
                                            String id = uuid.v4();
                                            _orderServices.createOrder(
                                              userId: user.user.uid,
                                              id: id,
                                              description:
                                                  "Some random description",
                                              status: "complete",
                                              totalPrice: productModel.price,
                                              cart: cart,
                                            );
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Order created!")));
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: const Color(0xFF1BC0C5),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: CustomText(
                      text: "Place Order",
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
