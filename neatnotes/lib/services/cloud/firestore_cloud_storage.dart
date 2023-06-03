import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:neatnotes/services/cloud/cloud_note.dart';
import 'package:neatnotes/services/cloud/cloud_note_category.dart';
import 'package:neatnotes/services/cloud/cloud_storage_constants.dart';
import 'package:neatnotes/services/cloud/cloud_storage_exceptions.dart';

//This class is responsible for communicating with the Firestore database
//that has the notes collection
class FirestoreCloudStorage {
  static final FirestoreCloudStorage _sharedStorage = FirestoreCloudStorage._sharedInstance();

  //Private constructor
  FirestoreCloudStorage._sharedInstance();

  //Factory constructor
  factory FirestoreCloudStorage () => _sharedStorage;

  //Grabs all notes from Firestore
  final allNotes = FirebaseFirestore.instance.collection("notes");

  //Creates a new note
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now());
    //Adds a new entry into the notes collection
    final document = await allNotes.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      contentFieldName: '',
      dateTimeFieldName: formattedDateTime,
      categoryFieldName: [],
    });
    //Get reference to the new note added into the notes collection
    final fetchedNote = await document.get();
    //Build a cloud note from the retrieved new note
    return CloudNote(
      noteId: fetchedNote.id,
      ownerUserId: ownerUserId,
      title: '',
      content: '',
      dateTime: formattedDateTime,
      categories: const [],
    );
  }

  //Returns the latest versions of the notes by listening to changes in the stream of cloud notes
  //through observation of the snapshots
  Stream<Iterable<CloudNote>> getLatestNotes({required String ownerUserId}) {
    final latestNotes = allNotes
      .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .snapshots()
      .map((event) => event.docs.map((doc) => CloudNote.fromSnapShot(doc)));
    return latestNotes;
  }

  //Updates an existing note using all fields
  Future<void> updateNote({
    required String noteId,
    required String updatedTitle,
    required String updatedContent,
    required String updatedDateTime,
    required List<String> updatedCategories}) async {
      try {
        //Try updating the note in the backend
        await allNotes.doc(noteId).update({
          titleFieldName: updatedTitle,
          contentFieldName: updatedContent,
          dateTimeFieldName: updatedDateTime,
          categoryFieldName: updatedCategories,
        });
      } catch (e) {
        throw CouldNotUpdateNoteException();
      }
  }

  //Updates an existing note's title
  Future<void> updateNoteTitle({required String noteId,required String updatedTitle,}) async {
    try {
      //Try updating the note in the backend
      await allNotes.doc(noteId).update({
        titleFieldName: updatedTitle,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Updates an existing note's content
  Future<void> updateNoteContent({required String noteId, required String updatedContent,}) async {
    try {
      //Try updating the note in the backend
      await allNotes.doc(noteId).update({
        contentFieldName: updatedContent,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Updates an existing note's categories
  Future<void> updateNoteCategories({required String noteId, required List<String> updatedCategories,}) async {
    try {
      //Try updating the note in the backend
      await allNotes.doc(noteId).update({
        categoryFieldName: updatedCategories,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Updates an existing note's datetime
  Future<void> updateNoteDateTime({required String noteId, required String updatedDateTime,}) async {
    try {
      //Try updating the note in the backend
      await allNotes.doc(noteId).update({
        dateTimeFieldName: updatedDateTime,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }



  //Deletes a note
  Future<void> deleteNote({required String noteId}) async {
    try {
      await allNotes.doc(noteId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

}