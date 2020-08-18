import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/home.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/menu_two_item.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/login.dart';
import 'controller/signUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent,
        accentColor: Colors.blueAccent,
        hintColor: Colors.grey,
        backgroundColor: Colors.white,
        buttonColor: Colors.white,
        fontFamily: 'LobsterTwo',
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent
        )
      ),
      home: _handleAuth(),
    );
  }

  Widget _handleAuth(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        return (!snapshot.hasData)? MyHomePage():Home(snapshot.data.uid);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController _pageController;
  var currentPageValue=0.0;
  List<Widget> myPages=[Login(), SignUp()];

  Future _initPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!(preferences.getKeys().contains('countryParam'))) {
      await preferences.setString('countryParam', 'cmr');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController=PageController(initialPage: 0, keepPage: false,);

    _pageController.addListener((){
      setState(() {
        currentPageValue=_pageController.page;
      });
    });

    _initPreferences();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
            // ignore: missing_return
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: InkWell(
                onTap: (()=>hideKeyboard()),
                child: Container(
                  color: baseAccent,
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height >= 780.0) ? MediaQuery.of(context).size.height : 780.0,
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        PaddingWith(
                          widget: CircleAvatar(
                            backgroundColor: white,
                            radius: 100,
                            child: CircleAvatar(
                              backgroundColor: baseAccent,
                              radius: 95,
                              child: ClipOval(
                                child: Image.asset("assets/images/logo.jpg", fit: BoxFit.fill, width: 800, height: 800,),
                              ),
                            ),
                          ),
                          top: 30.0,
                        ),
                        PaddingWith(widget: Menu2Item(item1: "Se connecter", item2: "S'inscrire",pageController: _pageController,),top: 20.0, bottom: 20.0,),
                        Expanded(
                            flex: 3,
                            child: PageView.builder(
                              controller: _pageController,
                              itemBuilder: (BuildContext context, int position){
                                if(position==currentPageValue.floor()){
                                  return Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..setEntry(3, 2, 0.001)
                                    ..rotateX(currentPageValue-position)
                                    ..rotateY(currentPageValue-position)
                                    ..rotateZ(currentPageValue-position),
                                    child: (position%2==0)? myPages[0]:myPages[1],
                                  );
                                }
                                else if(position==currentPageValue.floor()+1){
                                  return Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..setEntry(3, 2, 0.001)
                                      ..rotateX(currentPageValue-position)
                                      ..rotateY(currentPageValue-position)
                                      ..rotateZ(currentPageValue-position),
                                    child: (position%2==0)? myPages[0]:myPages[1],
                                  );
                                }else{
                                  return (position%2==0)? myPages[0]:myPages[1];
                                }
                              },
                              itemCount: myPages.length,
                            ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        ),
    );
  }

  hideKeyboard(){
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
