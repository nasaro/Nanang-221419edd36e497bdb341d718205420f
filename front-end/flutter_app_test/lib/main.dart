import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'InfoUserClass.dart';
import 'EndPoints.dart';
import 'mainmenu.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Log In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'test'),
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
  final GlobalKey<ScaffoldState> _scaffoldKeyMainMenu = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscureText = true;
  bool loginStatus;
  bool bLogStatus;
  String roleStatus="";


  @override
  void initState() {
    super.initState();
  }


  Future<void> _callLoginAPI(String _par1, String _par2) async {
    var url = "http://localhost/login/";
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    String _uid = _par1;
    String _pass = _par2;
    var nbody = json.encode({"username": _uid, "password": _pass});

    final response = await http.post(Uri.parse(url) , body: nbody, headers: headers);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      if (responseJson != null) {
        InfoLogin.userid = responseJson["username"].toString();
        InfoLogin.login_state = responseJson["login_state"].toString();
        InfoLogin.login_time = DateTime.parse(responseJson["login_time"]).millisecondsSinceEpoch;
        InfoLogin.Status = true;
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setBool('login', true);
          prefs.setString('uid', InfoLogin.userid);
          prefs.setString('login_state', InfoLogin.login_state);
          prefs.setInt('login_time', InfoLogin.login_time);
        });


      } else {
        toastToForm("User tidak dikenali");

      }
    } else {
      toastToForm("User belum terdaftar di system");
      throw Exception('Failed to Login');
    }
  }



  Future<bool> getLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('login') ?? false;
    roleStatus = prefs.getString('login_state') ?? '';
    if (loginStatus){
      InfoLogin.Status = true;
      InfoLogin.userid = prefs.get('uid');
      InfoLogin.login_time = prefs.get('login_time');
      InfoLogin.role = prefs.get('login_state');
      InfoLogin.login_state = prefs.get('login_state');
    }
    return loginStatus;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: FutureBuilder<bool>(
            future:  getLoginStatus(),
            builder: (context, snapshot) {
              if (roleStatus == '4'){
                return  (snapshot.data) ? LandingPage() : scaffWidget();
              } else {
                return scaffWidget();
              }
            }
        ),
      ),
    );
  }

  Widget scaffWidget() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(65, 148, 134, 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height : 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(243, 245, 248, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(18))
                              ),
                              //child: Image.asset("assets/logo.png", fit: BoxFit.contain,),
                              padding: EdgeInsets.all(12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height : 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text("PT. TEST", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18,color: Colors.white),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //draggable sheet
            DraggableScrollableSheet(
              builder: (context, scrollController){
                return Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 245, 248, 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 24,),

                        Container(
                          margin: new EdgeInsets.all(20.0),
                          child: Center(
                            child: Form(
                              key: _formKey,
                              child: _getFormUI(),
                            ),
                          ),
                        ),

                      ],
                    ),
                    controller: scrollController,
                  ),
                );
              },
              initialChildSize: 0.65,
              minChildSize: 0.65,
              maxChildSize: 1,
            )
          ],
        ),
      ),


      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.fingerprint,  color: Colors.white),
              tooltip: 'TEST',
            ),
            Text("TEST", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12,color: Colors.white),),
          ],
        ),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: Colors.pink[800],
          onPressed: () {
            if (_formKey.currentState.validate()) {
              String usercall = _username.text;
              String passcall = _password.text;
              _callLoginAPI(usercall, passcall);


            }
          },
          child: Icon(Icons.vpn_key),
        ),
      ),

    );
  }
//TextFormField
  Widget _getFormUI() {
    return new Column(
      children: <Widget>[
        new SizedBox(height: 20.0),
        new TextFormField(
          controller: _username,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'User',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Masukan User ID ';
            }
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
          controller: _password,
          autofocus: false,
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                semanticLabel:
                _obscureText ? 'show password' : 'hide password',
              ),
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Masukkan Passwordnya';
            }
          },
        ),

      ],
    );
  }

}

