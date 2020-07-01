import 'package:flutter/material.dart';
import 'package:groceryapp/model/models/order.dart';
import 'package:groceryapp/model/providers/app.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:groceryapp/model/helpers/order.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import '../src/Widget/customtext.dart';

class OrdersScreen extends StatefulWidget {
  final String userID;
  OrdersScreen({this.userID});
  @override
  _OrdersScreenState createState() => _OrdersScreenState(userID: userID);
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _loading = false;
  final String userID;
  _OrdersScreenState({this.userID});

  OrderServices _orderServices = OrderServices();

  getOrders(userid) async {
    setState(() {
      _loading = true;
    });
    print(userid);
    await _orderServices.getUserOrders(userId: userid);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getOrders(userID);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    //  final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: _loading
          ? Loading()
          : ListView.builder(
              itemCount: user.orders.length,
              itemBuilder: (_, index) {
                OrderModel _order = user.orders[index];
                return Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff27BED1).withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            child: Image.network(
                              _order.cart[0]['image'],
                              height: 120,
                              width: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: _order.cart[0]['name'] + "\n",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            "\$${_order.cart[0]['price']} \n\n",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300)),
                                    TextSpan(
                                        text: "Quantity: ",
                                        style: TextStyle(
                                            color: grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    TextSpan(
                                        text: _order.cart[0]['quantity']
                                            .toString(),
                                        style: TextStyle(
                                            color: primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ]),
                        ListTile(
                          leading: CustomText(
                            text: "\$${_order.total}",
                            weight: FontWeight.bold,
                          ),
                          title: Text(_order.description),
                          subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                                  _order.createdAt)
                              .toString()),
                          trailing: CustomText(
                            text: _order.status,
                            color: green,
                          ),
                        ),
                      ],
                    ));
              }),
    );
  }
}
