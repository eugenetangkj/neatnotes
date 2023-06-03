
//Adapted from https://github.com/JohannesMilke/generate_pdf_example

import 'dart:io';

import 'package:neatnotes/services/pdf/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfNote {
  //Details of notes to be printed in pdf
  final String noteTitle;
  final String noteContent;
  final String personalCategory;
  final String schoolCategory;
  final String workCategory;
  final String noteDateTime;

  PdfNote({
    required this.noteTitle,
    required this.noteContent,
    required this.personalCategory,
    required this.schoolCategory,
    required this.workCategory,
    required this.noteDateTime,
  });


Future<File> generatePdf() async {
  //Initialise PDF document
  final pdf = Document();


  pdf.addPage(
    MultiPage(
      header: (context) {
        //Header
        return buildHeader(noteDateTime);
      },
      build: (context) => <Widget> [
        //Note title
        buildCustomHeadline(noteTitle),

        //Categories title
        buildCustomSubheadline("Categories"),

        //Note categories
        ...buildBulletPoints(personalCategory, schoolCategory, workCategory),



        //Note content
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Paragraph(text: noteContent),
        )






      ] 
    ),
  );
  return PdfApi.saveDocument(name: '$noteTitle.pdf', pdf: pdf);
  } 

  //Builds a header
  static Widget buildHeader(String headerText) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(bottom: 3* PdfPageFormat.mm),
      decoration: const BoxDecoration(
        border: Border(),
        // border: Border(bottom: BorderSide(width: 2, color: PdfColors.black)),
      ),
      child: Text(
              headerText,
              style: const TextStyle(fontSize: 12, color: PdfColors.black),
      ),
    );
  }

  //Builds a headline
  static Widget buildCustomHeadline(String headline) {
    return Header(
        child: Text(
          headline,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        decoration: const BoxDecoration(
          border: Border()),

      );
  }

  //Builds a sub headline
  static Widget buildCustomSubheadline(String subheadline) {
    return Header(
        child: Text(
          subheadline,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: const BoxDecoration(
          border: Border(),
        )
    );
  }



  //Builds bullet points
  static List<Widget> buildBulletPoints(String personalCategory, String schoolCategory, String workCategory) {
    List<Widget> outputBulletPoints = [];
    if (personalCategory.isNotEmpty) {
      outputBulletPoints.add(Bullet(text: personalCategory));
    }
    if (schoolCategory.isNotEmpty) {
      outputBulletPoints.add(Bullet(text: schoolCategory));
    }
    if (workCategory.isNotEmpty) {
      outputBulletPoints.add(Bullet(text: workCategory));
    }
    if (outputBulletPoints.isEmpty) {
      outputBulletPoints.add(Bullet(text: "No categories assigned"));
    }
    return outputBulletPoints;
  }

}