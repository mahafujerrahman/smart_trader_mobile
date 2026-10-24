import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/config/utils/custom_toast.dart';
import 'package:smart_trader_mobile/app/core/routes/routes.dart';
import 'package:smart_trader_mobile/app/core/service/api_checker.dart';
import 'package:smart_trader_mobile/app/core/service/api_client.dart';
import 'package:smart_trader_mobile/app/core/service/api_constants.dart';
import 'package:smart_trader_mobile/app/core/service/customLog.dart';
import 'package:smart_trader_mobile/app/helpers/prefs_helpers.dart';

class AuthController extends GetxController {
  TextEditingController logInUserNameCtrl = TextEditingController();
  TextEditingController logInPassCtrl = TextEditingController();


  var logInLoading = false.obs;
  final RxBool rememberMe = false.obs;

  Future<void> logInMethod() async {
    logInLoading(true);

    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {
        "login": logInUserNameCtrl.text.trim(),
        "password": logInPassCtrl.text.trim(),
      };

      Response response = await ApiClient.postData(
        //ApiConstants.logInEndPoint,
        "https://peanut.ifxdb.com/api/ClientCabinetBasic/IsAccountCredentialsCorrect",
        body,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await PrefsHelper.setString(
            AppConstants.bearerToken, response.body['token']);
        await PrefsHelper.setBool(AppConstants.isLogged, rememberMe.value);
        String userRole = response.body['results']['user']['base_role'];
        await PrefsHelper.setString(AppConstants.userRole, userRole);
        print('===================>> User Role: $userRole');
        print('===================>> Remember me : $rememberMe');


        Get.offAllNamed(AppRoutes.splashScreen);
        Get.snackbar('Successfully', 'Logged in as Admin');

        AppCustomToast.showIphoneSnackbar('Error', response.body['message'], 3);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      customLog('Login Exception: $e');
    } finally {
      logInLoading(false);
    }
  }

}
