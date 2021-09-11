import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:chat_app/views/loading.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp({this.toggle});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  AuthMethod authmethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp() {
    if(formkey.currentState.validate()){

      Map<String,String> userInfoMap = {
        'name' : userNameTextEditingController.text,
        'email' : emailTextEditingController.text
      };
      Helperfunctions.saveUserEmailSharedPrefernce(emailTextEditingController.text);
      Helperfunctions.saveUserNameSharedPrefernce(userNameTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authmethod.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){


        databaseMethods.uploadUserInfo(userInfoMap);
        Helperfunctions.saveUserLoggedInSharedPrefernce(true);
        //print('${val.uid}');
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
        ));
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
        body: isLoading ? Loading()
            :SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          return val.isNotEmpty ? null :'username daal BKL';
                        },
                        controller: userNameTextEditingController,
                        decoration: textFieldInputDecoration('username'),
                        style: simpleTextStyle(),

                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "sahi email daal laudu";
                        },
                        controller: emailTextEditingController,
                        decoration: textFieldInputDecoration('email'),
                        style: simpleTextStyle(),

                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) => val.length > 5 ? null : 'password length must be greater than 5',
                        controller: passwordTextEditingController,
                        decoration: textFieldInputDecoration('password'),
                        style: simpleTextStyle(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(

                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: Text(
                      'Forgot Password?',
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    signMeUp();

                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16.0,),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC),
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30),

                    ),
                    child: Text('Sign Up', style: mediumTextStyle()),
                  ),
                ),
                SizedBox(height: 16.0 ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),

                  ),
                  child: Text('Sign Up with Google', style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                  ),
                ),
                SizedBox(height:16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("Already have account? ",style:mediumTextStyle() ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Sign In now',style:TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                    )],),
                SizedBox(height: 100.0,),

              ],
            ),
          ),
        )
    );
  }
}
