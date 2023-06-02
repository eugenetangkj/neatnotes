import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neatnotes/services/cloud/cloud_note_category.dart';
import 'package:neatnotes/services/cloud/cloud_storage_constants.dart';

//This class represents a note that is stored in the Firestore database
@immutable
class CloudNote {
  final String noteId;
  final String ownerUserId;
  final String title;
  final String content;
  final String dateTime;
  final CloudNoteCategory category;

  const CloudNote({
    required this.noteId,
    required this.ownerUserId,
    required this.title,
    required this.content,
    required this.dateTime, 
    required this.category});

  
  //Create isntances of cloud notes from a snapshot of the state of the cloud notes database
  CloudNote.fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    noteId = snapshot.id,
    ownerUserId = snapshot.data()[ownerUserIdFieldName],
    title = snapshot.data()[titleFieldName],
    content = snapshot.data()[contentFieldName],
    dateTime = snapshot.data()[dateTimeFieldName],
    category = snapshot.data()[categoryFieldName] == "School"
               ? CloudNoteCategory.school
               : snapshot.data()[categoryFieldName] == "Personal"
               ? CloudNoteCategory.personal
               : CloudNoteCategory.work;


}