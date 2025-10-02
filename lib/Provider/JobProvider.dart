import 'package:flutter/material.dart';
import 'package:wish/Model/Jobs/jobDetail.dart';
import 'package:wish/Model/Jobs/jobList.dart';
import '../Model/Jobs/jobs.dart';

class JobProvider with ChangeNotifier{
  Jobs addJob = Jobs();
  JobDetail _currentJobDetail = JobDetail();
  var jobList;

  get currentJob => _currentJobDetail.data;
  set currentJobDetail(JobDetail job){
    _currentJobDetail=job;
    notifyListeners();
  }

  set setJobList (var joblist){
    jobList=joblist;
    notifyListeners();
  }
}