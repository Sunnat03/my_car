import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_car/pages/sign_up_page.dart';
// import 'package:my_car/services/auth_service.dart';
import 'package:my_car/services/db_service.dart';
import 'package:my_car/services/util_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static const id = "/sign_in_page";
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _signIn() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please fill all gaps", context);
      return;
    }

    isLoading = true;
    setState(() {});

    // AuthService.signInUser(context, email, password).then((user) => _checkUser(user));

  }

  void _checkUser(User? user) async {
    if(user != null) {
      debugPrint(user.toString());
      await DBService.saveUserId(user.uid);
      // if(mounted) Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireSnackBar("Please check your entered data, Please try again!", context);
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> _catchError() async{
    Utils.fireSnackBar("Something error in Service, Please try again later", context);
    isLoading = false;
    setState(() {});
  }

  void _goSignUp() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // #email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      focusColor: Colors.red,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      hintText: "Email",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20,),

                  // #password
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      focusColor: Colors.red,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      hintText: "Password",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20,),

                  // #sign_in
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                        minimumSize: const Size(double.infinity, 50)
                    ),
                    child: const Text("Sign In", style: TextStyle(fontSize: 16,color: Colors.red),),
                  ),
                  const SizedBox(height: 20,),

                  // #sign_up
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          const TextSpan(
                            text: "Don't have an account?  ",

                          ),
                          TextSpan(
                            style: const TextStyle(color: Colors.red),
                            text: "Sign Up",
                            recognizer: TapGestureRecognizer()..onTap = _goSignUp,
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ),
          ),

          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
/*Scaffold(
      backgroundColor: PrimaryColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/welcome.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 80.0,
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                              fontSize: 45,
                          ),
                          children: [
                            TextSpan(
                              text: 'Gentra\n'
                            ),
                            TextSpan(
                                text: 'Car Rental\n'
                            ),
                          ]
                        )
                    ),
                    SizedBox(height: 30,width: MediaQuery.of(context).size.width,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(2),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            style: TextStyle(
                              color: Colors.white
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.white
                              )
                            ),
                          ),
                          SizedBox(height: 16,),
                          TextField(
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.white
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                          )
                        );
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: bottonColor,
                        child: Image(
                          image: AssetImage('assets/icons/right-arrow.png'),
                          color: Colors.white,
                          height: 50,
                          width: 35,
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
          Positioned(
              bottom: padding,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    buildText('SignUp',17,Colors.white),
                    SizedBox(width: 20,),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: Colors.blueGrey[800],
                    ),
                    SizedBox(width: 20,),
                    buildText('Forgot Password',17,Colors.white),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  buildText(String text, double size, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
      fontSize: size,
    ),
    );*/