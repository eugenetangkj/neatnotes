import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/enums/mynotes_menu_action.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/cloud/cloud_note_category.dart';
import 'package:neatnotes/utilities/dialogs/logout_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({ Key ? key}): super(key: key);

  @override
  State<CreateUpdateNoteView> createState() =>  _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  //Controllers for text fields
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  //Dropdown menu value
  String _dropdownValue = 'Personal';

  
  @override
  void initState() {
    // _notesService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
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
        controller: _contentController,
        obscureText: false,
        decoration: InputDecoration(
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

  //Builds category drop down field
  Widget buildCategoryDropdownField() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
          child: DropdownButtonFormField(
            //Make down arrow to far right and set hint text
            isExpanded: true,
            hint: const Text(
              "Select Category",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: lightGrayColour,
              )
            ),
      
            //Initial value in dropdown list
            value: _dropdownValue,
            
            //Down arrow icon in dropdown list
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: lightGrayColour,
            ),
      
            //Set decoration for dropdown list
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
              )
            ),

      
            //Prepopulate dropdown field with list of categories 
            items: categories.map((category) =>
              DropdownMenuItem(
                value: category,
                child: Text(category),
              )
            ).toList(),
      
            //Update dropdown value when selection changes
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue ?? "";
              });
            },
          ),   
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      buildBackButton(),
                      buildPopupMenuWidget(),
    
                    ],
                  ),
                ),

                buildTitleWidget(),
                buildTitleTextField(),
                buildContentWidget(),
                buildContentTextField(),
                buildCategoryWidget(),
                buildCategoryDropdownField(),

              ]
            ),
          ),
        ),
      ),
    );
  }
}
