final url = "http://10.1.160.177:3001";

//auth
final register = url + '/api/register';
final login = url + "/api/mobilelogin";

// student
final getStudinfo = url + "/api/student/getMyInfo";
final getStudAtt = url + "/api/student/getAtt";
final getStudProgress = url + "/api/mentor/getStudentPlacementProgress";
final getStudMentor = url + "/api/parent/getMentorDetails";
final getStuComp = url + "/api/student/getComp";
final getAttevts = url + "/api/student/getEventAtt";
final postFeedBack = url + "/api/student/postStuMenFeed";

// Attendancep
final markAtt = url + "/api/admin/markAtt";
final submitStdAtt = url + "/api/admin/submitStdAtt";

//faculty coordinator
final getEvents = url + "/api/admin/getEvents";
final getSingleEvent = url + "/api/admin/getEvent";
final getQrtokens = url + "/api/admin/startQrSession";
