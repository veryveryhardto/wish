import 'package:flutter/material.dart';
import 'package:wish/Model/Jobs/jobDetail.dart';
import 'package:wish/Model/Jobs/jobList.dart';
import 'package:wish/Model/Jobs/jobList_Customer.dart';
import '../Model/Jobs/jobs.dart';
import '../Model/Memo/memoList.dart';

class JobProvider with ChangeNotifier{
  Jobs addJob = Jobs();
  JobDetail _currentJobDetail = JobDetail();
  JobList_Customer jobList_customer=JobList_Customer();
  JobList jobList = JobList();
  MemoList memoList = MemoList();

  get currentJob => _currentJobDetail.data;
  set currentJobDetail(JobDetail job){
    _currentJobDetail=job;
    notifyListeners();
  }

  set setJobList (var joblist){
    if(joblist.runtimeType==JobList_Customer)jobList_customer=joblist;
    if(joblist.runtimeType==JobList)jobList=joblist;
    notifyListeners();
  }

  AddMemo(var memo){
    memoList.data!.add(memo);
    notifyListeners();
  }
}