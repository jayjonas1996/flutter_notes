import 'dart:convert';
import 'package:flutter/material.dart';


class Note {
  int id;
  String title;
  String content;
  DateTime date_created;
  DateTime date_last_edited;
  Color note_color;
  int is_archived = 0;

  Note(this.id, this.title, this.content, this.date_created, this.date_last_edited,this.note_color);


  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
//      'id': id,  since id is auto incremented in the database we don't need to send it to the insert query.
      'title': utf8.encode(title),
      'content': utf8.encode( content ),
      'date_created': epochFromDate( date_created ),
      'date_last_edited': epochFromDate( date_last_edited ),
      'note_color': note_color.value,
      'is_archived': is_archived  //  for later use for integrating archiving
    };
    if(forUpdate){
      data["id"] = this.id;
    }
    return data;
  }

// Converting the date time object into int representing seconds passed after midnight 1st Jan, 1970 UTC
int epochFromDate(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000 ;
}

void archiveThisNote() {
      is_archived = 1;
}

// overriding toString() of the note class to print a better debug description of this custom class
@override toString() {
  return {
    'id': id,
    'title': title,
    'content': content ,
    'date_created': epochFromDate( date_created ),
    'date_last_edited': epochFromDate( date_last_edited ),
    'note_color': note_color.toString(),
    'is_archived':is_archived
  }.toString();
}

}