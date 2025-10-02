import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wish/Screen/Note/memberListPage.dart';
import 'package:wish/Screen/Note/noteListPage.dart';

import 'package:wish/Screen/Widget/appBar.dart';
import 'package:wish/Screen/Jobs/JobList_Customer.dart';

import '../Model/Note/NoteList.dart';
import '../Model/Token.dart';
import '../Model/User/memberlist.dart';
import '../Provider/NoteProvider.dart';
import '../Provider/UserProvider.dart';
import '../Service.dart';
import 'MenuScreen/menuScreen.dart';
import 'dart:js' as js;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key,});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late final ValueNotifier<List<Event>> _selectedEvents;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarStyle _customCalendarStyle = const CalendarStyle(
    // Use `CalendarStyle` to customize the UI
    outsideDaysVisible: false,
    markersMaxCount: 1,
    markerDecoration: BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
    ),
    todayDecoration: BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
    ),
    selectedDecoration : const BoxDecoration(
      color: Color(0xff50C7E1),
      shape: BoxShape.circle,
    ),
  );

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    WidgetsBinding.instance.addPostFrameCallback((_)=>Notice());
  }

  Future<void> Notice() async{
    NoteProvider note=Provider.of<NoteProvider>(context,listen: false);

    var json=await Service().Fetch('', 'get', '/api/notices',);
    if(json==false) return;
    else {
      try {
        var data = NoteList.fromJson(json);
        if(data.code=='success'&&data.data!=null&&data.data!.length>0){
          note.setNoteList=data;
          note.setNoteData(data,context);
        }
        else return;
      } catch(e){
        print(e);
      }
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    NoteProvider note=Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '메인',
          pop: false,
          action: MenuScreenButton(context),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: (MediaQuery
              .of(context)
              .size
              .width) / (MediaQuery
              .of(context)
              .size
              .height) < 4 / 3 ? (MediaQuery
              .of(context)
              .size
              .width) * 0.9 : (MediaQuery
              .of(context)
              .size
              .width) * 0.6,
          child: Expanded(
              child: (MediaQuery
                  .of(context)
                  .size
                  .width) / (MediaQuery
                  .of(context)
                  .size
                  .height) < 1 ?
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      child: FirstColumn(context)
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: SecondColumn(context,user.role,note),
                  ),
                ],
              ) : Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: FirstColumn(context),),
                  SizedBox(width: 20,),
                  Flexible(
                    flex: 1,
                    child: SecondColumn(context,user.role,note),)
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget MenuScreenButton(BuildContext context)=>Padding(
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(15),
        backgroundColor: Colors.white,
        minimumSize: Size.zero,
      ),
      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen())),
      child: Text('마이페이지',style: TextStyle(color: Color(0xff50C7E1),),
      ),),
  );
  Widget ImageButton(BuildContext context)=>Container(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // 버튼 내부 패딩 제거
        backgroundColor: Colors.transparent, // 배경색 제거
        shadowColor: Colors.transparent, // 그림자 제거
      ),
      onPressed: ()=>js.context.callMethod('open', ['https://linktr.ee/wish.clean']),
      child: Image.asset('assets/image/ImageButton.png',),
    ),
  );

  Widget FirstColumn(BuildContext context)=>Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar<Event>(
              locale: 'ko_KR',
              firstDay: DateTime(DateTime.now().year-1,DateTime.now().month,DateTime.now().day),
              lastDay: DateTime(DateTime.now().year+1,DateTime.now().month,DateTime.now().day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              rangeSelectionMode: RangeSelectionMode.disabled,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false
              ),
              calendarStyle: _customCalendarStyle,
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Container(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color(0xff50C7E1),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      Container(
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 20),
              padding: EdgeInsets.all(20),
              elevation: 0,
              shadowColor: Color(0xffffff),
            ),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => JobList_Customer())),
            child: Text('신청 목록')),
      ),

    ],
  );

  Widget SecondColumn(BuildContext context,int role,NoteProvider note)=>Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10,bottom: 5),
        child: Text('공지사항',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            //  color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: note.noteList.code=='success'&&note.noteList.data!=null&&note.noteList.data!.length>0?
          PaginatedDataTable(
            source: note.noteData!,
            columns: const [
              DataColumn(label: Text('')),
              DataColumn(label: Text(''),numeric: true)
            ],
            headingRowHeight : 20,
            rowsPerPage: 5,
            dataRowMinHeight: 30,
            dataRowMaxHeight: 30,
            dividerThickness: 0.0001,
            showCheckboxColumn: false,
          ):Center(child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('공지가 없습니다.')))
      ),
      role>1?Row(
        children: [
          role>2?Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  elevation: 0,
                  shadowColor: Color(0xffffff),
                ),
                onPressed: () async{
                  NoteProvider note=Provider.of<NoteProvider>(context,listen: false);

                  var json=await Service().Fetch('', 'get', '/api/notices',);
                  if(json==false) return;
                  else {
                    try {
                      var data = NoteList.fromJson(json);
                      if(data.code=='success'&&data.data!=null&&data.data!.length>0){
                        note.setNoteList=data;
                        note.setNoteData(data,context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NoteListPage()));
                      }
                      else return;
                    } catch(e){
                      print(e);
                    }
                  }

                }, child: Text('게시글 관리')),
          ):SizedBox(),
          SizedBox(width: role>2?5:0,),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  elevation: 0,
                  shadowColor: Color(0xffffff),
                ),
                onPressed: () async {
                  UserProvider user=Provider.of<UserProvider>(context,listen: false);

                  var json=await Service().Fetch('', 'get', '/api/auth/users',await Token().AccessRead());
                  if(json==false) return;
                  else {
                    try {
                      var data = MemberList.fromJson(json);
                      if(data.code=='success'&&data.data!=null&&data.data!.total!>0){
                        user.memberList=data;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MemberListPage()));
                      }
                      else return;
                    } catch(e){
                      print(e);
                    }
                  }
                }, child: Text('회원 관리')),
          ),
        ],
      ):ImageButton(context),
    ],
  );
}

class Event {
  final String title;
  const Event(this.title);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(2025, 9, item * 5): List.generate(
      item % 4 + 1,
          (index) => Event('Event $item | ${index + 1}'),
    ),
}..addAll({
  /*
  kToday: [
    const Event("Today's Event 1"),
    const Event("Today's Event 2"),
  ],

   */
  DateTime.utc(2025,9,24) : [Event('이것은 이벤트입니다')]
});

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}