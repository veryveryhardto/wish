import 'package:flutter/material.dart';
import 'package:wish/Model/Jobs/jobDetail.dart';
import '../Model/Jobs/jobs.dart';

class JobProvider with ChangeNotifier{
  Jobs addJob = Jobs();
  JobDetail _currentJobDetail = JobDetail();
  var _jobList;

  get currentJob => _currentJobDetail.data;
  set currentJobDetail(JobDetail job){
    _currentJobDetail=job;
    notifyListeners();
  }

  get jobList => _jobList;
  set setJobList (var jobList){
    _jobList=jobList;
    notifyListeners();
  }
}