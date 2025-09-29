import 'package:flutter/material.dart';

import '../Model/Note/NoteList.dart';
import '../Screen/Widget/NoteDialog.dart';

class NoteProvider with ChangeNotifier{
  NoteList _noteList = NoteList();
  NoteData? noteData;

  get noteList => _noteList;
  set setNoteList (NoteList noteList){
    if(noteList.data!=null){
      List<Data> _pinnedList = [];
      List<Data> _list = [];
      noteList.data!.forEach((e)=>e.isPinned! ? _pinnedList.add(e):_list.add(e));
      noteList.data=_pinnedList+_list;
    }
    _noteList = noteList;
    notifyListeners();
  }

  setNoteData(NoteList noteList,BuildContext context){
    noteData = NoteData(context: context)..celldata=noteList.data!;
    notifyListeners();
  }
}

class NoteData extends DataTableSource{
  final BuildContext context;
  NoteData({required this.context});

  List<Data> celldata = [];

  @override
  DataRow? getRow(int index,) {
    return DataRow(cells: [
      DataCell(Text(celldata[index].noticeTitle??'제목')),
      DataCell(Text(celldata[index].createdAt??'시간')),
    ],onSelectChanged:(selected){
      if(selected!) NoteDialog().show(context, note:Data(
          noticeBody: celldata[index].noticeBody??'내용',
      noticeTitle: celldata[index].noticeTitle??'제목',
      createdBy: celldata[index].createdBy??'사람',
          createdAt: celldata[index].createdAt??'날짜'));
    });
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => celldata.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}
