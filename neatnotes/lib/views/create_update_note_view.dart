import 'package:flutter/material.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/enums/notesview_menu_action.dart';
import 'package:neatnotes/extensions/context_get_arguments.dart';
import 'package:neatnotes/helpers/loading/loading_screen.dart';
import 'package:neatnotes/services/auth/auth_service.dart';
import 'package:neatnotes/services/cloud/cloud_note.dart';
import 'package:neatnotes/services/cloud/firestore_cloud_storage.dart';
import 'package:neatnotes/services/pdf/pdf_api.dart';
import 'package:neatnotes/services/pdf/pdf_note.dart';
import 'package:neatnotes/utilities/dialogs/delete_single_note_dialog.dart';
import 'package:neatnotes/utilities/dialogs/error_dialog.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({ Key ? key}): super(key: key);

  @override
  State<CreateUpdateNoteView> createState() =>  _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {

  //Current note that is created
  CloudNote? _note;

  //Controllers for text fields
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  //Checkbox values
  late bool shouldCheckPersonal;
  late bool shouldCheckSchool;
  late bool shouldCheckWork;

  //Storage to handle the backend
  late final FirestoreCloudStorage _notesService;

  //Store initial values to determine if note has changed
  late final String originalTitle;
  late final String originalContent;
  late final List<dynamic> originalCategories;
  late final String originalDateTime;



  @override
  void initState() {
    _notesService = FirestoreCloudStorage();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }


  
  //A listener that listens to changes in note title
  void _titleControllerListener() async {
    //Listens to changes in the title and updates database whenever changes are made
    final note = _note;
    if (note == null) {
      return;
    }
    final title = _titleController.text;
    await _notesService.updateNoteTitle(noteId: note.noteId, updatedTitle: title);
  }

  //A listener that listens to changes in note content
  void _contentControllerListener() async {
    //Listens to changes in the content and updates database whenever changes are made
    final note = _note;
    if (note == null) {
      return;
    }
    final content = _contentController.text;
    await _notesService.updateNoteContent(noteId: note.noteId, updatedContent: content);
  }

  //Add listener to title controller
  void _setUpTitleControllerListener() {
    //Whenever the title controller's text changes, it runs the _titleControllerListener function
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  //Add listener to content controller
  void _setUpContentControllerListener() {
    //Whenever the content controller's text changes, it runs the _contentControllerListener function
    _contentController.removeListener(_contentControllerListener);
    _contentController.addListener(_contentControllerListener);
  }

  //Get existing note if it exists, otherwise create a new note
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    //Get note from previous view if applicable
    final currentNote = context.getArgument<CloudNote>();
    if (currentNote != null) {
      //Update existing note
      _note = currentNote;

      //Set original values
      originalDateTime = currentNote.dateTime;
      originalTitle = currentNote.title;
      originalContent = currentNote.content;
      originalCategories = currentNote.categories;

      
      //Prepopulate fields with existing note's content
      _titleController.text = currentNote.title;
      _contentController.text = currentNote.content;
      List selectedCategories = currentNote.categories;
      shouldCheckPersonal = selectedCategories.contains("Personal");
      shouldCheckSchool = selectedCategories.contains("School");
      shouldCheckWork = selectedCategories.contains("Work");

      return currentNote;
    }

    //Reach here means did not get note from previous view. Create a new note
    final existingNote = _note;

    if (existingNote != null) {
      //Prevents continous creation of the same note during hot reload
      return existingNote;
    } else {
      final currentUser = AuthService.createFromFirebase().getCurrentUser!;
      final userId = currentUser.id;
      final newNote = await _notesService.createNewNote(ownerUserId: userId);

      //Set late variables
      shouldCheckPersonal = false;
      shouldCheckSchool = false;
      shouldCheckWork = false;
      originalTitle = '';
      originalContent = '';
      originalCategories = [];
      originalDateTime = DateTime.now().toString().substring(0, 19);
      _note = newNote;
      return newNote;
    }
  }
  


  //Checks if note is empty and if so, delete it
  void _deleteNoteIfTextIsEmpty() {
    final noteToCheck = _note;
    if (_titleController.text.isEmpty && _contentController.text.isEmpty && noteToCheck != null) {
      _notesService.deleteNote(noteId: noteToCheck.noteId);
    }
  }

  //Checks if note is not empty and if so, save it
  void _saveNoteIfTextNotEmpty() async {
    final noteToCheck = _note;
    final title = _titleController.text;
    final content = _contentController.text;
    final List<String> categories = [];

    if (shouldCheckPersonal) {
      categories.add("Personal");
    }
    if (shouldCheckSchool) {
      categories.add("School");
    }
    if (shouldCheckWork) {
      categories.add("Work");
    }

    //Check if changes are made
    bool shouldUpdateTime = false;
    if (title != originalTitle || content != originalContent) {
      shouldUpdateTime = true;
    } else if (categories.length != originalCategories.length) {
      shouldUpdateTime = true;
    } else {
      //Reach here means title and content same, and categories same length
      for (int i = 0; i < categories.length; i = i + 1) {
        if (! originalCategories.contains(categories[i])) {
          shouldUpdateTime = true;
          break;
        }
      }
    }

    if (noteToCheck != null && title.isNotEmpty && content.isNotEmpty) {
      //Case 1: Title and content are not empty
      await _notesService.updateNote(
      noteId: noteToCheck.noteId,
      updatedTitle: title,
      updatedContent: content,
      updatedDateTime: (shouldUpdateTime)
                       ? DateTime.now().toString().substring(0, 19)
                       : noteToCheck.dateTime,
      updatedCategories: categories);

    } else if (noteToCheck != null && title.isEmpty && content.isNotEmpty) {
      //Case 2: Title empty but content not empty
      await _notesService.updateNote(
        noteId: noteToCheck.noteId,
        updatedTitle: "No title",
        updatedContent: content,
        updatedDateTime: (shouldUpdateTime)
                       ? DateTime.now().toString().substring(0, 19)
                       : noteToCheck.dateTime,
        updatedCategories: categories
      );
    } else if (noteToCheck != null && title.isNotEmpty && content.isEmpty) {
      //Case 3: Title is not empty but content is empty
      await _notesService.updateNote(
        noteId: noteToCheck.noteId,
        updatedTitle: title,
        updatedContent: "No content",
        updatedDateTime: (shouldUpdateTime)
                       ? DateTime.now().toString().substring(0, 19)
                       : noteToCheck.dateTime,
        updatedCategories: categories);
    }
  }


  @override
  void dispose() async {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }


  //Builds back button
  Widget buildBackButton() {
    //Back button
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          //Force keyboard to close
          _deleteNoteIfTextIsEmpty();
          _saveNoteIfTextNotEmpty();
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 200));
          //Navigate to login screen
          Navigator.of(context).pop();
        },
      child: const Icon(
        Icons.arrow_back_outlined,
        color: Colors.black,
        size: 36,
        )
      )
    );
  }

  //Builds pop up menu widget
  Widget buildPopupMenuWidget() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 30, 0),
        child: PopupMenuButton<NotesViewMenuAction>(
          icon: const Icon(
            Icons.more_vert,
            color: darkBlueColour,
            size: 36,
          ), onSelected: (value) async {
            switch (value) {
              case NotesViewMenuAction.deleteNote:
                //Ask user for confirmation
                final shouldDeleteNote = await showDeleteSingleNoteDialog(context);
                if (shouldDeleteNote) {
                  //User confirms that he wants to delete note
                  final noteToDelete = _note;
                  if (noteToDelete != null) {
                    _notesService.deleteNote(noteId: noteToDelete.noteId);
                  } else {
                    //Note is not present. No need to delete
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                  await Future.delayed(const Duration(milliseconds: 200));
                  //Navigate to login screen
                  Navigator.of(context).pop();
                }
                break;
              case NotesViewMenuAction.generatePdf:
                if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                  showErrorDialog(context, "You must write something in both the note's title and content to generate a PDF.");
                  return;
                }

                LoadingScreen().show(context: context, text: "Generating PDF...");
                PdfNote pdfNote = PdfNote(
                  noteTitle: _titleController.text,
                  noteContent: _contentController.text,
                  personalCategory: shouldCheckPersonal ? "Personal" : "",
                  schoolCategory: shouldCheckSchool ? "School" : "",
                  workCategory: shouldCheckWork ? "Work" : "",
                  noteDateTime: _note?.dateTime.substring(0, 16) ?? 'No date and time'
                );
                final pdfFile = await pdfNote.generatePdf();
                LoadingScreen().hide();
                PdfApi.openFile(pdfFile);
                break;
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: NotesViewMenuAction.deleteNote,
                child: Text('Delete Note'),
              ),
              const PopupMenuItem(
                value: NotesViewMenuAction.generatePdf,
                child: Text('Generate PDF')),
            ];
          }
        ),
    );
  }

  //Builds date time widget
  Widget buildDateTimeWidget() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text(
          originalDateTime.substring(0, 16),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: lightGrayColour,
          )
        ),
      ),
    );

  }

  //Builds title widget
  Widget buildTitleWidget() {
    return const Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: Text(
          "Title",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          )
        ),
      ),
    );
  }

  //Builds title text field widget
  Widget buildTitleTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
      child: TextFormField(
        controller: _titleController,
        obscureText: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: 'Enter a title for your note',
          hintStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: lightGrayColour,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: darkBlueColour,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        keyboardType: TextInputType.text
      ),
    );
  }

  //Builds content widget
  Widget buildContentWidget() {
     return const Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
        child: Text(
          "Content",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          )
        ),
      ),
    );
  }

  //Builds content text field widget
  Widget buildContentTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
      child: TextFormField(
        style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            height: 1.5,
            
        ),
        controller: _contentController,
        obscureText: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: 'Enter content for your note',
          hintStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: lightGrayColour,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: darkBlueColour,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 5,
      ),
    );
  }

  //Builds category widget
  Widget buildCategoryWidget() {
     return const Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
        child: Text(
          "Category",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          )
        ),
      ),
    );
  }
 
  //Builds checkbox
  Widget buildCheckboxes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
      child: Column(
        children: [
          //Personal
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Text(
                      "Personal",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      )
                    ),
                  ),
                ),
          
                SizedBox(
                  width: 30,
                  height: 30,
                  child: RoundCheckBox(
                    isChecked: shouldCheckPersonal,
                    borderColor: lightGrayColour,
                    checkedColor: darkBlueColour,
                    onTap: (selected) {
                      shouldCheckPersonal = ! (shouldCheckPersonal);
                    } 
                  ),
                ),
              ],
            ),
          ),

          //School
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Text(
                      "School",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      )
                    ),
                  ),
                ),
          
                SizedBox(
                  width: 30,
                  height: 30,
                  child: RoundCheckBox(
                    isChecked: shouldCheckSchool,
                    borderColor: lightGrayColour,
                    checkedColor: darkBlueColour,
                    onTap: (selected) {
                      shouldCheckSchool = ! (shouldCheckSchool);
                    } 
                  ),
                ),
              ],
            ),
          ),

          //Work
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Text(
                      "Work",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      )
                      
                      ),
                  ),
                ),
          
                SizedBox(
                  width: 30,
                  height: 30,
                  child: RoundCheckBox(
                    isChecked: shouldCheckWork,
                    borderColor: lightGrayColour,
                    checkedColor: darkBlueColour,
                    onTap: (selected) {
                      if (! shouldCheckWork) {
                        shouldCheckWork = ! (shouldCheckWork);
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );       
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  createOrGetExistingNote(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            //Future returns a Future<DatabaseNote>. Hence, the latest data received from the
            //asynchronous operation will be of type DatabaseNote after the Future completes.
            _setUpTitleControllerListener();
            _setUpContentControllerListener();
            return GestureDetector(
              onTap:() {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                backgroundColor: lightBlueBackgroundColour,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Top app bar
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
          
                              buildBackButton(),
                              buildPopupMenuWidget(),
            
                            ],
                          ),
                        ),
          
          
                        buildDateTimeWidget(),
                        buildTitleWidget(),
                        buildTitleTextField(),
                        buildContentWidget(),
                        buildContentTextField(),
                        buildCategoryWidget(),
                        buildCheckboxes(),
          
                      ]
                    ),
                  ),
                ),
              ),
            );
    
          default:
            //New note is still being created. Wait for new note to be created in the database
            return Scaffold(
              backgroundColor: lightBlueBackgroundColour,
              body: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text("Please hold on"),
                    ),
                  ],
                ),
              )
            );
            
            
    
        }
      }
    );
  }

}



