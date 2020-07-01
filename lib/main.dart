import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceryapp/Category_products/categories.dart';
import 'package:groceryapp/ScreenPages/CartScreen.dart';
import 'package:groceryapp/ScreenPages/ProfileEdit.dart';
import 'package:groceryapp/ScreenPages/Settings.dart';
import 'package:groceryapp/ScreenPages/checkoutscreen.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/home.dart';
//import 'package:groceryapp/models/provider_user.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import 'package:provider/provider.dart';
import 'ScreenPages/Splash.dart';
import 'model/providers/product.dart';
import 'ScreenPages/welcomePage.dart';
import 'package:groceryapp/product_detail_page/Home_of_page_detail.dart';
import 'package:groceryapp/model/providers/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserProvider.initialize()),
          ChangeNotifierProvider.value(value: ProductProvider.initialize()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
              bodyText2: GoogleFonts.montserrat(textStyle: textTheme.bodyText2),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ));
  }
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginPage();
      case Status.Authenticated:
        return Home();
      default:
        return LoginPage();
    }
  }
}
