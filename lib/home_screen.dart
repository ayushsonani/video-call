import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if( snapshot.hasData){
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                        child: Text("${snapshot.data?.docs[index].data()['_uname'].toString()}")),
                    trailing: Wrap(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          child: ZegoSendCallInvitationButton(
                            iconSize: Size(35, 35),
                            isVideoCall: false,
                            resourceID: "video_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                            invitees: [
                              ZegoUIKitUser(
                                id: snapshot.data!.docs[index].data()['_uid'].toString(),
                                name: snapshot.data!.docs[index].data()['_uname'].toString(),
                              ),
                            ],
                          )
                          ,
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          child:  ZegoSendCallInvitationButton(
                            iconSize: Size(35, 35),
                            isVideoCall: true,
                            resourceID: "videocall", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                            invitees: [
                              ZegoUIKitUser(
                                id: snapshot.data!.docs[index].data()['_uid'].toString(),
                                name: snapshot.data!.docs[index].data()['_uname'].toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: snapshot.data!.docs.length);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
