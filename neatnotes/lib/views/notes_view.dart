import 'package:flutter/material.dart';
import 'package:neatnotes/constants/colors.dart';

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
    return const Align(
      alignment: AlignmentDirectional(-1, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(30, 40, 0, 0),
        child: Text(
          'My Notes',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 36,
          )
        ),
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
                buildMyNotesTitleWidget()
              ]
            ),
          ),
        ),
      );
  }
}
