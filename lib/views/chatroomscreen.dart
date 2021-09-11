import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethod authmethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount:snapshot.data.documents.length,
            itemBuilder: (context,index) {
              return ChatRoomTile(
                snapshot.data.documents[index].data['chatroomId']
                    .toString().replaceAll('_', '')
                    .replaceAll(Constants.myName,''),
                  snapshot.data.documents[index].data['chatroomId']
              );
            }
        ) : Container();

      },
    );
  }

  @override
  void initState() {
    getUserInfo();


    super.initState();
  }
  getUserInfo() async{
    Constants.myName =  await Helperfunctions.getUserNameSharedPrefernce();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'CONNECTS',
          style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 30.0,
            fontFamily: 'QuiteMagical',
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              authmethod.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate(),
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.search),
            backgroundColor: Color(0xff145C9E),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));

        },
      ),

    );
  }
}

class ChatRoomTile extends StatelessWidget {

  final String username;
  final String chatRoomId;

  ChatRoomTile(this.username,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)

        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),

              ),
              child: Text('${username.substring(0,1).toUpperCase()}',
              style: mediumTextStyle(),),
            ),
            SizedBox(width: 8,),

            Text(username,style: mediumTextStyle(),),
          ],
        ),
      ),
    );
  }
}

