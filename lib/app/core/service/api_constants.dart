class ApiConstants {

///==========================================>> Online Site <<=================================
static const String baseUrl = "https://fmffms-backend.shadhinwifi.com/api/transmission";
static const String imageBaseUrl = "https://fmffms-backend.shadhinwifi.com/storage";

static String publishableKey = "pk_live_51QyxwfK3lw1JGCJoKuGpNyDzjDr5DAkWh5oigacG1PkJteMzlWqt9itz9M7DjzSLxx4h4IYavjiIPh2MHaQLexZB00aQIhRDP3";
static String secretKey = "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";


// ///==========================================>> Local Site <<=================================
/*
  static String socketServer = "https://backend.edcusers.com/api/v2/mobile";
  static const String baseUrl = "https://backend.edcusers.com/api/v2/mobile";
  static const String imageBaseUrl = "https://backend.edcusers.com/api/v2/mobile";

  static String publishableKey = "pk_test_51QTjKRJtUu9pfTzuSuEaEY565mkaOfSkT4gpppelUtB0vlwvudbAPE8UnZpK52xvSmg4bwowOQuGuoTF9FIBCVfW00Evwavb7Z";
  static String secretKey = "sk_test_51QTjKRJtUu9pfTzuSAqLmrEv3N1zd6LOD6g5XNDPJjSz3CGKCwBzqfFdRoIzOdOQA98GE4fe7O0juAyDvJBRTYUY005LAQxtgT";
*/


  ///===================== Google Api Key ===============
  static String googleBaseUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json";



  //============================ >> User Auth << =================================
  static const String logInEndPoint = "/login";
  static const String sentOTPEndPoint = "/forgot-credentials/send-otp";
  static const String verifyOTPEndPoint = "/forgot-credentials/verify-otp";
  static const String setNewPasswordOTPEndPoint = "/forgot-credentials/reset-password";
  static const String getUserProfileDetailsEndPoint = "/profile";
  //Admin
  static const String getEmployeesListEndPoint = "/employees/list";
  static const String employeesCreateEndPoint = "/employees/create";
  static const String getEmployeesDetailsByIDEndPoint = "/employees";
  static const String getAdminSurveyRequestListEndPoint = "/surveys/list";
  static const String getAdminAllSurveyorNameListEndPoint = "/employees/admin-list?designation=transmission_surveyor";
  static const String adminSurveyCreateEndPoint = "/surveys/create";
  static const String changePasswordEndPoint = "/profile/change-password";




}
