import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundbutton.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      // upperBound: 100,
    );
    animation = ColorTween(begin: Colors.blueGrey , end: Colors.white).animate(controller);
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    // controller.reverse(from: 1.0);
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed)
    //     {
    //       controller.reverse(from: 1.0);
    //     }
    //   else if(status == AnimationStatus.dismissed)
    //     {
    //       controller.forward();
    //     }
    // });
    controller.addListener(() {
      setState(() {});
      // print(animation.value);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  // Padding button (Color colour , String txt , String route)
  // {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 16.0),
  //     child: Material(
  //       elevation: 5.0,
  //       color: colour,
  //       borderRadius: BorderRadius.circular(30.0),
  //       child: MaterialButton(
  //         onPressed: () {
  //           //Go to login screen.
  //           Navigator.pushNamed(context, route);
  //         },
  //         minWidth: 200.0,
  //         height: 42.0,
  //         child: Text(
  //           txt,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value * 60,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    // pause: Duration(seconds: 4),
                    animatedTexts: [
                      TypewriterAnimatedText('Flash Chat'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            // button(Colors.lightBlueAccent, 'Log In',LoginScreen.id),
            // button(Colors.blueAccent, 'Register',RegistrationScreen.id),
            Roundbutton(colour: Colors.lightBlueAccent,txt: 'Log In',onpressed: ()
              {
                Navigator.pushNamed(context,LoginScreen.id);
              },),
            Roundbutton(colour: Colors.blueAccent,txt: 'Register',onpressed: ()
            {
              Navigator.pushNamed(context,RegistrationScreen.id);
            },),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 16.0),
            //   child: Material(
            //     color: Colors.blueAccent,
            //     borderRadius: BorderRadius.circular(30.0),
            //     elevation: 5.0,
            //     child: MaterialButton(
            //       onPressed: () {
            //         //Go to registration screen.
            //         Navigator.pushNamed(context, RegistrationScreen.id);
            //       },
            //       minWidth: 200.0,
            //       height: 42.0,
            //       child: Text(
            //         'Register',
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
