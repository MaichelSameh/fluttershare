import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'activity_feed.dart';
import 'profile.dart';
import 'search.dart';
import 'timeline.dart';
import 'upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isAuth = false;
  int _currentIndex = 0;
  PageController _pageController = new PageController();

  @override
  void initState() {
    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        googleSigninListener(account);
      },
      onError: (error) {
        onGoogleSigninError(error);
      },
    );
    //reauthenticate the user when app is reopened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      googleSigninListener(account);
    }, onError: (error) {
      onGoogleSigninError(error);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void googleSigninListener(GoogleSignInAccount? account) {
    if (account != null) {
      setState(
        () {
          isAuth = true;
        },
      );
    } else {
      setState(
        () {
          isAuth = true;
        },
      );
    }
  }

  void onGoogleSigninError(dynamic error) {
    print("HOME google signin error: $error");
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text("Something went wrong!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void signinWithGoogle() {
    googleSignIn.signIn();
  }

  void logout() {
    googleSignIn.signOut();
    setState(() {
      isAuth = false;
    });
  }

  void _onPageChange(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen(context) : buildUnauthScreen(context);
  }

  Scaffold buildAuthScreen(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 35,
          )),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onPageChange,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Scaffold buildUnauthScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Fluttershare",
              style: TextStyle(
                color: Colors.white,
                fontSize: 90,
                fontFamily: "Signatra",
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: signinWithGoogle,
              child: Image.asset(
                "assets/images/google_signin_button.png",
                height: 80,
                fit: BoxFit.fitHeight,
              ),
            )
          ],
        ),
      ),
    );
  }
}
