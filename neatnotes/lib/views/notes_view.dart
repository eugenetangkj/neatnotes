import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/enums/mynotes_menu_action.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key ? key}): super(key: key);

  @override
  State<NotesView> createState() =>  _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  
  @override
  void initState() {
    // _notesService = FirebaseCloudStorage();
    super.initState();
  }

  //Builds my notes title widget
  Widget buildMyNotesTitleWidget() {
    return const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(30, 40, 0, 0),
        child: Text(
          'My Notes',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 36,
          )
        ),
    );
  }


  //Builds pop up menu widget
  Widget buildPopupMenuWidget() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 30, 0),
        child: PopupMenuButton<MyNotesMenuAction>(
          icon: const Icon(
            Icons.more_vert,
            color: darkBlueColour,
            size: 48,
          ), onSelected: (value) async {
            switch (value) {
              case MyNotesMenuAction.deleteAll:
                //TODO: Delete all notes functionality
                print("Delete all notes");
                break;
              case MyNotesMenuAction.logout:
                //Ask user for confirmation
                final shouldLogOut = await showLogoutDialog(context);
                if (shouldLogOut) {
                  //User confirms that he wants to log out
                  context.read<AuthBloc>().add(const AuthEventLogout());
                }
                break;
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: MyNotesMenuAction.deleteAll,
                child: Text('Delete All Notes'),
              ),
              const PopupMenuItem(
                value: MyNotesMenuAction.logout,
                child: Text('Logout')),
            ];
          }
        ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBlueBackgroundColour,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //Top app bar
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //My notes title
                       buildMyNotesTitleWidget(),
                      
                      //Pup up menu
                      buildPopupMenuWidget(),

                    ],
                  ),
                ),

              ]
            ),
          ),
        ),
      );
  }
}
