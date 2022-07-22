import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';

late Timer timer;

//API KEY & SECRET is required for below methods to work
//Join Meeting With Meeting ID & Password
joinMeeting(BuildContext context, meetingId, meetingPassword, patientName) {
  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid) {
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    } else {
      result = status == "MEETING_STATUS_IDLE";
    }

    return result;
  }

  if (meetingId.isNotEmpty && meetingPassword.isNotEmpty) {
    ZoomOptions zoomOptions = ZoomOptions(
      domain: "zoom.us",
      appKey: "ljjuf0Vwnm7kJZ5dm2jDsNi2G9lA7PWNCDNu", //API KEY FROM ZOOM
      appSecret: "NRhLBSCnu4BzfJK5GouUSxoK7UEt84bBNt0Q", //API SECRET FROM ZOOM
    );
    var meetingOptions = ZoomMeetingOptions(
        userId: patientName,

        /// pass username for join meeting only --- Any name eg:- EVILRATT.
        meetingId: meetingId,

        /// pass meeting id for join meeting only
        meetingPassword: meetingPassword,

        /// pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        disableTitlebar: "false",
        viewOptions: "true",
        noAudio: "false",
        noDisconnectAudio: "false");

    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStatus().listen((status) {
          if (kDebugMode) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          }
          if (_isMeetingEnded(status[0])) {
            if (kDebugMode) {
              print("[Meeting Status] :- Ended");
            }
            timer.cancel();
          }
        });
        if (kDebugMode) {
          print("listen on event channel");
        }
        zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
          timer = Timer.periodic(const Duration(seconds: 2), (timer) {
            zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
              if (kDebugMode) {
                print("[Meeting Status Polling] : " +
                    status[0] +
                    " - " +
                    status[1]);
              }
            });
          });
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("[Error Generated] : " + error);
      }
    });
  } else {
    if (meetingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter a valid meeting id to continue."),
      ));
    } else if (meetingPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter a meeting password to start."),
      ));
    }
  }
}

//Start Meeting With Random Meeting ID ----- Emila & Password For Zoom is required.
startMeeting(BuildContext context) {
  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid) {
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    } else {
      result = status == "MEETING_STATUS_IDLE";
    }

    return result;
  }

  ZoomOptions zoomOptions = ZoomOptions(
    domain: "zoom.us",
    appKey: "ljjuf0Vwnm7kJZ5dm2jDsNi2G9lA7PWNCDNu", //API KEY FROM ZOOM
    appSecret: "NRhLBSCnu4BzfJK5GouUSxoK7UEt84bBNt0Q", //API SECRET FROM ZOOM
  );
  var meetingOptions = ZoomMeetingOptions(
      userId: 'szzz123t0@gmail.com',
      userPassword: 'b29\$yQsjmDS4EnU', //pass host password for zoom
      disableDialIn: "false",
      disableDrive: "false",
      disableInvite: "false",
      disableShare: "false",
      disableTitlebar: "false",
      viewOptions: "true",
      noAudio: "false",
      noDisconnectAudio: "false");

  var zoom = ZoomView();
  zoom.initZoom(zoomOptions).then((results) {
    if (results[0] == 0) {
      zoom.onMeetingStatus().listen((status) {
        if (kDebugMode) {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
        }
        if (_isMeetingEnded(status[0])) {
          if (kDebugMode) {
            print("[Meeting Status] :- Ended");
          }
          timer.cancel();
        }
        if (status[0] == "MEETING_STATUS_INMEETING") {
          zoom.meetinDetails().then((meetingDetailsResult) {
            if (kDebugMode) {
              print("[MeetingDetailsResult] :- " +
                  meetingDetailsResult.toString());
            }
          });
        }
      });
      zoom.startMeeting(meetingOptions).then((loginResult) {
        if (kDebugMode) {
          print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
        }
        if (loginResult[0] == "SDK ERROR") {
          //SDK INIT FAILED
          if (kDebugMode) {
            print((loginResult[1]).toString());
          }
          return;
        } else if (loginResult[0] == "LOGIN ERROR") {
          //LOGIN FAILED - WITH ERROR CODES
          if (kDebugMode) {
            if (loginResult[1] ==
                ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
              print("Multiple Failed Login Attempts");
            }
            print((loginResult[1]).toString());
          }
          return;
        } else {
          //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
          if (kDebugMode) {
            print((loginResult[0]).toString());
          }
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("[Error Generated] : " + error);
        }
      });
    }
  }).catchError((error) {
    if (kDebugMode) {
      print("[Error Generated] : " + error);
    }
  });
}

//Start Meeting With Custom Meeting ID ----- Emila & Password For Zoom is required.
startMeetingNormal(BuildContext context, meetingId) {
  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid) {
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    } else {
      result = status == "MEETING_STATUS_IDLE";
    }

    return result;
  }

  ZoomOptions zoomOptions = ZoomOptions(
    domain: "zoom.us",
    appKey: "ljjuf0Vwnm7kJZ5dm2jDsNi2G9lA7PWNCDNu", //API KEY FROM ZOOM
    appSecret: "NRhLBSCnu4BzfJK5GouUSxoK7UEt84bBNt0Q", //API SECRET FROM ZOOM
  );
  var meetingOptions = ZoomMeetingOptions(
      userId: 'szzz123t0@gmail.com',
      userPassword: 'b29\$yQsjmDS4EnU', //pass host password for zoom
      meetingId: meetingId, //
      disableDialIn: "false",
      disableDrive: "false",
      disableInvite: "false",
      disableShare: "false",
      disableTitlebar: "false",
      viewOptions: "false",
      noAudio: "false",
      noDisconnectAudio: "false");

  var zoom = ZoomView();
  zoom.initZoom(zoomOptions).then((results) {
    if (results[0] == 0) {
      zoom.onMeetingStatus().listen((status) {
        if (kDebugMode) {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
        }
        if (_isMeetingEnded(status[0])) {
          if (kDebugMode) {
            print("[Meeting Status] :- Ended");
          }
          timer.cancel();
        }
        if (status[0] == "MEETING_STATUS_INMEETING") {
          zoom.meetinDetails().then((meetingDetailsResult) {
            if (kDebugMode) {
              print("[MeetingDetailsResult] :- " +
                  meetingDetailsResult.toString());
            }
          });
        }
      });
      zoom.startMeetingNormal(meetingOptions).then((loginResult) {
        if (kDebugMode) {
          print("[LoginResult] :- " + loginResult.toString());
        }
        if (loginResult[0] == "SDK ERROR") {
          //SDK INIT FAILED
          if (kDebugMode) {
            print((loginResult[1]).toString());
          }
        } else if (loginResult[0] == "LOGIN ERROR") {
          //LOGIN FAILED - WITH ERROR CODES
          if (kDebugMode) {
            print((loginResult[1]).toString());
          }
        } else {
          //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
          if (kDebugMode) {
            print((loginResult[0]).toString());
          }
        }
      });
    }
  }).catchError((error) {
    if (kDebugMode) {
      print("[Error Generated] : " + error);
    }
  });
}
