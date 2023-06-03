
import 'package:flutter/material.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/services/cloud/cloud_note.dart';

//A function that takes in a cloudnote
typedef NoteCallBack = void Function(CloudNote note);



class NotesListView extends StatelessWidget {
  //All the notes retrieved from backend that are to be displayed in the list view
  final Iterable<CloudNote> notes;
  final NoteCallBack onTap;

  const NotesListView({super.key, required this.notes, required this.onTap});


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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
          //Number of items to render
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes.elementAt(index);
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () => onTap(note),

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
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
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
                  note.dateTime,
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
            );
          }
        ),
    );
  }
}

