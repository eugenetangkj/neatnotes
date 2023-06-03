import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/constants/routes.dart';
import 'package:neatnotes/enums/mynotes_menu_action.dart';
import 'package:neatnotes/services/auth/auth_service.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/cloud/cloud_note.dart';
import 'package:neatnotes/services/cloud/firestore_cloud_storage.dart';
import 'package:neatnotes/utilities/dialogs/logout_dialog.dart';
import 'package:neatnotes/views/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key ? key}): super(key: key);

  @override
  State<NotesView> createState() =>  _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  //To manage notes from backend
  late final FirestoreCloudStorage _notesService;
  //To easily retrieve user id
  String get getUserId => AuthService.createFromFirebase().getCurrentUser!.id;
  
  @override
  void initState() {
    _notesService = FirestoreCloudStorage();
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
        padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 30, 0),
        child: PopupMenuButton<MyNotesMenuAction>(
          icon: const Icon(
            Icons.more_vert,
            color: darkBlueColour,
            size: 36,
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


  //Builds floating action button
  Widget buildFloatingActionButon() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        backgroundColor: darkBlueColour,
        onPressed: () {
          //Navigate to add note view
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        },
        child: const Icon(
          Icons.add,
          size: 36,
          
          ),
      ),
    );
  }

  //Builds stream that awaits for notes in the database
  Widget buildStreamOfNotes() {
    return StreamBuilder(
      stream: _notesService.getLatestNotes(ownerUserId: getUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            //Implicit fall through
          case ConnectionState.active:
            //No longer empty stream. Waiting for new updates
            if (snapshot.hasData) {
              final allNotes = snapshot.data as Iterable<CloudNote>;
              List<CloudNote> output = sortNotes(allNotes);

              //Generates the list of notes
              return NotesListView(
                notes: output,
                onTap: (note) {
                  //Navigate to edit a specific note
                  Navigator.of(context).pushNamed(
                    createOrUpdateNoteRoute,
                    arguments: note,
                  );
                },
              );
            } else {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        Text("Please hold on"),
                      ],
                    ),
                  ),
                );
        
            }
          default:
            return Scaffold(
              backgroundColor: lightBlueBackgroundColour,
              body: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text("Please hold on"),
                  ],
                ),
              )
            );
        }
      }
    );

  }

  //Sorts the list of notes
  List<CloudNote> sortNotes(Iterable<CloudNote> allNotes) {
    List<CloudNote> output = allNotes.toList();
    output.sort((a, b) {
      String firstDateTimeString = a.dateTime;
      String secondDateTimeString = b.dateTime;

      DateTime firstDateTime = DateTime.utc(
        int.parse(firstDateTimeString.substring(0, 4)),
        int.parse(firstDateTimeString.substring(5, 7)),
        int.parse(firstDateTimeString.substring(8, 10)),
        int.parse(firstDateTimeString.substring(11, 13)),
        int.parse(firstDateTimeString.substring(14,)),
      );

      DateTime secondDateTime = DateTime.utc(
        int.parse(secondDateTimeString.substring(0, 4)),
        int.parse(secondDateTimeString.substring(5, 7)),
        int.parse(secondDateTimeString.substring(8, 10)),
        int.parse(secondDateTimeString.substring(11, 13)),
        int.parse(secondDateTimeString.substring(14,)),
      );


      return firstDateTime.compareTo(secondDateTime);
    });

    return output.reversed.toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBlueBackgroundColour,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: buildFloatingActionButon(),
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

                buildStreamOfNotes(),

              ]
            ),
          ),
        ),
      );
  }
}