// //Builds category drop down field
  // Widget buildCategoryDropdownField() {
  //   return Align(
  //     alignment: Alignment.topLeft,
  //     child: SizedBox(
  //       width: MediaQuery.of(context).size.width * 0.6,
  //       child: Padding(
  //         padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
  //         child: DropdownButtonFormField(
  //           //Make down arrow to far right and set hint text
  //           isExpanded: true,
  //           hint: const Text(
  //             "Select Category",
  //             style: TextStyle(
  //               fontFamily: "Roboto",
  //               fontWeight: FontWeight.w400,
  //               fontSize: 16,
  //               color: lightGrayColour,
  //             )
  //           ),
      
  //           //Initial value in dropdown list
  //           value: _dropdownValue,
            
  //           //Down arrow icon in dropdown list
  //           icon: const Icon(
  //             Icons.keyboard_arrow_down,
  //             color: lightGrayColour,
  //           ),
      
  //           //Set decoration for dropdown list
  //           decoration: InputDecoration(
  //             filled: true,
  //             fillColor: Colors.white,
  //             contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: const BorderSide(
  //                 color: Colors.white,
  //                 width: 2,
  //               ),
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: const BorderSide(
  //                 color: darkBlueColour,
  //                 width: 2,
  //               ),
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             errorBorder: OutlineInputBorder(
  //               borderSide: const BorderSide(
  //                 color: Colors.red,
  //                 width: 2,
  //               ),
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             focusedErrorBorder: OutlineInputBorder(
  //               borderSide: const BorderSide(
  //                 color: Colors.red,
  //                 width: 2,
  //               ),
  //               borderRadius: BorderRadius.circular(20),
  //             )
  //           ),

      
  //           //Prepopulate dropdown field with list of categories 
  //           items: categories.map((category) =>
  //             DropdownMenuItem(
  //               value: category,
  //               child: Text(category),
  //             )
  //           ).toList(),
      
  //           //Update dropdown value when selection changes
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               _dropdownValue = newValue ?? "";
  //               _categoryControllerListener();

  //             });
                
  //           },
  //         ),   
  //       ),
  //     ),
  //   );
  // }