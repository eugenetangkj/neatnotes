
import 'package:flutter/material.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/services/cloud/cloud_note.dart';
import 'package:neatnotes/services/cloud/firestore_cloud_storage.dart';

//A function that takes in a cloudnote
typedef NoteCallBack = void Function(CloudNote note);



class NotesListView extends StatefulWidget {
  //All the notes retrieved from backend that are to be displayed in the list view
  final List<CloudNote> notes;
  final NoteCallBack onTap;

  const NotesListView({super.key, required this.notes, required this.onTap});

  @override
  NotesListViewState createState() {
    return NotesListViewState();
  }

}

class NotesListViewState extends State<NotesListView> {
  //Handle deletion of notes
  late final FirestoreCloudStorage _notesService;






  String generateCategoriesStrings(List categoriesList) {
    if (categoriesList.isEmpty) {
      return "";
    } else if (categoriesList.length == 1) {
      return categoriesList[0];
    } else if (categoriesList.length == 2) {
      return categoriesList[0] + ", " + categoriesList[1];
    } else  {
      return categoriesList[0] + ", " + categoriesList[1] + ", " + categoriesList[2];
    }
  }

  @override
  void initState() {
    _notesService = FirestoreCloudStorage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
          //Number of items to render
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            final note = widget.notes.elementAt(index);
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  //Run delete note function
                  _notesService.deleteNote(noteId: note.noteId);
                  //Update UI
                  setState(() {
                    (widget.notes).removeAt(index);
                  });
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 201, 85, 96),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 36,
                        ),
                    )),
                  
                  ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onTap: () => widget.onTap(note),
                              
                      //Note title
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          note.title,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      
                      //Note content and categories
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Note content
                            Text(
                              note.content,
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                              
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
                              child: Text(
                                generateCategoriesStrings(note.categories),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: darkBlueColour,
                                ),
                              ),
                            ),
                              
                              
                              
                              
                              
                              
                              
                          ],
                        ),
                      ),
                      //Note date
                      trailing: Text(
                        note.dateTime.substring(0, 16),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: darkBlueColour,
                        ),
                      ),
                    ),
                ),
              ),
            );
          }
        ),
    );
  }




}

