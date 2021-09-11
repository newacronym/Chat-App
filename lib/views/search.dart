import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/database.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;


  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            username: searchSnapshot.documents[index].data['name'],
            useremail: searchSnapshot.documents[index].data['email'],
          );
        }
    ) : Container();
  }


  initiateSearch() {
    databaseMethods.getUserByUserName(searchTextEditingController.text).then((
        val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String username}) {
   if(username != Constants.myName)
     {
       String chatRoomId = getChatRoomId(username, Constants.myName);

       List<String> users = [username, Constants.myName];
       Map<String, dynamic> chatRoomMap = {
         'users': users,
         'chatroomId': chatRoomId,
       };
       DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
       Navigator.push(context, MaterialPageRoute(
           builder: (context) => ConversationScreen(
             chatRoomId,
           )
       ));
     }
   else {
     print('no one found');
   }
  }

  Widget SearchTile({String username, String useremail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username, style: mediumTextStyle()),
              Text(useremail, style: mediumTextStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                  username: username
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text('Message', style: mediumTextStyle(),),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[600],
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'search username...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,

                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ]
                            ),
                            borderRadius: BorderRadius.circular(40.0)
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/search_white.png')),


                  )

                ],
              ),
            ),
            searchList()

          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
