import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_call/commen.dart';
import 'package:video_call/home_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              final GoogleSignInAccount? googleUser =
                  await GoogleSignIn().signIn();

              // Obtain the auth details from the request
              final GoogleSignInAuthentication? googleAuth =
                  await googleUser?.authentication;

              // Create a new credential
              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken,
              );

              // Once signed in, return the UserCredential
              await FirebaseAuth.instance.signInWithCredential(credential);

              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser?.uid.toString())
                  .set({
                "_uid": FirebaseAuth.instance.currentUser?.uid.toString(),
                "_uname": FirebaseAuth.instance.currentUser?.uid.toString()
              });

              ZegoUIKitPrebuiltCallInvitationService().init(
                appID: 409753841 /*input your AppID*/,
                appSign: '32c1e6dc70266e7e451d1891316dacae59935855e56ab98253cbd095786b1e85' /*input your AppSign*/,
                userID: FirebaseAuth.instance.currentUser!.uid.toString(),
                userName: FirebaseAuth.instance.currentUser!.uid.toString(),
                notificationConfig: ZegoCallInvitationNotificationConfig(
                  androidNotificationConfig: ZegoCallAndroidNotificationConfig(
                    showFullScreen: true,
                    fullScreenBackground: 'assets/image/call.png',
                    channelID: "videocall",
                    channelName: "Call Notifications",
                    sound: "call",
                    icon: "call",
                  ),
                  iOSNotificationConfig: ZegoCallIOSNotificationConfig(
                    systemCallingIconName: 'CallKitIcon',
                  ),
                ),
                requireConfig: (ZegoCallInvitationData data) {
                  final config = (data.invitees.length > 1)
                      ? ZegoCallType.videoCall == data.type
                      ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                      : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                      : ZegoCallType.videoCall == data.type
                      ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                      : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

                  config.avatarBuilder = customAvatarBuilder;

                  /// support minimizing, show minimizing button
                  config.topMenuBar.isVisible = true;
                  config.topMenuBar.buttons
                      .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
                  return config;
                },
                plugins: [ZegoUIKitSignalingPlugin()],
              );

              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ));
            },
            child: Text("google")),
      ),
    );
  }
}
