import 'package:flutter/material.dart';

import '../Model/Note/NoteList.dart';

class NoteProvider with ChangeNotifier{
  NoteList _noteList = NoteList();

  get noteList => _noteList.data;
  set setNoteList (NoteList noteList){
    _noteList = noteList;
    notifyListeners();
  }
}