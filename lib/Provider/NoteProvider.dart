import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../Model/Note/NoteList.dart';
import '../Screen/Widget/NoteDialog.dart';

class NoteProvider with ChangeNotifier{
  NoteList noteList = NoteList();
  NoteData noteData = NoteData();

  set setNoteList (NoteList note){
    if(noteList.data!=null){
      List<Data> _pinnedList = [];
      List<Data> _list = [];
      noteList.data!.forEach((e)=>e.isPinned! ? _pinnedList.add(e):_list.add(e));
      noteList.data=_pinnedList+_list;
    }
    noteList = note;
    notifyListeners();
  }

  setNoteData(NoteList note,BuildContext context){
    noteData = NoteData(context: context)..celldata=note.data!;
    notifyListeners();
  }
}

class NoteData extends DataTableSource{
  final BuildContext? context;
  NoteData({this.context});
  Size screenSize = WidgetsBinding.instance.window.physicalSize;
  late double width = screenSize.width;
  late double height = screenSize.height;

  List<Data> celldata = [Data(noticeTitle: "기이이이이이이이이이인제목",createdAt: DateTime.parse("2025-10-10")),Data(noticeTitle: "기이이이이이이이이이인제목",createdAt: DateTime.parse("2025-10-01")),Data(noticeTitle: "기이이이이이이이이이인제목",createdAt: DateTime.parse("2025-10-10")),Data(noticeTitle: "기이이이이이이이이이인제목",createdAt: DateTime.parse("2025-10-10")),Data(noticeTitle: "기이이이이이이이이이인제목",createdAt: DateTime.parse("2025-10-10"))];

  @override
  DataRow? getRow(int index,) {
    return DataRow(cells: [
      DataCell(Row(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(child: Text(celldata[index].noticeTitle??'제목',style:
            TextStyle(fontWeight: celldata[index].isPinned??false ? FontWeight.bold:FontWeight.normal,
              fontSize: width/height<1 ? 13 : 16
            ),)),
          DateTime.now().difference(celldata[index].createdAt!).inDays<3?Text('  new',style: TextStyle(color: Color(0xff50C7E1),fontSize:  width/height<1 ? 10:13),):SizedBox()
        ],
      )),
      DataCell(Text(celldata[index].createdAt.toString().substring(0,10),style: TextStyle(fontWeight: celldata[index].isPinned??false ? FontWeight.bold:FontWeight.normal),)),
    ],onSelectChanged:(selected) {
      if(selected!) SchedulerBinding.instance.addPostFrameCallback((_) {
        NoteDialog().show(context!, note:Data(
          isPinned: celldata[index].isPinned??false,
          noticeUuid: celldata[index].noticeUuid??'',
            noticeBody: celldata[index].noticeBody??'내용',
            noticeTitle: celldata[index].noticeTitle??'제목',
            createdBy: celldata[index].createdBy??'사람',
            createdAt: celldata[index].createdAt??DateTime(2000)),
        );
      });
    }
    );
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
